import 'package:Homey/screens/add_room/room_name/room_name_page.dart';
import 'package:Homey/screens/add_room/select_devices/select_devices_page.dart';
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

