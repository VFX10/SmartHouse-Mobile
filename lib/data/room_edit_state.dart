import 'dart:developer';

import 'package:Homey/app_data_manager.dart';
import 'package:Homey/data/models/room_edit_model.dart';
import 'package:Homey/design/rooms_styles.dart';

import 'package:Homey/helpers/sql_helper/data_models/home_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


class RoomEditState {
  final BehaviorSubject<RoomEditModel> _currentRoom =
  BehaviorSubject<RoomEditModel>.seeded(const RoomEditModel());

  Stream<RoomEditModel> get currentRoomStream$ => _currentRoom.stream;

  RoomEditModel get currentRoom => _currentRoom.value;
  set currentRoom(RoomEditModel model) {
    _currentRoom.value = model;
  }

  void getStyleByName(String name){
    final Map<String, dynamic> style = RoomsStyles(name).getRoomStyle();
    _currentRoom.value = RoomEditModel(roomName: name, roomStyle: style, didChanged: !_currentRoom.value.didChanged);


  }


  void dispose() {
    _currentRoom.close();
  }
}
