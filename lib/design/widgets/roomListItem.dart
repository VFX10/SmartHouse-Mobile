import 'dart:developer';

import 'package:Homey/design/roomsStyles.dart';
import 'package:Homey/design/widgets/buttons/roundButton.dart';
import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class RoomListItem extends StatelessWidget {
  RoomListItem(this.room, {this.onPressed});

  final RoomModel room;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    var style = RoomsStyles(room.name).getRoomStyle();
    log(room.sensors.toString());
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        child: Container(
          child: AspectRatio(
            aspectRatio: 21 / 9,
            child: Card(
              elevation: 10,
              color: style['primary'],
              child: Container(
                padding: const EdgeInsets.only(
                    left: 16, top: 16, right: 16, bottom: 10),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        room.name,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: style['textColor']),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        style['icon'],
                        size: 60,
                        color: style['iconColor'],
                      ),
                    ),
                    if (room.sensors != null && room.sensors.length > 0)
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            if(room.sensors.where((sensor) => sensor.sensorType == 3).length > 0)
                            RoundButton(
                              onPressed: () {},
                              icon: Icon(
                                MdiIcons.lightbulb,
                                color: style['primary'],
                                size: 20.0,
                              ),
                            ),
                            if(room.sensors.where((sensor) => sensor.sensorType == 3).length > 0)
                              const SizedBox(
                              width: 10,
                            ),
                            if(room.sensors.where((sensor) => sensor.sensorType == 1).length > 0)
                            RoundButton(
                              onPressed: () {},
                              icon: Icon(
                                MdiIcons.lightSwitch,
                                color: style['primary'],
                                size: 20.0,
                              ),
                            ),
                            if(room.sensors.where((sensor) => sensor.sensorType == 1).length > 0)
                              const SizedBox(
                              width: 10,
                            ),
                            if(room.sensors.where((sensor) => sensor.sensorType == 2).length > 0)
                            RoundButton(
                              onPressed: () {},
                              icon: Icon(
                                MdiIcons.powerSocketEu,
                                color: style['primary'],
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
      ),
    );
  }
}
