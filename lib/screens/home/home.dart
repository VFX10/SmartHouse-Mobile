import 'dart:convert';
import 'dart:developer';

import 'package:Homey/AppDataManager.dart';
import 'package:Homey/config.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/design/widgets/device_card.dart';
import 'package:Homey/design/widgets/dropdownbutton.dart';
import 'package:Homey/design/widgets/roomListItem.dart';
import 'package:Homey/design/widgets/roundButton.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:Homey/screens/addHouse/add_house.dart';
import 'package:Homey/screens/addRoom/addRoom.dart';
import 'package:Homey/screens/addRoom/firstPage/roomNamePage.dart';
import 'package:Homey/screens/devices/devices.dart';
import 'package:Homey/screens/home/homePageState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Homey/screens/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

//class Home extends StatefulWidget {
//  @override
//  _HomeState createState() => _HomeState();
//}

class Home extends StatelessWidget {
  void logout(BuildContext context) async {
    final HomePageState state =
        Provider.of<HomePageState>(context, listen: false);
//    state.selectedRooms = [];
//    state.selectedHome = null;
    state.setHome(null);

    await AppDataManager().removeData();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
//    appData.data();
    final HomePageState state = Provider.of<HomePageState>(context);
    state.setHome(AppDataManager().defaultHome);
    log('def', error: state.selectedHome);
    log('rooms', error: state.selectedRooms);
    if (state.selectedHome == null) {
      return AddHouse();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(state.selectedHome == null
            ? 'Add a house'
            : state.selectedHome['name']),
        backgroundColor: ColorsTheme.background,
        elevation: 0,
        actions: <Widget>[
          RawMaterialButton(
            shape: new CircleBorder(),
            elevation: 0.0,
            child: Icon(
              MdiIcons.plusCircle,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              _settingModalBottomSheet(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.all(16),
          color: ColorsTheme.background,
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: ShapeDecoration(
                        shape: StadiumBorder(),
                        color: ColorsTheme.primary,
                      ),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration.collapsed(hintText: 'Home'),
                        onChanged: (value) {
                          for (var home in AppDataManager().houses) {
                            if (home['id'] == value) {
                              AppDataManager().changeDefaultHome(home);

                              state.selectedHome = home;
                              state.selectedRooms = home['rooms'];
                            }

                          }
                        },
//                        value: i++,
                        value: state.selectedHome['id'],
                        items: AppDataManager()
                            .houses
                            .map<DropdownMenuItem<int>>((dynamic value) {
                          return DropdownMenuItem<int>(
                            value: value['id'],
                            child: Text(value['name']),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: RawMaterialButton(
                    onPressed: () => logout(context),
                    shape: StadiumBorder(),
                    fillColor: ColorsTheme.primary,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Spacer(
                          flex: 5,
                        ),
                        Icon(MdiIcons.logout),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Logout'),
                        Spacer(
                          flex: 5,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Container(
//        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      DeviceCard(
                          icon: MdiIcons.lightbulb,
                          onPressed: () {},
                          label: 'Lights'),
                      DeviceCard(
                          icon: MdiIcons.lightSwitch,
                          onPressed: () {},
                          label: 'Switches'),
                      DeviceCard(
                          icon: MdiIcons.powerSocketEu,
                          onPressed: () {},
                          label: 'Plugs'),
                      DeviceCard(
                          icon: MdiIcons.playSpeed,
                          onPressed: () {},
                          label: 'Scenes'),
                      DeviceCard(
                          icon: MdiIcons.dotsHorizontal,
                          onPressed: () {},
                          label: 'All devices'),
                    ],
                  )),
            ),
            Expanded(
              flex: 0,
              child: Container(
                child: Text('Rooms'),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            Expanded(
              flex: 8,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                children: <Widget>[
                  if (state.selectedRooms.length > 0)
                    for (var room in state.selectedRooms) RoomListItem(room),
                  if (state.selectedRooms.length == 0)
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RoomName())),
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
                                    child: Text(
                                      'You don\'t have any room.\nAdd one now',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
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

  void _settingModalBottomSheet(context) {
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
                    leading: new Icon(MdiIcons.home),
                    title: new Text('Add house'),
                    onTap: () => Navigator.pushReplacement(bc,
                        MaterialPageRoute(builder: (context) => AddHouse())),
                  ),
                  ListTile(
                    leading: new Icon(MdiIcons.floorPlan),
                    title: new Text('Add room'),
                    onTap: () {
                      Navigator.pushReplacement(bc,
                          MaterialPageRoute(builder: (context) => RoomName()));
                    },
                  ),
                  ListTile(
                      leading: new Icon(MdiIcons.developerBoard),
                      title: new Text('Add device'),
                      onTap: () {
                        Navigator.pushReplacement(bc,
                            MaterialPageRoute(builder: (context) => Config()));
                      }),
                  ListTile(
                    leading: new Icon(MdiIcons.playSpeed),
                    title: new Text('Add Scene'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          );
        });
  }
}
