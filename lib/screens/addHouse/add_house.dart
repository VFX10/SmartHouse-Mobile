import 'dart:developer';

import 'package:Homey/app_data_manager.dart';
import 'package:Homey/helpers/sql_helper/data_models/home_model.dart';
import 'package:Homey/screens/home/home.dart';
import 'package:Homey/screens/home/home_page_state.dart';
import 'package:flutter/material.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:Homey/screens/addHouse/pages/check_location/check_location.dart';
import 'package:Homey/screens/addHouse/pages/first_page/first_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Homey/screens/addHouse/dataModelManager.dart';
import 'package:provider/provider.dart';

class AddHouse extends StatefulWidget {
  @override
  _AddHouseState createState() => _AddHouseState();
}

class _AddHouseState extends State<AddHouse> {
  final PageController controller = PageController();
  final PermissionHandler _permissionHandler = PermissionHandler();
  bool location = false;
  String houseName = 'Add a new home';
  var progressBar;

  Future requestsPermissions() async {
    var permissionStatus = await _permissionHandler.requestPermissions([
      PermissionGroup.location,
      PermissionGroup.locationAlways,
      PermissionGroup.locationWhenInUse,
    ]);
    log('location',  error: permissionStatus[PermissionGroup.location]);
    log('locationAlways',  error: permissionStatus[PermissionGroup.locationAlways]);
    log('locationWhenInUse',  error: permissionStatus[PermissionGroup.locationWhenInUse]);
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
      'userEmail': AppDataManager().userData.email,
    };
    FocusScope.of(context).unfocus();

    progressBar = Dialogs.showProgressDialog('Please wait...', context);
    await progressBar.show();
    WebRequestsHelpers.post(route: '/api/add/house', body: _formData).then(
        (response) async {
      progressBar.dismiss();
      var data = response.json();
      if (data['success'] != null) {
        await AppDataManager().addHouse(HomeModel(
            dbId: data['house']['id'],
            userId: AppDataManager().userData.id,
            name: data['house']['name'],
            address: data['house']['address'],
        ));
        final HomePageState state =
            Provider.of<HomePageState>(context, listen: false);
        state.setHome(AppDataManager().defaultHome);
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      } else {
        Dialogs.showSimpleDialog("Error", response.json()['error'], context);
      }
    }, onError: onError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: <Widget>[
          FirstPage(
            title: houseName,
            buttonIcon: const Icon(MdiIcons.arrowRight),
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
