import 'dart:developer';

import 'package:Homey/app_data_manager.dart';
import 'package:Homey/data/devices_states/add_device_state.dart';
import 'package:Homey/data/menu_state.dart';
import 'package:Homey/data/on_result_callback.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/room_list_item.dart';
import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';
import 'package:flutter/material.dart';
import 'package:Homey/main.dart';

class RoomSelectorPage extends StatelessWidget {
  RoomSelectorPage({this.state, this.event}) : super();
  final Function event;
  final MenuState _menuState = getIt.get<MenuState>();
  final AddDeviceState state;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyLoader,
      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 80),
          children: <Widget>[
            for (final RoomModel room in _menuState.selectedHome.rooms)
              RoomListItem(room, 0, onPressed: () async {
                log('hId: ${room.houseId} id: ${room.dbId}, name: ${room.name}, id: ${room.id}');
                addSensor(room);
              }),
          ],
        ),
      ),
    );
  }

  void addSensor(RoomModel room) {
    state.addSensor(room, onResult);
  }

  void onResult(dynamic data, ResultState resultState) {
    switch (resultState) {
      case ResultState.error:
        if (Navigator.canPop(_keyLoader.currentContext)) {
          Navigator.pop(_keyLoader.currentContext);
        }
        Dialogs.showSimpleDialog('Error', data, _keyLoader.currentContext);
        break;
      case ResultState.successful:
        _menuState.selectedHome = AppDataManager().defaultHome;
        if (Navigator.canPop(_keyLoader.currentContext)) {
          Navigator.pop(_keyLoader.currentContext);
          if (Navigator.canPop(_keyLoader.currentContext)) {
            Navigator.pop(_keyLoader.currentContext);
          }
        }
        break;
      case ResultState.loading:
        Dialogs.showProgressDialog(data, _keyLoader.currentContext);
        break;
    }
  }
}
