import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_home_mobile/config.dart';
import 'package:smart_home_mobile/design/colors.dart';
import 'package:smart_home_mobile/design/dialogs.dart';
import 'package:smart_home_mobile/design/widgets/customButton.dart';
import 'dart:developer';

import 'package:smart_home_mobile/design/widgets/textfield.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_home_mobile/helpers/forms_helpers/form_validations.dart';
import 'package:smart_home_mobile/helpers/forms_helpers/forms_helpers.dart';
import 'package:smart_home_mobile/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:smart_home_mobile/screens/home/home.dart';
import 'package:smart_home_mobile/screens/register/register.dart';

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

  TextEditingController passwordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  var progressBar;
  final FocusNode emailFocusNode = new FocusNode(),
      passwordFocusNode = new FocusNode();
  bool isPasswordVisible = true;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData;
  bool formAutoValidate = false;
Image logoImage;
  void onError(e) {
    progressBar.dismiss();
    log('Error: ', error: e);
    Dialogs.showSimpleDialog("Error", e.toString(), context);
  }

  void login() async {
    FocusScope.of(context).unfocus();
    _formData = {
      'email': emailController.text,
      'password': passwordController.text
    };
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();


      await progressBar.show();
      WebRequestsHelpers.post(route: '/api/login', body: _formData).then(
          (response) {
        progressBar.dismiss();

        if (response.json()['success'] != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          Dialogs.showSimpleDialog("Error", response.json()['error'], context);
        }
      }, onError: onError);
//      progressBar.dismiss();
    } else {
      setState(() {
        formAutoValidate = true;
      });
    }
  }

  void register() {
    FocusScope.of(context).unfocus();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Register()));
  }
  @override
  void initState() {

    logoImage = Image.asset(
      'assets/images/Logo.png',
      height: 60,
    );
    super.initState();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(logoImage.image, context);
  }
  @override
  Widget build(BuildContext context) {
    progressBar = Dialogs.showProgressDialog('Please wait...', context);
    return Scaffold(
      backgroundColor: ColorsTheme.background,
      body: Builder(
        builder: (context) => Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Form(
                  key: _formKey,
                  autovalidate: formAutoValidate,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Center(
                        child: logoImage,
                      ),
                      Center(
                        child: Text(
                          "Homey",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Sriracha',
                            fontSize: 35,
                          ),
                        ),
                      ),
                      CustomTextField(
                        inputType: TextInputType.emailAddress,
                        icon: Icon(MdiIcons.email),
                        controller: emailController,
                        validator: (value) =>
                            FormValidation.emailValidator(value),
                        placeholder: "Email",
                        focusNode: emailFocusNode,
                        onSubmitted: () {
                          FormHelpers.fieldFocusChange(
                              context, emailFocusNode, passwordFocusNode);
                        },
                      ),
                      CustomTextField(
                        isPassword: isPasswordVisible,
                        icon: Icon(MdiIcons.lockOutline),
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        validator: (value) =>
                            FormValidation.simpleValidator(value),
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
                        placeholder: "Password",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          child: Text(
                            'Forgot your password?',
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () => log('password Forgot'),
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
                          SizedBox(width: 10),
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
      ),
    );
  }
}
