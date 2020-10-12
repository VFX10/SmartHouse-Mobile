import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum DevicesType {
  undefined,
  uv,
  switchDevice,
  temperature,
  light,
  gasAndSmoke,
  contact,
  powerConsumption,
}

class DataTypes {
  const DataTypes();

  static const  Map<DevicesType, Map<String, dynamic>> sensorsType =
      <DevicesType, Map<String, dynamic>>{
    DevicesType.undefined: <String, dynamic>{
      'text': 'Undefined device',
      'title': 'Undefined devices',
    },
    DevicesType.uv: <String, dynamic>{
      'text': 'UV Sensor',
      'title': 'UV Sensors',
      'icon': MdiIcons.weatherSunny,
    },
    DevicesType.switchDevice: <String, dynamic>{
      'text': 'Switch',
      'title': 'Switches',
      'icon': MdiIcons.powerSocketEu,
    },
    DevicesType.temperature: <String, dynamic>{
      'text': 'Temperature and Humidity Sensor',
      'title': 'Temperature and humidity Sensors',
      'icon': MdiIcons.thermometer,
    },
    DevicesType.light: <String, dynamic>{
      'text': 'Light Sensor',
      'title': 'Light Sensors',
      'icon': MdiIcons.themeLightDark,
    },
    DevicesType.gasAndSmoke: <String, dynamic>{
      'text': 'Gas and Smoke Detector',
      'title': 'Gas and Smoke Detectors',
      'icon': MdiIcons.smokeDetector,
    },
    DevicesType.contact: <String, dynamic>{
      'text': 'Contact Sensor',
      'title': 'Contact Sensors',
      'icon': MdiIcons.doorOpen,
    },
    DevicesType.powerConsumption: <String, dynamic>{
      'text': 'Power consumption Sensor',
      'title': 'Power consumption Sensors',
      'icon': MdiIcons.counter,
    },
  };
  static final List<Map<String, dynamic>> uvLevelsText = <Map<String, dynamic>>[
    <String, dynamic>{
      'label': '0-2',
      'text': 'low',
      'color': Colors.green.shade900,
      'selectedColor': const Color(0xFF7FDD87),
      'dotColor': const Color(0xFF7FDD87),
      'details': 'Minimal sun protection required, Wear sunglasses if bright',
    },
    <String, dynamic>{
      'label': '3-5',
      'text': 'medium',
      'color': const Color(0xFF93483D),
      'selectedColor': const Color(0xFFEAD485),
      'dotColor': const Color(0xFFEAD485),
      'details':
          'Take precautions - wear sunscreen, sunhat, sunglasses, seek shade during peak hours of 11 am to 4 pm',
    },
    <String, dynamic>{
      'label': '6-7',
      'text': 'high',
      'color': Colors.orange.shade900,
      'selectedColor': const Color(0xFFFBB893),
      'dotColor': const Color(0xFFFBB893),
      'details': 'Wear sun protecting clothing, sunscreen, and seek shade',
    },
    <String, dynamic>{
      'label': '8-10',
      'text': 'very high',
      'color': Colors.deepPurple.shade900,
      'selectedColor': const Color(0xFF6F6DE8),
      'dotColor': const Color(0xFF6F6DE8),
      'details':
          'Seek shade - wear sun protective clothing, sun screen and sunglasses.',
    },
    <String, dynamic>{
      'label': '11+',
      'text': 'extreme',
      'color': Colors.red.shade900,
      'selectedColor': const Color(0xFFF86F7E),
      'dotColor': const Color(0xFFF86F7E),
      'details':
          'Take full precaution. Unprotected skin can burn in minutes. Wear sunscreen and sun protective clothing.',
    },
  ];
}
