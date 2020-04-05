
import 'package:Homey/app_data_manager.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/room_list_item.dart';
import 'package:Homey/states/devices_states/add_device_state.dart';
import 'package:Homey/states/menu_state.dart';
import 'package:Homey/states/on_result_callback.dart';
import 'package:flutter/material.dart';
import 'package:Homey/main.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class RoomSelectorPage extends StatelessWidget {
  RoomSelectorPage({this.state, this.event}) : super();
  final Function event;
  final MenuState _menuState = getIt.get<MenuState>();
  final AddDeviceState state;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  void onResult(dynamic data, ResultState resultState) {
    switch (resultState) {
      case ResultState.error:
        if (Navigator.canPop(_keyLoader.currentContext)) {
          Navigator.pop(_keyLoader.currentContext);
        }
        Dialogs.showSimpleDialog('Error', data, _keyLoader.currentContext);
        break;
      case ResultState.successful:
        _menuState.selectedHome = AppDataManager().defaultHome;
        if (Navigator.canPop(_keyLoader.currentContext)) {
          Navigator.pop(_keyLoader.currentContext);
          if (Navigator.canPop(_keyLoader.currentContext)) {
            Navigator.pop(_keyLoader.currentContext);
          }
        }
        break;
      case ResultState.loading:
        Dialogs.showProgressDialog(data, _keyLoader.currentContext);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyLoader,
      floatingActionButton: FloatingActionButton.extended(onPressed: () => state.addSensor(onResult: onResult), label: const Text('Skip'), icon: Icon(MdiIcons.arrowRight),),
      body: SafeArea(
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: _menuState.selectedHome.rooms.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 700),
                delay: const Duration(milliseconds: 100),
                child: FadeInAnimation(
                  child: RoomListItem(
                    _menuState.selectedHome.rooms[index],
                    selectionOnly: true,
                    onPressed: () => state.addSensor(
                        room: _menuState.selectedHome.rooms[index], onResult: onResult),
                  ),
                ),
              );
            },
            padding:
                const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 80),
          ),
        ),
      ),
    );
  }
}
