import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/customButton.dart';
import 'dart:developer';

import 'package:Homey/design/widgets/textfield.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Homey/helpers/forms_helpers/form_validations.dart';
import 'package:Homey/helpers/forms_helpers/forms_helpers.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordVerificationController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
  }

  TextEditingController passwordController = new TextEditingController(),
      emailController = new TextEditingController(),
      firstNameController = new TextEditingController(),
      lastNameController = new TextEditingController(),
      passwordVerificationController = new TextEditingController();
  final FocusNode emailFocusNode = new FocusNode(),
      passwordFocusNode = new FocusNode(),
      passwordVerificationFocusNode = new FocusNode(),
      firstNameFocusNode = new FocusNode(),
      lastNameFocusNode = new FocusNode();
  bool isPasswordVisible = true;
  bool isPasswordVerificationVisible = true;
  bool termsAndConditions = false;
  bool formAutoValidate = false;
  bool emailExist = true;
  String emailExistMessage;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData;

  void onError(e) {
    log('Error: ', error: e);
    Dialogs.showSimpleDialog("Error", e.toString(), context);
  }

  void register(BuildContext context) async {
    _formData = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
      'password': passwordController.text
    };
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      if (!termsAndConditions) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('You must agree the terms and coditions'),
          action: SnackBarAction(
            label: 'Accept',
            onPressed: () {
              setState(() {
                termsAndConditions = true;
              });
              register(context);
            },
          ),
        ));
      } else {
        _formKey.currentState.save();
        var progressBar = Dialogs.showProgressDialog('Please wait...', context);
        await progressBar.show();
        WebRequestsHelpers.post(route: '/api/register', body: _formData).then(
            (response) {
          progressBar.dismiss();
          if (response.json()['success'] != null) {
            Navigator.pop(context);
          } else {
            Dialogs.showSimpleDialog(
                "Error", response.json()['error'], context);
          }
        }, onError: onError);
      }
    } else {
      setState(() {
        formAutoValidate = true;
      });
    }
  }

  void cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsTheme.background,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Register",
          style: TextStyle(color: Colors.white, fontFamily: 'Sriracha'),
        ),
        backgroundColor: ColorsTheme.background,
      ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: CustomTextField(
                              icon: Icon(MdiIcons.account),
                              controller: firstNameController,
                              placeholder: "First Name",
                              validator: (value) =>
                                  FormValidation.simpleValidator(value),
                              focusNode: firstNameFocusNode,
                              onSubmitted: () => FormHelpers.fieldFocusChange(
                                  context,
                                  firstNameFocusNode,
                                  lastNameFocusNode),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              icon: Icon(MdiIcons.account),
                              controller: lastNameController,
                              placeholder: "Last Name",
                              validator: (value) =>
                                  FormValidation.simpleValidator(value),
                              focusNode: lastNameFocusNode,
                              onSubmitted: () => FormHelpers.fieldFocusChange(
                                  context, lastNameFocusNode, emailFocusNode),
                            ),
                          ),
                        ],
                      ),
                      CustomTextField(
                        inputType: TextInputType.emailAddress,
                        icon: Icon(MdiIcons.email),
                        controller: emailController,
                        placeholder: "Email",
                        validator: (value) =>
                            FormValidation.emailValidator(value),
                        focusNode: emailFocusNode,
                        onSubmitted: () => FormHelpers.fieldFocusChange(
                            context, emailFocusNode, passwordFocusNode),
                      ),
                      CustomTextField(
                        isPassword: isPasswordVisible,
                        icon: Icon(MdiIcons.lockOutline),
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        validator: (value) =>
                            FormValidation.passwordValidator(value),
                        onSubmitted: () => FormHelpers.fieldFocusChange(context,
                            passwordFocusNode, passwordVerificationFocusNode),
                        suffix: IconButton(
                          onPressed: () => setState(
                              () => isPasswordVisible = !isPasswordVisible),
                          icon: Icon(isPasswordVisible
                              ? MdiIcons.eyeOffOutline
                              : MdiIcons.eyeOutline),
                        ),
                        placeholder: "Password",
                      ),
                      CustomTextField(
                        isPassword: isPasswordVerificationVisible,
                        icon: Icon(MdiIcons.lockOutline),
                        controller: passwordVerificationController,
                        focusNode: passwordVerificationFocusNode,
                        validator: (value) {
                          var res = FormValidation.passwordValidator(value);
                          if (res == null) {
                            if (value != passwordController.text)
                              return 'Password doesn\'t match';
                          } else {
                            return res;
                          }
                          return null;
                        },
                        onSubmitted: () {
                          register(context);
                        },
                        suffix: IconButton(
                          onPressed: () => setState(() =>
                              isPasswordVerificationVisible =
                                  !isPasswordVerificationVisible),
                          icon: Icon(isPasswordVerificationVisible
                              ? MdiIcons.eyeOffOutline
                              : MdiIcons.eyeOutline),
                        ),
                        placeholder: "Retype password",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Checkbox(
                            value: termsAndConditions,
                            onChanged: (value) =>
                                setState(() => termsAndConditions = value),
                            activeColor: ColorsTheme.primary,
                            checkColor: ColorsTheme.background,
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text("I accept the Terms and Conditions"),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: CustomButton(
                              text: 'Cancel',
                              isSecondary: true,
                              onPressed: cancel,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: CustomButton(
                              text: 'Register',
                              onPressed: () => register(context),
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
