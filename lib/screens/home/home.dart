import 'dart:developer';

import 'package:smart_home_mobile/config.dart';
import 'package:smart_home_mobile/design/colors.dart';
import 'package:smart_home_mobile/design/widgets/device_card.dart';
import 'package:smart_home_mobile/design/widgets/dropdownbutton.dart';
import 'package:smart_home_mobile/helpers/utils.dart';
import 'package:smart_home_mobile/screens/addHouse/add_house.dart';
import 'package:smart_home_mobile/screens/devices/devices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

List _cities = ["Cluj-Napoca"];

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsTheme.background,
        appBar: AppBar(
          title: Text('Your home'),
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
        drawer: Container(
          color: Colors.red,
        ),
        body: Container(
          child: ListView(
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.center,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                height: Utils.getPercentValueFromScreenHeight(18, context),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
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
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 21, vertical: 5),
                child: Text('Rooms'),
              ),
              Container(
                height: Utils.getPercentValueFromScreenHeight(60, context),
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  itemBuilder: _buildItem,
                  itemCount: 3,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(iconData: Icons.home, title: "Home"),
            TabData(iconData: Icons.search, title: "Search"),
            TabData(iconData: Icons.shopping_cart, title: "Basket")
          ],
          onTabChangedListener: (position) {
//            setState(() {
//              currentPage = position;
//            });
          },
        ));
  }

  int k = 0;

  Widget _buildItem(BuildContext context, int index) {
    if (index == 1) {
      return Container(
        child: AspectRatio(
          aspectRatio: 21 / 9,
          child: Card(
            elevation: 10,
            color: Color(0xFF7260AC),
            child: Container(
              padding: const EdgeInsets.only(
                  left: 16, top: 16, right: 16, bottom: 5),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Bathroom',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFDF0FF)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      MdiIcons.shower,
                      size: 50,
                      color: Color(0xFF554881),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Transform.scale(
                          scale: 0.8,
                          child: FloatingActionButton(
                            heroTag: k++,
                            elevation: 4,
                            backgroundColor: Colors.white,
                            onPressed: () {},
                            child: new Icon(
                              MdiIcons.lightbulb,
                              color: Color(0xFF7260AC),
                              size: 20.0,
                            ),
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: FloatingActionButton(
                            heroTag: k++,
                            elevation: 4,
                            backgroundColor: Colors.white,
                            onPressed: () {},
                            child: new Icon(
                              MdiIcons.lightSwitch,
                              color: Color(0xFF7260AC),
                              size: 20.0,
                            ),
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: FloatingActionButton(
                            heroTag: k++,
                            elevation: 4,
                            backgroundColor: Colors.white,
                            onPressed: () {},
                            child: new Icon(
                              MdiIcons.powerSocketEu,
                              color: Color(0xFF7260AC),
                              size: 20.0,
                            ),
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
      );
    } else if (index == 2) {
      //1D7EA8
      return Container(
        child: AspectRatio(
          aspectRatio: 21 / 9,
          child: Card(
            elevation: 10,
            color: Color(0xFF1D7EA8),
            child: Container(
              padding: const EdgeInsets.only(
                  left: 16, top: 16, right: 16, bottom: 5),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Office',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC5FFFF)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      MdiIcons.deskLamp,
                      size: 50,
                      color: Color(0xFF155E7E),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Transform.scale(
                          scale: 0.8,
                          child: FloatingActionButton(
                            heroTag: k++,
                            elevation: 4,
                            backgroundColor: Colors.white,
                            onPressed: () {},
                            child: new Icon(
                              MdiIcons.lightbulb,
                              color: Color(0xFF1D7EA8),
                              size: 20.0,
                            ),
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: FloatingActionButton(
                            heroTag: k++,
                            elevation: 4,
                            backgroundColor: Colors.white,
                            onPressed: () {},
                            child: new Icon(
                              MdiIcons.lightSwitch,
                              color: Color(0xFF1D7EA8),
                              size: 20.0,
                            ),
                          ),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: FloatingActionButton(
                            heroTag: k++,
                            elevation: 4,
                            backgroundColor: Colors.white,
                            onPressed: () {},
                            child: new Icon(
                              MdiIcons.powerSocketEu,
                              color: Color(0xFF1D7EA8),
                              size: 20.0,
                            ),
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
      );
    }
    return Container(
      child: AspectRatio(
        aspectRatio: 21 / 9,
        child: Card(
          elevation: 10,
          color: Color(0xFF068F82),
          child: Container(
            padding:
                const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 5),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Livingroom',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFCCFFFF)),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    MdiIcons.sofa,
                    size: 50,
                    color: Color(0xFF046B61),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Transform.scale(
                        scale: 0.8,
                        child: FloatingActionButton(
                          heroTag: k++,
                          elevation: 4,
                          backgroundColor: Colors.white,
                          onPressed: () {},
                          child: new Icon(
                            MdiIcons.lightbulb,
                            color: Color(0xFF068F82),
                            size: 20.0,
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: FloatingActionButton(
                          heroTag: k++,
                          elevation: 4,
                          backgroundColor: Colors.white,
                          onPressed: () {},
                          child: new Icon(
                            MdiIcons.lightSwitch,
                            color: Color(0xFF068F82),
                            size: 20.0,
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: FloatingActionButton(
                          heroTag: k++,
                          elevation: 4,
                          backgroundColor: Colors.white,
                          onPressed: () {},
                          child: new Icon(
                            MdiIcons.powerSocketEu,
                            color: Color(0xFF068F82),
                            size: 20.0,
                          ),
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
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: ColorsTheme.background,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: new Icon(MdiIcons.floorPlan),
                  title: new Text('Add house'),
                  onTap: () {
                    Navigator.pushReplacement(
                        bc, MaterialPageRoute(builder: (context) => AddHouse()));
                  },
                ),
                ListTile(
                    leading: new Icon(MdiIcons.floorPlan),
                    title: new Text('Add room'),
                    onTap: () {}),
                ListTile(
                  leading: new Icon(MdiIcons.developerBoard),
                  title: new Text('Add device'),
                  onTap: () {},
                ),
                ListTile(
                  leading: new Icon(MdiIcons.playSpeed),
                  title: new Text('Add Scene'),
                  onTap: () {},
                ),
              ],
            ),
          );
        });
  }
}
