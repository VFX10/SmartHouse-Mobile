import 'dart:developer';

import 'package:Homey/design/colors.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/buttons/roundButton.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SwitchDevicePage extends StatefulWidget {
  const SwitchDevicePage({@required this.sensor}) : super();

  final SensorModel sensor;

  @override
  _SwitchDevicePageState createState() => _SwitchDevicePageState();
}

class _SwitchDevicePageState extends State<SwitchDevicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sensor.name),
      ),
      body: Container(
        child: Center(
          child: RoundButton(
            backgroundColor: ColorsTheme.backgroundCard,
            widthFactor: 70,
            heightFactor: 50,
            icon: Icon(
              MdiIcons.power,
              size: 80,
            ),
            onPressed: () {
              log('sensor', error: widget.sensor.macAddress);
              changeStateOn();
            },
          ),
        ),
      ),
    );
  }

  void changeStateOn() {
    final Map<String, String> body = <String, String>{
      'macAddress': widget.sensor.macAddress,
      'event': 'on'
    };
    WebRequestsHelpers.post(
      route: '/api/sendEventToSensor',
      body: body,
    ).then((dynamic response) async {
      final dynamic data = response.json();
      log('response', error: data);
      if (data['success'] != null) {
      } else {
        Dialogs.showSimpleDialog('Error', response.json()['error'], context);
      }
    }, onError: onError);
  }

  void onError(dynamic e) {
    log('Error: ', error: e);
    Dialogs.showSimpleDialog('Error', e.toString(), context);
  }
}
