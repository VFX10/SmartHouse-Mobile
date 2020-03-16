import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DataTypes {
  const DataTypes();

  static Map<int, Map<String, dynamic>> sensorsType =
      <int, Map<String, dynamic>>{
    0: <String, dynamic>{
      'text': 'Undefined device',
      'title' : 'Undefined devices',
    },
    1: <String, dynamic>{
      'text': 'UV Sensor',
      'title' : 'UV Sensors',

    },
    2: <String, dynamic>{
      'text': 'Switch',
      'title' : 'Switches',
      'icon': MdiIcons.powerSocketEu,
    },
    3: <String, dynamic>{
      'text': 'Temperature and Humidity Sensor',
      'title' : 'Temperature and humidity Sensors',
      'icon': MdiIcons.thermometer,
    },
    4: <String, dynamic>{
      'text': 'Light Sensor',
      'title' : 'Light Sensors',
      'icon': MdiIcons.themeLightDark,
    },
    5: <String, dynamic>{
      'text': 'Gas and Smoke Detector',
      'title' : 'Gas and Smoke Detectors',
      'icon': MdiIcons.smokeDetector,
    },
    6: <String, dynamic>{
      'text': 'Contact Sensor',
      'title' : 'Contact Sensors',

      'icon': MdiIcons.doorOpen,
    }
  };
}
