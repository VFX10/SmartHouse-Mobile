import 'dart:developer';

import 'package:Homey/helpers/firebase.dart';
import 'package:Homey/helpers/sql_helper/sql_helper.dart';
import 'package:Homey/helpers/states_manager.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:Homey/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'on_result_callback.dart';


class LoginState {
  final BehaviorSubject<bool> _isPasswordHidden =
  BehaviorSubject<bool>.seeded(true);
  final BehaviorSubject<bool> _autoValidate =
  BehaviorSubject<bool>.seeded(false);

  Stream<bool> get passwordToggleStream$ => _isPasswordHidden.stream;

  Stream<bool> get autoValidateStream$ => _autoValidate.stream;

  bool get isPasswordHidden => _isPasswordHidden.value;

  bool get autoValidate => _autoValidate.value;

  set autoValidate(bool state) {
    _autoValidate.value = state;
  }
  set isPasswordHidden(bool state) {
    _isPasswordHidden.value = state;
  }

  void togglePassword() {
    _isPasswordHidden.value = !_isPasswordHidden.value;
  }

  Future<void> login(
      {@required LoginModel model}) async {
    model.onResult('Loading...', ResultState.loading);
    await WebRequestsHelpers.post(route: '/api/login', body: model.toMap()).then(
            (dynamic response) async {
          final dynamic data = response.json();
          log('login', error: data);
          log('login', error: data['success']);
          if (data['success'] != null) {
            await (await SharedPreferences.getInstance())
                .setString('token', data['token']);
            await SqlHelper().insert(data['data']);
            getIt.get<FirebaseHelper>().initFirebase();

            model.onResult(data, ResultState.successful);
          } else {
            model.onResult(data['error'].toString(), ResultState.error);
          }
        }, onError: (Object e) {
      model.onResult(e.toString(), ResultState.error);
    });
  }

  void dispose() {
    _isPasswordHidden.close();
    _autoValidate.close();
  }
}
