import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smart_home_mobile/design/colors.dart';
import 'package:smart_home_mobile/design/dialogs.dart';
import 'package:smart_home_mobile/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:smart_home_mobile/screens/addHouse/pages/check_location/check_location.dart';
import 'package:smart_home_mobile/screens/addHouse/pages/first_page/first_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_home_mobile/screens/addHouse/pages/first_setup_template/first_setup_template_page.dart';
import 'package:smart_home_mobile/screens/addHouse/pages/geolocation_page/geolocation_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_home_mobile/screens/addHouse/dataModelManager.dart';

class AddHouse extends StatefulWidget {
  @override
  _AddHouseState createState() => _AddHouseState();
}

class _AddHouseState extends State<AddHouse> {
  PageController controller = PageController();
  PermissionHandler _permissionHandler = PermissionHandler();
  bool location = false;
  String houseName = 'Add a new home';
  var progressBar;

  Future requestsPermissions() async {
    var permissionStatus = await _permissionHandler.requestPermissions([
      PermissionGroup.phone,
      PermissionGroup.location,
      PermissionGroup.locationAlways,
      PermissionGroup.locationWhenInUse,
      PermissionGroup.camera,
      PermissionGroup.storage
    ]);
    setState(() {
      location = permissionStatus[PermissionGroup.location] ==
              PermissionStatus.granted ||
          permissionStatus[PermissionGroup.locationAlways] ==
              PermissionStatus.granted ||
          permissionStatus[PermissionGroup.locationWhenInUse] ==
              PermissionStatus.granted;
    });

    next();
  }

  void next() {
    log('homeName', error: HouseDataState().homeName);
    log('address', error: HouseDataState().geolocation);
    controller.nextPage(duration: kTabScrollDuration, curve: Curves.ease);
  }

  void currentLocationEvent() {
    controller.nextPage(duration: kTabScrollDuration, curve: Curves.ease);
  }

  void onError(e) {
    log('Error: ', error: e);
    progressBar.dismiss();
    Dialogs.showSimpleDialog("Error", e.toString(), context);
  }

  void addHouse() async {
    HouseDataState hds = HouseDataState();
    var _formData = {
      'houseName': hds.homeName,
      'country': hds.geolocation['Country'],
      'county': hds.geolocation['County'],
      'locality': hds.geolocation['Locality'],
      'street': hds.geolocation['Street'],
      'number': hds.geolocation['Number'],
      'userEmail': 'voicubabiciu@gmail.com',
    };
    FocusScope.of(context).unfocus();

    progressBar = Dialogs.showProgressDialog('Please wait...', context);
    await progressBar.show();
    WebRequestsHelpers.post(route: '/api/add/house', body: _formData).then(
        (response) {
      progressBar.dismiss();
      if (response.json()['success'] != null) {
        Navigator.pop(context);
      } else {
        Dialogs.showSimpleDialog("Error", response.json()['error'], context);
      }
    }, onError: onError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsTheme.background,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: <Widget>[
          FirstPage(
            title: houseName,
            buttonIcon: Icon(MdiIcons.arrowRight),
            animationHeightFactor: 0.5,
            animationWidthFactor: 0.9,
            animationName: 'Idle',
            buttonText: 'Next',
            animationPath: 'assets/flare/home_settings.flr',
            submitEvent: requestsPermissions,
          ),
          CheckLocation(
            location: location,
            submitEvent: addHouse,
          ),

        ],
      ),
    );
  }
}
//{
//"firstName": "on",
//"lastName": "on",
//"email": "voicubabiciu@gmail.com",
//"password": "Test1234"
//}