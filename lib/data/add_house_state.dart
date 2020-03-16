import 'dart:developer';

import 'package:Homey/app_data_manager.dart';
import 'package:Homey/data/menu_state.dart';
import 'package:Homey/data/models/add_house_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/home_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:Homey/data/on_result_callback.dart';
import 'package:Homey/main.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AddHouseState {
  final BehaviorSubject<String> _houseName = BehaviorSubject<String>.seeded('');
  final BehaviorSubject<bool> _autoValidate =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _locationFormAutoValidate =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _isLocationAutoDetectionEnabled =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<Map<String, dynamic>> _geolocation =
      BehaviorSubject<Map<String, dynamic>>.seeded(<String, dynamic>{});

  Stream<String> get houseNameStream$ => _houseName.stream;

  Stream<bool> get isLocationAutoDetectionEnabledStream$ =>
      _isLocationAutoDetectionEnabled.stream;

  Stream<Map<String, dynamic>> get geolocationStream$ => _geolocation.stream;

  Stream<bool> get autoValidateStream$ => _autoValidate.stream;
  Stream<bool> get locationFormAutoValidateStream$ => _locationFormAutoValidate.stream;

  String get houseName => _houseName.value;

  bool get autoValidate => _autoValidate.value;

  set autoValidate(bool state) {
    _autoValidate.value = state;
  }
  bool get locationFormAutoValidate => _locationFormAutoValidate.value;

  set locationFormAutoValidate(bool state) {
    _locationFormAutoValidate.value = state;
  }

  Map<String, dynamic> get geolocation => _geolocation.value;

  set geolocation(Map<String, dynamic> value) {
    _geolocation.value = value;
  }

  bool get isLocationAutoDetectionEnabled =>
      _isLocationAutoDetectionEnabled.value;

  set isLocationAutoDetectionEnabled(bool state) {
    _isLocationAutoDetectionEnabled.value = state;
  }

  set houseName(String state) {
    _houseName.value = state;
  }

  Future<void> addHouse({@required AddHouseModel model}) async {
     model.onResult('Loading...', ResultState.loading);
    log('data', error: model.toMap());
    await WebRequestsHelpers.post(route: '/api/add/house', body: model.toMap())
        .then((dynamic response) async {
      final dynamic data = response.json();
      if (data['success'] != null) {
        await AppDataManager().addHouse(HomeModel(
          dbId: data['house']['id'],
          userId: AppDataManager().userData.id,
          name: data['house']['name'],
          address: data['house']['address'],
          rooms: <RoomModel>[]
        ));

        getIt.get<MenuState>().selectedHome = AppDataManager().defaultHome;
        model.onResult(data, ResultState.successful);
      } else {
        model.onResult(data['error'].toString(), ResultState.error);
      }
    }, onError: (Object e) {
      model.onResult(e.toString(), ResultState.error);
    });
  }

  void dispose() {
    _houseName.close();
    _isLocationAutoDetectionEnabled.close();
    _locationFormAutoValidate.close();
    _geolocation.close();
    _autoValidate.close();
  }
}
