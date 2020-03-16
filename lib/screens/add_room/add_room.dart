import 'dart:developer';

import 'package:Homey/screens/addRoom/add_room_data_manager.dart';
import 'package:Homey/screens/addRoom/room_name/room_name_page.dart';
import 'package:Homey/screens/addRoom/select_devices/select_devices_page.dart';
import 'package:flutter/material.dart';

class AddRoom extends StatefulWidget {
  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final PageController controller = PageController();

  String title = '';
  void next(){
    setState(() {
      title = 'Select devices';
    });
    controller.nextPage(duration: kTabScrollDuration, curve: Curves.ease);
    log('roomName', error:RoomDataModelManager().roomName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PageView(
        controller: controller,
        children: <Widget>[
          RoomName(),
          SelectDevicesPage()
        ],
      ),
    );
  }
}

