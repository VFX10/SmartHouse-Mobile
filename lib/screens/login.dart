import 'dart:developer';

import 'package:Homey/main.dart';
import 'package:Homey/models/login_model.dart';
import 'package:Homey/screens/menu/menu.dart';
import 'package:Homey/states/login_state.dart';
import 'package:Homey/states/on_result_callback.dart';
import 'package:flutter/material.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/buttons/custom_button.dart';

import 'package:Homey/design/widgets/textfield.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Homey/helpers/forms_helpers/form_validations.dart';
import 'package:Homey/helpers/forms_helpers/forms_helpers.dart';
import 'package:Homey/screens/register.dart';


class Login extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  final FocusNode _emailFocusNode = FocusNode(), passwordFocusNode = FocusNode();
  final LoginState _state = getIt.get<LoginState>();

  void login(VoidCallback callback) {
    FocusScope.of(_keyLoader.currentContext).unfocus();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      callback();
    } else {
      _state.autoValidate = true;
    }
  }

  void register() {
    FocusScope.of(_keyLoader.currentContext).unfocus();
    Navigator.push<Register>(_keyLoader.currentContext,
        MaterialPageRoute<Register>(builder: (_) => Register()));
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
        Navigator.pushReplacement<Menu, dynamic>(_keyLoader.currentContext,
            MaterialPageRoute<Menu>(builder: (_) => Menu()));
        break;
      case ResultState.loading:
        Dialogs.showProgressDialog(data, _keyLoader.currentContext);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _state.isPasswordHidden = true;
    // ignore: cascade_invocations
    _state.autoValidate = false;
    return Scaffold(
      key: _keyLoader,
      backgroundColor: ColorsTheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: StreamBuilder<bool>(
              stream: _state.autoValidateStream$,
              builder: (BuildContext context, AsyncSnapshot<bool> snap) {
                return Form(
                  key: _formKey,
                  autovalidate: _state.autoValidate,
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
                        controller: _emailController,
                        validator: FormValidation.emailValidator,
                        placeholder: 'Email',
                        focusNode: _emailFocusNode,
                        onSubmitted: () {
                          FormHelpers.fieldFocusChange(
                              context, _emailFocusNode, passwordFocusNode);
                        },
                      ),
                      StreamBuilder<bool>(
                          stream: _state.passwordToggleStream$,
                          builder:
                              (BuildContext context, AsyncSnapshot<bool> snap) {
                            return CustomTextField(
                              isPassword: _state.isPasswordHidden,
                              icon: const Icon(MdiIcons.lockOutline),
                              controller: _passwordController,
                              focusNode: passwordFocusNode,
                              validator: FormValidation.simpleValidator,
                              onSubmitted: () => login(
                                    () => _state.login(
                                  model: LoginModel(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      onResult: onResult),
                                ),
                              ),
                              suffix: IconButton(
                                onPressed: _state.togglePassword,
                                icon: Icon(
                                  snap.data ?? true
                                      ? MdiIcons.eyeOffOutline
                                      : MdiIcons.eyeOutline,
                                ),
                              ),
                              placeholder: 'Password',
                            );
                          }),
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
                              onPressed: () => login(
                                () => _state.login(
                                  model: LoginModel(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      onResult: onResult),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
