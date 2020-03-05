import 'dart:developer';

import 'package:Homey/app_data_manager.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/roomListItem.dart';
import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';

import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:Homey/screens/addDevice/AddDeviceDataManager.dart';
import 'package:Homey/screens/home/home_page_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RoomSelectorPage extends StatefulWidget {
  RoomSelectorPage({this.event}):super();
  final Function event;
  @override
  _RoomSelectorPageState createState() => _RoomSelectorPageState();
}

class _RoomSelectorPageState extends State<RoomSelectorPage> {
  var progressBar;
  @override
  Widget build(BuildContext context) {
    final HomePageState state =
        Provider.of<HomePageState>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 80),
          children: <Widget>[
            for (var room in state.selectedRooms)
              RoomListItem(room, onPressed: () async {
                log('hId: ${room.houseId} id: ${room.dbId}, name: ${room.name}, id: ${room.id}');
                await addSensor(room);
//                widget.event();
              }),
          ],
        ),
      ),
    );
  }
  void onError(e) {
    log('Error: ', error: e);
    progressBar.dismiss();
    Dialogs.showSimpleDialog("Error", e.toString(), context);
  }
  Future addSensor(RoomModel room) async {
    var _formData = {
      'sensorName': AddDeviceDataManager().deviceData['sensorName'],
      'roomId': room.dbId,
      'macAddress': AddDeviceDataManager().deviceData['macAddress'],
      'sensorType': AddDeviceDataManager().deviceData['sensorType'],
      'readingFrequency': AddDeviceDataManager().deviceData['freqMinutes'],
    };
    FocusScope.of(context).unfocus();

    progressBar = Dialogs.showProgressDialog('Please wait...', context);
    await progressBar.show();
    WebRequestsHelpers.post(route: '/api/add/sensor', body: _formData).then(
            (response) async {
          progressBar.dismiss();
          final data = response.json();
          log('response', error:data);
          if (data['success'] != null) {

            await AppDataManager().addSensor(SensorModel(
                name: data['sensor']['name'],
                roomId: room.id,
                dbId: data['sensor']['id'],
                macAddress: data['sensor']['macAddress'],
                sensorType: data['sensor']['sensorType'],
                readingFrequency: data['sensor']['readingFrequency'],
                ipAddress: AddDeviceDataManager().deviceData['ip']
            ));

//            Navigator.pop(context);
          } else {
            Dialogs.showSimpleDialog("Error", response.json()['error'], context);
          }
        }, onError: onError);
  }
}
