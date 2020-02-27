import 'dart:developer';

import 'package:Homey/screens/addRoom/firstPage/roomNamePage.dart';
import 'package:Homey/screens/addRoom/roomDataModelManager.dart';
import 'package:Homey/screens/addRoom/selectDevices/selectDevicesPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Homey/design/colors.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:Homey/design/widgets/textfield.dart';
import 'package:Homey/helpers/forms_helpers/form_validations.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Homey/screens/addHouse/dataModelManager.dart';
import 'package:Homey/design/colors.dart';

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
        elevation: 0,
        backgroundColor: ColorsTheme.background,
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

