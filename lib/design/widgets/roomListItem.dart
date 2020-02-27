import 'dart:developer';

import 'package:Homey/design/colors.dart';
import 'package:Homey/design/widgets/roundButton.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RoomListItem extends StatelessWidget {
  RoomListItem(this.room);

  final Map<String, dynamic> room;

  @override
  Widget build(BuildContext context) {
    Map colors = {
      'Kitchen': {
        'primary': Color(0xFF7260AC),
        'icon': MdiIcons.fridgeOutline,
        'iconColor': Color(0xFF554881),
        'textColor': Color(0xFFFDF0FF),
      },
      'Living room': {
        'primary': Color(0xFF068F82),
        'icon': MdiIcons.sofa,
        'iconColor': Color(0xFF046B61),
        'textColor': Color(0xFFCCFFFF),
      },
      'Bathroom': {
        'primary': Color(0xFF17A398),
        'icon': MdiIcons.shower,
        'iconColor': Color(0xFF117A72),
        'textColor': Color(0xFFDDFFFF),
      },
      'Hall': {
        'primary': Color(0xFF1F7FA9),
        'icon': MdiIcons.floorLamp,
        'iconColor': Color(0xFF155E7E),
        'textColor': Color(0xFFC5FFFF),
      },
      'Guest room': {
        'primary': Color(0xFF5387BE),
        'icon': MdiIcons.tableChair,
        'iconColor': Color(0xFF29435F),
        'textColor': Color(0xFFFBFFFF),
      },
      'Bedroom': {
        'primary': Color(0xFFEFB342),
        'icon': MdiIcons.bedKingOutline,
        'iconColor': Color(0xFF775921),
        'textColor': Color(0xFFFFFFEA),
      },
      'Office': {
        'primary': Color(0xFF2E7DCC),
        'icon': MdiIcons.deskLamp,
        'iconColor': Color(0xFF173E66),
        'textColor': Color(0xFFD6FFFF),
      },
      'default': {
        'primary': ColorsTheme.backgroundCard,
        'icon': MdiIcons.floorPlan,
        'iconColor': ColorsTheme.background,
        'textColor': Colors.white,
      }
    };
    log(room['name']);
    return GestureDetector(
      onTap: () {
        log(room['id'].toString());
      },

      child: Container(
        child: AspectRatio(
          aspectRatio: 21 / 9,
          child: Card(
            elevation: 10,
            color: colors[room['name']] == null
                ? colors['default']['primary']
                : colors[room['name']]['primary'],
            child: Container(
              padding: const EdgeInsets.only(
                  left: 16, top: 16, right: 16, bottom: 10),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      room['name'],
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors[room['name']] == null
                              ? colors['default']['textColor']
                              : colors[room['name']]['textColor']),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      colors[room['name']] == null
                          ? colors['default']['icon']
                          : colors[room['name']]['icon'],
                      size: 50,
                      color: colors[room['name']] == null
                          ? colors['default']['iconColor']
                          : colors[room['name']]['iconColor'],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RoundButton(
                          onPressed: () {},
                          icon: Icon(
                            MdiIcons.lightbulb,
                            color: colors[room['name']] == null
                                ? colors['default']['primary']
                                : colors[room['name']]['primary'],
                            size: 20.0,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RoundButton(
                          onPressed: () {},
                          icon: Icon(
                            MdiIcons.lightSwitch,
                            color: colors[room['name']] == null
                                ? colors['default']['primary']
                                : colors[room['name']]['primary'],
                            size: 20.0,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RoundButton(
                          onPressed: () {},
                          icon: Icon(
                            MdiIcons.powerSocketEu,
                            color: colors[room['name']] == null
                                ? colors['default']['primary']
                                : colors[room['name']]['primary'],
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
