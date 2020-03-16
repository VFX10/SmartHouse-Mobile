import 'package:Homey/screens/addDevice/pages/espTouchConfigPage.dart';
import 'package:Homey/screens/addDevice/pages/rooms_selector.dart';
import 'package:flutter/material.dart';

import 'pages/deviceConfigPage.dart';

class AddDevice extends StatefulWidget {
  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  PageController controller = PageController();

  void next() {
    controller.nextPage(duration: kTabScrollDuration, curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Device'),
      ),
      body: PageView(
        controller: controller,
//        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          EspTouchConfigPage(event: next),
          DeviceConfig(event: next),
          RoomSelectorPage(),
        ],
      ),
    );
  }
}
