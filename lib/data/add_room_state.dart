import 'dart:developer';

import 'package:Homey/data/models/add_room_model.dart';
import 'package:Homey/data/models/register_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:Homey/data/on_result_callback.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../app_data_manager.dart';

class AddRoomState {
  // streams
  final BehaviorSubject<String> _roomName =
  BehaviorSubject<String>.seeded('');
  final BehaviorSubject<List<SensorModel>> _selectedDevices =
  BehaviorSubject<List<SensorModel>>.seeded(<SensorModel>[]);
  final BehaviorSubject<bool> _autoValidate =
  BehaviorSubject<bool>.seeded(false);

  // streams getters
  Stream<String> get roomNameStream$ => _roomName.stream;

  Stream<List<SensorModel>> get passwordVerificationToggleStream$ =>
      _selectedDevices.stream;

  Stream<bool> get autoValidateStream$ => _autoValidate.stream;
  

  // streams value getters
  String get roomName => _roomName.value;

  List<SensorModel> get selectedDevices => _selectedDevices.value;

  bool get autoValidate => _autoValidate.value;


  // setters
  set autoValidate(bool state) {
    _autoValidate.value = state;
  }
  set roomName(String state) {
    _roomName.value = state;
  }


  // methods
  Future<void> addRoom({@required AddRoomModel model}) async {
    log('data', error: model.toMap());
    model.onResult('Loading...', ResultState.loading);
    await WebRequestsHelpers.post(route: '/api/add/room', body: model.toMap())
        .then((dynamic response) async {
      final dynamic data = response.json();

      if (data['success'] != null) {
        final RoomModel room = RoomModel(
          dbId: data['data']['id'],
          houseId: AppDataManager().defaultHome.id,
          name: data['data']['name'],
          sensors: <SensorModel>[]
        );
        await AppDataManager().addRoom(room);
//        state.selectedRooms.add(room);
        model.onResult(data, ResultState.successful);

      } else {
        model.onResult(data['error'].toString(), ResultState.error);

      }
    }, onError: (Object e) {
      model.onResult(e.toString(), ResultState.error);
    });
  }

  void dispose() {
    _roomName.close();
    _selectedDevices.close();
    _autoValidate.close();
  }
}
