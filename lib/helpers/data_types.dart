import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DataTypes{

  static var sensorsType = {
    0: {
      'text': 'Undefined device',
    },
    1: {
      'text': 'UV Sensor',
    },
    2: {
      'text': 'Switch',
      'icon': MdiIcons.powerSocketEu,
    },
    3: {
      'text': 'Temperature and Humidity Sensor',
      'icon': MdiIcons.thermometer,
    },
    4: {
      'text': 'Light Sensor',
      'icon': MdiIcons.themeLightDark,
    },
    5: {
      'text': 'Gas and Smoke Sensor',
      'icon': MdiIcons.smokeDetector,
    },
    6: {
      'text': 'Door Sensor',
      'icon': MdiIcons.doorOpen,
    }
  };
}