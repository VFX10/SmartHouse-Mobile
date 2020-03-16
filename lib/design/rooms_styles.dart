import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'colors.dart';

class RoomsStyles {
  RoomsStyles(this.name);

  @protected
  String name;
  @protected
  final Map<String, Map<String, dynamic>> roomStyle =
      <String, Map<String, dynamic>>{
    'Kitchen': <String, dynamic>{
      'primary': const Color(0xFF7260AC),
      'icon': MdiIcons.fridgeOutline,
      'iconColor': const Color(0xFF554881),
      'textColor': const Color(0xFFFDF0FF),
      'image': 'assets/images/kitchen.jpg'

    },
    'Living room': <String, dynamic>{
      'primary': const Color(0xFF068F82),
      'icon': MdiIcons.sofa,
      'iconColor': const Color(0xFF046B61),
      'textColor': const Color(0xFFCCFFFF),
      'image': 'assets/images/livingroom.jpg'
    },
    'Bathroom': <String, dynamic>{
      'primary': const Color(0xFF17A398),
      'icon': MdiIcons.shower,
      'iconColor': const Color(0xFF117A72),
      'textColor': const Color(0xFFDDFFFF),
      'image': 'assets/images/bathroom.jpg'

    },
    'Hallway': <String, dynamic>{
      'primary': const Color(0xFF1F7FA9),
      'icon': MdiIcons.floorLamp,
      'iconColor': const Color(0xFF155E7E),
      'textColor': const Color(0xFFC5FFFF),
      'image': 'assets/images/hall.jpg'

    },
    'Guest room': <String, dynamic>{
      'primary': const Color(0xFF5387BE),
      'icon': MdiIcons.tableChair,
      'iconColor': const Color(0xFF29435F),
      'textColor': const Color(0xFFFBFFFF),
      'image': 'assets/images/guestsroom.jpg'

    },
    'Bedroom': <String, dynamic>{
      'primary': const Color(0xFFEFB342),
      'icon': MdiIcons.bedKingOutline,
      'iconColor': const Color(0xFF775921),
      'textColor': const Color(0xFFFFFFEA),
      'image': 'assets/images/bedroom.jpg'

    },
    'Office': <String, dynamic>{
      'primary': const Color(0xFF2E7DCC),
      'icon': MdiIcons.deskLamp,
      'iconColor': const Color(0xFF173E66),
      'textColor': const Color(0xFFD6FFFF),
      'image': 'assets/images/office.jpg'

    },
    'default': <String, dynamic>{
      'primary': ColorsTheme.backgroundCard,
      'icon': MdiIcons.floorPlan,
      'iconColor': ColorsTheme.background,
      'textColor': Colors.white,
      'image': 'assets/images/custom_room.jpg'

    }
  };

  Map<String, dynamic> getRoomStyle() {
    for (final String key in roomStyle.keys.toList()) {
      if (name.toLowerCase().contains(key.toLowerCase())) {
        return roomStyle[key];
      }
    }
    return roomStyle['default'];
  }
}
