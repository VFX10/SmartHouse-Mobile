import 'dart:convert';

import 'package:Homey/data/models/devices_models/device_switch_model.dart';
import 'package:Homey/data/models/devices_models/device_temp_model.dart';
import 'package:Homey/data/models/login_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/helpers/sql_helper/sql_helper.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:Homey/data/on_result_callback.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceTempState {
  final BehaviorSubject<DeviceTempModel> _data =
      BehaviorSubject<DeviceTempModel>.seeded(DeviceTempModel());

  Stream<DeviceTempModel> get dataStream$ => _data.stream;

  DeviceTempModel get device => _data.value;

  set device(DeviceTempModel state) {
    _data.value = state;
  }

  Future<DeviceTempModel> getDeviceState(SensorModel sensor, OnResult onResult) async {
    await WebRequestsHelpers.get(
      route: '/api/getSensorLastStatus?macAddress=${sensor.macAddress}',
    ).then((dynamic response) async {
      final dynamic res = response.json();
      if (res['data'] != null) {
        _data.value = DeviceTempModel(
            data: res['data'],
            name: res['name'],
            networkStatus: res['networkStatus']);
        sensor.networkStatus = res['networkStatus'];
        await SqlHelper().updateSensor(sensor);
        onResult(_data.value, ResultState.successful);
      } else {
        onResult(_data.value, ResultState.error);
      }
    }, onError: (Object e) {
      onResult(_data.value, ResultState.error);
    });
    return _data.value;
  }
  Future<void> rebootDevice(SensorModel sensor, OnResult onResult) async {
    final Map<String, dynamic> body = <String, String>{
      'macAddress': sensor.macAddress,
      'event': 'reboot'
    };
    await WebRequestsHelpers.post(
        route: '/api/sendEventToSensor', body: body, displayResponse: true)
        .then((dynamic response) async {
      final dynamic data = response.json();
      if (data['success'] != null) {
        onResult('Device will reboot now!', ResultState.successful);
      } else {
        onResult('Error sending event to device', ResultState.error);
      }
    }, onError: (Object e) {
      onResult('Error sending event to device', ResultState.error);
    });
  }
  void dispose() {
    _data.close();
  }
}
