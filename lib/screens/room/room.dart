import 'dart:developer';

import 'package:Homey/design/colors.dart';
import 'package:Homey/design/rooms_styles.dart';
import 'package:Homey/design/widgets/buttons/round_button.dart';
import 'package:Homey/design/widgets/device_card.dart';
import 'package:Homey/helpers/data_types.dart';
import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/screens/devices_pages/devices_types/switch_device_page.dart';
import 'package:Homey/screens/devices_pages/devices_types/temp_device_page.dart';
import 'package:Homey/screens/home/devices_categories_horizontal_scroll/devices_categories_horizontal_scroll.dart';
import 'package:Homey/screens/room/room_edit.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Room extends StatefulWidget {
  const Room(this.room);

  final RoomModel room;

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> style =
        RoomsStyles(widget.room.name).getRoomStyle();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: const Alignment(0, -0.5),
                  end: Alignment.bottomCenter,
                  colors: [ColorsTheme.background, Colors.transparent],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.dstIn,
              child: FractionallySizedBox(
                heightFactor: 0.6,
                widthFactor: 1,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      ColorsTheme.background.withOpacity(0.3),
                      BlendMode.multiply),
                  child: Image.asset(
                    style['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    RoundButton(
                      icon: Icon(MdiIcons.chevronLeft, color: Colors.black),
                      padding: const EdgeInsets.all(8),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.room.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    RoundButton(
                      icon: Icon(
                        MdiIcons.pencil,
                        color: Colors.black,
                        size: 16,
                      ),
                      padding: const EdgeInsets.all(12),
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<RoomEdit>(
                              builder: (_) => RoomEdit(room: widget.room))),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.8, 0.08),
            child: Text(
              'The door of the ${widget.room.name} is not closed',
              textScaleFactor: 1.2,
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.3),
            child: FractionallySizedBox(
              heightFactor: 0.15,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return DeviceCard(
                      icon: DataTypes.sensorsType[
                          widget.room.sensors[index].sensorType]['icon'],
                      onPressed: () {
                        switch (widget.room.sensors[index].sensorType) {
                          case 0:
                            break;
                          case 1:
                            break;
                          case 2:
                            Navigator.push<SwitchDevicePage>(
                                context,
                                MaterialPageRoute<SwitchDevicePage>(
                                    builder: (_) => SwitchDevicePage(
                                        sensor: widget.room.sensors[index])));
                            break;
                          case 3:
                            Navigator.push<TempDevicePage>(
                                context,
                                MaterialPageRoute<TempDevicePage>(
                                    builder: (_) => TempDevicePage(
                                        sensor: widget.room.sensors[index])));
                            break;
                        }
                      },
                      label: widget.room.sensors[index].name,
                      isOnline: widget.room.sensors[index].networkStatus,
                      isCategory: false);
                },
                itemCount: widget.room.sensors.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
