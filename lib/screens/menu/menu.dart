import 'package:Homey/app_data_manager.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/design/widgets/empty_list_card.dart';
import 'package:Homey/design/widgets/room_list_item.dart';
import 'package:Homey/helpers/mqtt.dart';
import 'package:Homey/helpers/sql_helper/data_models/home_model.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:Homey/helpers/states_manager.dart';
import 'package:Homey/screens/add_device/add_device_page.dart';
import 'package:Homey/screens/add_house/add_house.dart';
import 'package:Homey/screens/add_room/room_name/room_name_page.dart';
import 'package:Homey/screens/menu/devices_categories_horizontal_scroll/devices_categories_horizontal_scroll.dart';
import 'package:Homey/screens/menu/menu_drawer/menu_drawer.dart';
import 'package:Homey/screens/room/room.dart';
import 'package:Homey/states/menu_state.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Menu extends StatelessWidget {
  final MenuState state = getIt.get<MenuState>();

  @override
  Widget build(BuildContext context) {
    state.selectedHome = AppDataManager().defaultHome;

    if (state.selectedHome == null) {
      return AddHouse();
    }
    getIt.get<MqttHelper>().connect();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: StreamBuilder<HomeModel>(
          stream: state.selectedHomeStream$,
          builder: (BuildContext context, AsyncSnapshot<HomeModel> snapshot) {
            return Text(state.selectedHome == null
                ? 'Add a house'
                : state.selectedHome.name);
          },
        ),
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
      drawer: MenuDrawer(state),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: Utils.getPercentValueFromScreenHeight(20, context),
              child: DevicesHorizontalScroll(),
            ),
            Expanded(
              flex: 8,
              child: StreamBuilder<HomeModel>(
                stream: state.selectedHomeStream$,
                builder:
                    (BuildContext context, AsyncSnapshot<HomeModel> snapshot) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (state.selectedHome.rooms.isEmpty) {
                        return EmptyListItem(
                          title: 'You don\'t have any room.\nAdd one now',
                          onPressed: () => Navigator.push<RoomName>(
                            context,
                            MaterialPageRoute<RoomName>(
                              builder: (_) => RoomName(),
                            ),
                          ),
                          icon: MdiIcons.help,
                        );
                      } else {
                        return RoomListItem(
                          state.selectedHome.rooms[index],
                          onPressed: () {
                            Navigator.push<Room>(
                              context,
                              MaterialPageRoute<Room>(
                                builder: (_) => Room(
                                  state.selectedHome.rooms[index],
                                ),
                              ),
                            );
                          },
                        );
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 700),
                          delay: const Duration(milliseconds: 100),
                          child: FadeInAnimation(
                            child: RoomListItem(
                              state.selectedHome.rooms[index],
                              onPressed: () {
                                Navigator.push<Room>(
                                  context,
                                  MaterialPageRoute<Room>(
                                    builder: (_) => Room(
                                      state.selectedHome.rooms[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                    itemCount: state.selectedHome.rooms.isEmpty
                        ? 1
                        : state.selectedHome.rooms.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _settingModalBottomSheet(BuildContext context) {
    showModalBottomSheet<dynamic>(
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
                  onTap: () => Navigator.pushReplacement<AddHouse, dynamic>(bc,
                      MaterialPageRoute<AddHouse>(builder: (_) => AddHouse())),
                ),
                ListTile(
                  leading: const Icon(MdiIcons.floorPlan),
                  title: const Text('Add room'),
                  onTap: () => Navigator.pushReplacement<RoomName, dynamic>(bc,
                      MaterialPageRoute<RoomName>(builder: (_) => RoomName())),
                ),
                ListTile(
                  leading: const Icon(MdiIcons.developerBoard),
                  title: const Text('Add device'),
                  onTap: () => Navigator.pushReplacement<AddDevice, dynamic>(
                      bc,
                      MaterialPageRoute<AddDevice>(
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
      },
    );
  }
}
