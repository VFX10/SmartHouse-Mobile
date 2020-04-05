import 'dart:ui';

import 'package:Homey/models/register_model.dart';
import 'package:Homey/states/on_result_callback.dart';
import 'package:Homey/states/register_state.dart';
import 'package:flutter/material.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/buttons/custom_button.dart';

import 'package:Homey/design/widgets/textfield.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Homey/helpers/forms_helpers/form_validations.dart';
import 'package:Homey/helpers/forms_helpers/forms_helpers.dart';
import 'package:Homey/main.dart';

class Register extends StatelessWidget {
  final RegisterState state = getIt.get<RegisterState>();
  final TextEditingController passwordController = TextEditingController(),
      emailController = TextEditingController(),
      firstNameController = TextEditingController(),
      lastNameController = TextEditingController(),
      passwordVerificationController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode(),
      passwordFocusNode = FocusNode(),
      passwordVerificationFocusNode = FocusNode(),
      firstNameFocusNode = FocusNode(),
      lastNameFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  void register(VoidCallback callback) {
    FocusScope.of(_keyLoader.currentContext).unfocus();
    if (_formKey.currentState.validate()) {
      if (!state.termsAndConditions) {
        Scaffold.of(_keyLoader.currentContext).showSnackBar(SnackBar(
          content: const Text('You must agree the terms and coditions'),
          action: SnackBarAction(
            label: 'Accept',
            onPressed: () {
              state.termsAndConditions = true;
              register(callback);
            },
          ),
        ));
      } else {
        _formKey.currentState.save();
        callback();
      }
    } else {
      state.autoValidate = true;
    }
  }

  void onResult(dynamic data, ResultState state) {
    switch (state) {
      case ResultState.error:
        if (Navigator.canPop(_keyLoader.currentContext)) {
          Navigator.pop(_keyLoader.currentContext);
        }
        Dialogs.showSimpleDialog('Error', data, _keyLoader.currentContext);
        break;
      case ResultState.successful:
        if (Navigator.canPop(_keyLoader.currentContext)) {
          Navigator.pop(_keyLoader.currentContext);
        }
        Navigator.pop(_keyLoader.currentContext);
        break;
      case ResultState.loading:
        Dialogs.showProgressDialog(data, _keyLoader.currentContext);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    state.isPasswordHidden = true;
    // ignore: cascade_invocations
    state.isPasswordVerificationHidden = true;
    // ignore: cascade_invocations
    state.termsAndConditions = false;
    // ignore: cascade_invocations
    state.autoValidate = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.white, fontFamily: 'Sriracha'),
        ),
      ),
      body: Builder(
        builder: (BuildContext context) => Center(
          key: _keyLoader,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: StreamBuilder<bool>(
                  stream: state.autoValidateStream$,
                  builder: (BuildContext context, AsyncSnapshot<bool> snap) {
                    return Form(
                      key: _formKey,
                      autovalidate: state.autoValidate,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: CustomTextField(
                                  icon: const Icon(MdiIcons.account),
                                  controller: firstNameController,
                                  placeholder: 'First Name',
                                  validator: FormValidation.simpleValidator,
                                  focusNode: firstNameFocusNode,
                                  onSubmitted: () =>
                                      FormHelpers.fieldFocusChange(
                                          context,
                                          firstNameFocusNode,
                                          lastNameFocusNode),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  icon: const Icon(MdiIcons.account),
                                  controller: lastNameController,
                                  placeholder: 'Last Name',
                                  validator: FormValidation.simpleValidator,
                                  focusNode: lastNameFocusNode,
                                  onSubmitted: () =>
                                      FormHelpers.fieldFocusChange(context,
                                          lastNameFocusNode, emailFocusNode),
                                ),
                              ),
                            ],
                          ),
                          CustomTextField(
                            inputType: TextInputType.emailAddress,
                            icon: const Icon(MdiIcons.email),
                            controller: emailController,
                            placeholder: 'Email',
                            validator: FormValidation.emailValidator,
                            focusNode: emailFocusNode,
                            onSubmitted: () => FormHelpers.fieldFocusChange(
                                context, emailFocusNode, passwordFocusNode),
                          ),
                          StreamBuilder<bool>(
                              stream: state.passwordToggleStream$,
                              builder: (BuildContext context,
                                  AsyncSnapshot<bool> snapshot) {
                                return CustomTextField(
                                  isPassword: state.isPasswordHidden,
                                  icon: const Icon(MdiIcons.lockOutline),
                                  controller: passwordController,
                                  focusNode: passwordFocusNode,
                                  validator: FormValidation.passwordValidator,
                                  onSubmitted: () =>
                                      FormHelpers.fieldFocusChange(
                                          context,
                                          passwordFocusNode,
                                          passwordVerificationFocusNode),
                                  suffix: IconButton(
                                    onPressed: state.togglePassword,
                                    icon: Icon(state.isPasswordHidden
                                        ? MdiIcons.eyeOffOutline
                                        : MdiIcons.eyeOutline),
                                  ),
                                  placeholder: 'Password',
                                );
                              }),
                          StreamBuilder<bool>(
                              stream: state.passwordVerificationToggleStream$,
                              builder: (BuildContext context,
                                  AsyncSnapshot<bool> snapshot) {
                                return CustomTextField(
                                  isPassword:
                                      state.isPasswordVerificationHidden,
                                  icon: const Icon(MdiIcons.lockOutline),
                                  controller: passwordVerificationController,
                                  focusNode: passwordVerificationFocusNode,
                                  validator: (String value) {
                                    final String res =
                                        FormValidation.passwordValidator(value);
                                    if (res == null) {
                                      if (value != passwordController.text) {
                                        return 'Password doesn\'t match';
                                      }
                                    } else {
                                      return res;
                                    }
                                    return null;
                                  },
                                  onSubmitted: () => register(
                                    () => state.register(
                                      model: RegisterModel(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        onResult: onResult,
                                      ),
                                    ),
                                  ),
                                  suffix: IconButton(
                                    onPressed: state.togglePasswordVerification,
                                    icon: Icon(
                                        state.isPasswordVerificationHidden
                                            ? MdiIcons.eyeOffOutline
                                            : MdiIcons.eyeOutline),
                                  ),
                                  placeholder: 'Retype password',
                                );
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              StreamBuilder<bool>(
                                  stream: state.termsAndConditionsStream$,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snapshot) {
                                    return Checkbox(
                                      value: state.termsAndConditions,
                                      onChanged: (bool value) =>
                                          state.termsAndConditions = value,
                                      activeColor: ColorsTheme.primary,
                                      checkColor: ColorsTheme.background,
                                    );
                                  }),
                              const SizedBox(width: 5),
                              const Expanded(
                                child:
                                    Text('I accept the Terms and Conditions'),
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
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: CustomButton(
                                  text: 'Register',
                                  onPressed: () => register(
                                    () => state.register(
                                      model: RegisterModel(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        onResult: onResult,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
