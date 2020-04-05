import 'package:Homey/app_data_manager.dart';
import 'package:Homey/design/rooms_styles.dart';

import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/helpers/sql_helper/sql_helper.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:Homey/models/room_edit_model.dart';

import 'package:rxdart/rxdart.dart';

import 'on_result_callback.dart';

class RoomEditState {
  final BehaviorSubject<RoomEditModel> _currentRoom =
      BehaviorSubject<RoomEditModel>.seeded(const RoomEditModel());
  final BehaviorSubject<List<SensorModel>> _currentSensors =
      BehaviorSubject<List<SensorModel>>.seeded(<SensorModel>[]);
  final BehaviorSubject<Map<String, dynamic>> _roomStyle =
      BehaviorSubject<Map<String, dynamic>>.seeded(
          RoomsStyles('').getRoomStyle());

  Stream<RoomEditModel> get currentRoomStream$ => _currentRoom.stream;

  Stream<List<SensorModel>> get currentSensorsStream$ => _currentSensors.stream;

  Stream<Map<String, dynamic>> get roomStyleStream$ => _roomStyle.stream;

  RoomEditModel get currentRoom => _currentRoom.value;

  List<SensorModel> get currentSensors => _currentSensors.value;

  Map<String, dynamic> get roomStyle => _roomStyle.value;

  set currentRoom(RoomEditModel model) {
    _currentRoom.value = model;
  }

  void init(RoomModel room) {
    _currentSensors.value = AppDataManager()
        .sensors
        .where((SensorModel device) => device.roomId == room.id)
        .toList();
    _roomStyle.value = RoomsStyles(room.name).getRoomStyle();
    _currentRoom.value = RoomEditModel(
      roomName: room.name,
      room: room,
      roomStyle: RoomsStyles(room.name).getRoomStyle(),
    );
  }

  void getStyleByName(String name) {
    _roomStyle.value = RoomsStyles(name).getRoomStyle();
    _currentRoom.value = RoomEditModel(
      roomName: name,
      room: _currentRoom.value.room,
      roomStyle: RoomsStyles(name).getRoomStyle(),
    );
  }

  Future<void> removeDeviceFromRoom(
      SensorModel device, OnResult onResult) async {
    onResult('Removing...', ResultState.loading);
    await WebRequestsHelpers.post(
            route: '/api/remove/sensorFromRoom',
            body: <String, dynamic>{'macAddress': device.macAddress})
        .then((dynamic response) async {
      final dynamic data = response.json();
      if (data['success'] != null) {
        await SqlHelper().removeDeviceFromRoom(device);
        await AppDataManager().fetchData();
        final List<SensorModel> tempSensors = _currentSensors.value
          ..remove(device);
        _currentSensors.value = tempSensors;
        onResult(data['success'], ResultState.successful);
      } else {
        onResult(data['error'].toString(), ResultState.error);
      }
    }, onError: (Object e) {
      onResult(e.toString(), ResultState.error);
    });
  }

  Future<void> removeRoom(OnResult onResult) async {
    onResult('Removing...', ResultState.loading);
    await WebRequestsHelpers.post(
            route: '/api/remove/room',
            body: <String, dynamic>{'roomId': _currentRoom.value.room.dbId})
        .then((dynamic response) async {
      final dynamic data = response.json();
      if (data['success'] != null) {
        _currentSensors.value = <SensorModel>[];
//        await AppDataManager().fetchData();
//        AppDataManager().defaultHome.rooms.remove(_currentRoom.value.room);
        await SqlHelper().removeRoom(_currentRoom.value.room.id);
        await AppDataManager().fetchData();
        onResult(data['success'], ResultState.successful);
      } else {
        onResult(data['error'].toString(), ResultState.error);
      }
    }, onError: (Object e) {
      onResult(e.toString(), ResultState.error);
    });
  }

  Future<void> updateRoom(OnResult onResult) async {
    if (_currentRoom.value.roomName != _currentRoom.value.room.name &&
        _currentRoom.value.roomName != '') {
      onResult('Updating...', ResultState.loading);
      await WebRequestsHelpers.post(
          route: '/api/update/room',
          body: <String, dynamic>{
            'roomId': _currentRoom.value.room.dbId,
            'roomName': _currentRoom.value.roomName
          }).then((dynamic response) async {
        final dynamic data = response.json();
        if (data['success'] != null) {
          await SqlHelper().updateRoom(
              _currentRoom.value.room.id, _currentRoom.value.roomName);
          await AppDataManager().fetchData();
          onResult(data['success'], ResultState.successful);
        } else {
          onResult(data['error'].toString(), ResultState.error);
        }
      }, onError: (Object e) {
        onResult(e.toString(), ResultState.error);
      });
    }
  }

  void dispose() {
    _currentRoom.close();
    _roomStyle.close();
    _currentSensors.close();
  }
}
