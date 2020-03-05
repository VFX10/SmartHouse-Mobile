import 'dart:developer';
import 'dart:ui';

import 'package:Homey/app_data_manager.dart';
import 'package:Homey/helpers/sql_helper/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/buttons/customButton.dart';


import 'package:progress_dialog/progress_dialog.dart';

import 'package:Homey/design/widgets/textfield.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Homey/helpers/forms_helpers/form_validations.dart';
import 'package:Homey/helpers/forms_helpers/forms_helpers.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:Homey/screens/home/home.dart';
import 'package:Homey/screens/register/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Login> {
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  ProgressDialog progressBar;
  final FocusNode emailFocusNode = FocusNode(), passwordFocusNode = FocusNode();
  bool isPasswordVisible = true;
  bool formAutoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onError(dynamic e) {
    progressBar.dismiss();
    log('Error: ', error: e);
    Dialogs.showSimpleDialog('Error', e.toString(), context);
  }

  Future<dynamic> login() async {
    FocusScope.of(context).unfocus();

    final Map<String, dynamic> formData = <String, dynamic>{
      'email': emailController.text,
      'password': passwordController.text
    };
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      await progressBar.show();
      await WebRequestsHelpers.post(
        route: '/api/login',
        body: formData,
      ).then((dynamic response) async {
        progressBar.dismiss();
        final dynamic data = response.json();
        if (data['success'] != null) {
          final dynamic prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
          await SqlHelper().insert(data['data']);
          await AppDataManager().fetchData();
          await Navigator.pushReplacement<dynamic, dynamic>(context,
              MaterialPageRoute<dynamic>(builder: (_) => Home()));
        } else {
          Dialogs.showSimpleDialog('Error', response.json()['error'], context);
        }
      }, onError: onError);
    } else {
      setState(() {
        formAutoValidate = true;
      });
    }
  }

  void register() {
    FocusScope.of(context).unfocus();
    Navigator.push<dynamic>(
        context, MaterialPageRoute<dynamic>(builder: (_) => Register()));
  }

  @override
  Widget build(BuildContext context) {
    progressBar = Dialogs.showProgressDialog('Please wait...', context);
    return Scaffold(
      backgroundColor: ColorsTheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                autovalidate: formAutoValidate,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        'assets/images/Logo.png',
                        height: 60,
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Homey',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Sriracha',
                          fontSize: 35,
                        ),
                      ),
                    ),
                    CustomTextField(
                      inputType: TextInputType.emailAddress,
                      icon: const Icon(MdiIcons.email),
                      controller: emailController,
                      validator: FormValidation.emailValidator,
                      placeholder: 'Email',
                      focusNode: emailFocusNode,
                      onSubmitted: () {
                        FormHelpers.fieldFocusChange(
                            context, emailFocusNode, passwordFocusNode);
                      },
                    ),
                    CustomTextField(
                      isPassword: isPasswordVisible,
                      icon: const Icon(MdiIcons.lockOutline),
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      validator:  FormValidation.simpleValidator,
                      onSubmitted: login,
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: Icon(isPasswordVisible
                            ? MdiIcons.eyeOffOutline
                            : MdiIcons.eyeOutline),
                      ),
                      placeholder: 'Password',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: GestureDetector(
                        onTap: () => log('password Forgot'),
                        child: const Text(
                          'Forgot your password?',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: CustomButton(
                            text: 'Register',
                            isSecondary: true,
                            onPressed: register,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: CustomButton(
                            text: 'Login',
                            onPressed: login,
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
