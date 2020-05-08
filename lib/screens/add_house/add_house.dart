import 'dart:developer';

import 'package:Homey/models/add_house_model.dart';
import 'package:Homey/screens/add_house/pages/check_location/check_location.dart';
import 'package:Homey/screens/add_house/pages/first_page/first_page.dart';
import 'package:Homey/screens/menu/menu.dart';
import 'package:Homey/states/add_house_state.dart';
import 'package:Homey/states/on_result_callback.dart';
import 'package:flutter/material.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Homey/helpers/states_manager.dart';


class AddHouse extends StatelessWidget {
  AddHouse({Key key}) : super(key: key);
  final PageController controller = PageController();
  final PermissionHandler _permissionHandler = PermissionHandler();
  final AddHouseState _state = getIt.get<AddHouseState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  Future<void> requestsPermissions() async {
    final Map<PermissionGroup, PermissionStatus> permissionStatus =
        await _permissionHandler.requestPermissions(<PermissionGroup>[
      PermissionGroup.location,
      PermissionGroup.locationAlways,
      PermissionGroup.locationWhenInUse,
    ]);
    log('location', error: permissionStatus[PermissionGroup.location]);
    log('locationAlways',
        error: permissionStatus[PermissionGroup.locationAlways]);
    log('locationWhenInUse',
        error: permissionStatus[PermissionGroup.locationWhenInUse]);
    _state.isLocationAutoDetectionEnabled =
        permissionStatus[PermissionGroup.location] ==
                PermissionStatus.granted ||
            permissionStatus[PermissionGroup.locationAlways] ==
                PermissionStatus.granted ||
            permissionStatus[PermissionGroup.locationWhenInUse] ==
                PermissionStatus.granted;
    next();
  }

  void next() {
    controller.nextPage(duration: kTabScrollDuration, curve: Curves.ease);
  }
  void onResult(dynamic data, ResultState state) {
    switch (state) {
      case ResultState.error:
        if (Navigator.canPop(_keyLoader.currentContext)) {
          Navigator.pop(_keyLoader.currentContext);
        }
        Dialogs.showSimpleDialog('Error', data, _keyLoader.currentContext);
        break;
      case ResultState.successful:
        if (Navigator.canPop(_keyLoader.currentContext)) {
          Navigator.pop(_keyLoader.currentContext);
          if (Navigator.canPop(_keyLoader.currentContext)) {
            Navigator.pop(_keyLoader.currentContext);
          } else {
            Navigator.pushReplacement<Menu, dynamic>(_keyLoader.currentContext,
                MaterialPageRoute<Menu>(builder: (_) => Menu()));
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
      appBar: AppBar(),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: <Widget>[
          FirstPage(
            state: _state,
            title: 'Add a new house',
            buttonIcon: const Icon(MdiIcons.arrowRight),
            animationHeightFactor: 0.5,
            animationWidthFactor: 0.9,
            animationName: 'Idle',
            buttonText: 'Next',
            animationPath: 'assets/flare/home_settings.flr',
            submitEvent: requestsPermissions,
          ),
          StreamBuilder<bool>(
              stream: _state.isLocationAutoDetectionEnabledStream$,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return CheckLocation(
                  state: _state,
                  location: _state.isLocationAutoDetectionEnabled,
                  submitEvent: () => _state.addHouse(
                    model: AddHouseModel(
                        houseName: _state.houseName,
                        geolocation: _state.geolocation,
                        onResult: onResult),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
