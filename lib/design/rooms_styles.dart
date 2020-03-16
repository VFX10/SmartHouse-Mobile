import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'colors.dart';

class RoomsStyles {
  RoomsStyles(String name) {
    this.name = name;
  }

  @protected
  String name;
  @protected
  Map roomStyle = {
    'Kitchen': {
      'primary': const Color(0xFF7260AC),
      'icon': MdiIcons.fridgeOutline,
      'iconColor': const Color(0xFF554881),
      'textColor': const Color(0xFFFDF0FF),
    },
    'Living room': {
      'primary': const Color(0xFF068F82),
      'icon': MdiIcons.sofa,
      'iconColor': const Color(0xFF046B61),
      'textColor': const Color(0xFFCCFFFF),
    },
    'Bathroom': {
      'primary': const Color(0xFF17A398),
      'icon': MdiIcons.shower,
      'iconColor': const Color(0xFF117A72),
      'textColor': const Color(0xFFDDFFFF),
    },
    'Hall': {
      'primary': const Color(0xFF1F7FA9),
      'icon': MdiIcons.floorLamp,
      'iconColor': const Color(0xFF155E7E),
      'textColor': const Color(0xFFC5FFFF),
    },
    'Guest room': {
      'primary': const Color(0xFF5387BE),
      'icon': MdiIcons.tableChair,
      'iconColor': const Color(0xFF29435F),
      'textColor': const Color(0xFFFBFFFF),
    },
    'Bedroom': {
      'primary': const Color(0xFFEFB342),
      'icon': MdiIcons.bedKingOutline,
      'iconColor': const Color(0xFF775921),
      'textColor': const Color(0xFFFFFFEA),
    },
    'Office': {
      'primary': const Color(0xFF2E7DCC),
      'icon': MdiIcons.deskLamp,
      'iconColor': const Color(0xFF173E66),
      'textColor': const Color(0xFFD6FFFF),
    },
    'default': {
      'primary': ColorsTheme.backgroundCard,
      'icon': MdiIcons.floorPlan,
      'iconColor': ColorsTheme.background,
      'textColor': Colors.white,
    }
  };

  Map getRoomStyle() {
    for (final key in roomStyle.keys.toList()){
      if(name.toLowerCase().contains(key.toString().toLowerCase())){
        return roomStyle[key];
      }
    }
    return roomStyle['default'];
  }
}
