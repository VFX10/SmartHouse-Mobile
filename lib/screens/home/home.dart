import 'dart:developer';

import 'package:Homey/design/colors.dart';
import 'package:Homey/design/widgets/roomListItem.dart';
import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';
import 'package:Homey/helpers/sql_helper/sql_helper.dart';
import 'package:Homey/screens/addDevice/addDevicePage.dart';
import 'package:Homey/screens/addHouse/add_house.dart';
import 'package:Homey/screens/addRoom/firstPage/roomNamePage.dart';
import 'package:Homey/screens/home/home_drawer/home_drawer.dart';
import 'package:Homey/screens/home/devices_categories_horizontal_scroll/devices_categories_horizontal_scroll.dart';
import 'package:Homey/screens/home/home_page_state.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../app_data_manager.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomePageState state = Provider.of<HomePageState>(context)
    ..setHome(AppDataManager().defaultHome);
    SqlHelper().selectAll();
    log('selectedHome', error: state.selectedHome);
    if (state.selectedHome == null) {
      return AddHouse();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(state.selectedHome == null
            ? 'Add a house'
            : state.selectedHome.name),
        actions: <Widget>[
          RawMaterialButton(
            shape: const CircleBorder(),
            elevation: 0.0,
            onPressed: () {
              _settingModalBottomSheet(context);
            },
            child: const Icon(
              MdiIcons.plusCircle,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
      ),
      drawer: HomeDrawer(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: DevicesHorizontalScroll(),
            ),
            Expanded(
              flex: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text('Rooms'),
              ),
            ),
            Expanded(
              flex: 8,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                children: <Widget>[
                  if (state.selectedRooms.isNotEmpty)
                    for (final RoomModel room in state.selectedRooms)
                      RoomListItem(
                        room,
                        onPressed: () {
                          log('hId: ${room.houseId} id: ${room.dbId}, name: ${room.name}, id: ${room.dbId}');
                        },
                      ),
                  if (state.selectedRooms.isEmpty)
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                              builder: (_) => RoomName())),
                      child: Container(
                        child: AspectRatio(
                          aspectRatio: 21 / 9,
                          child: Card(
                            elevation: 10,
                            color: ColorsTheme.backgroundCard,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 16, right: 16, bottom: 10),
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'You don\'t have any room.\nAdd one now',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: const Icon(
                                      MdiIcons.help,
                                      size: 50,
                                      color: ColorsTheme.background,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _settingModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Card(
            margin: const EdgeInsets.all(16),
            color: ColorsTheme.background,
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(MdiIcons.home),
                    title: const Text('Add house'),
                    onTap: () => Navigator.pushReplacement(
                        bc,
                        MaterialPageRoute<dynamic>(
                            builder: (_) => AddHouse())),
                  ),
                  ListTile(
                    leading: const Icon(MdiIcons.floorPlan),
                    title: const Text('Add room'),
                    onTap: () => Navigator.pushReplacement(
                        bc,
                        MaterialPageRoute<dynamic>(
                            builder: (_) => RoomName())),
                  ),
                  ListTile(
                    leading: const Icon(MdiIcons.developerBoard),
                    title: const Text('Add device'),
                    onTap: () => Navigator.pushReplacement(
                        bc,
                        MaterialPageRoute<dynamic>(
                            builder: (_) => AddDevice())),
                  ),
                  ListTile(
                    leading: const Icon(MdiIcons.playSpeed),
                    title: const Text('Add Scene'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          );
        });
  }
}
