import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Homey/design/colors.dart';
import 'package:connectivity/connectivity.dart';
import 'package:Homey/design/widgets/textfield.dart';
import 'package:Homey/helpers/forms_helpers/forms_helpers.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:Homey/screens/devices/devices.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smartconfig/smartconfig.dart';

class Config extends StatefulWidget {
  @override
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {});
  }

  Future<Map<String, dynamic>> getNetworkInfo() async {
//    await Connectivity().requestLocationServiceAuthorization();
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      throw ('You have to be connected to wifi');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      var data = {
        'name': await Connectivity().getWifiName(),
        'ip': await Connectivity().getWifiIP(),
        'bssid': await Connectivity().getWifiBSSID(),
      };
      log('data', error: data);
      return data;
    }
    throw ('unexpected error');
  }

  PermissionHandler _permissionHandler = PermissionHandler();

  Future requestsPermissions() async {
    await _permissionHandler.requestPermissions([
      PermissionGroup.location,
      PermissionGroup.locationAlways,
      PermissionGroup.locationWhenInUse,
    ]);
  }

  void _showDialog(String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void startESPTouchConfig(Map<String, dynamic> data) async {
    var pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(
      message: "Configuring...",
      insetAnimCurve: Curves.easeInOut,
      progressWidget: Container(
          padding: EdgeInsets.all(10.0), child: CircularProgressIndicator()),
    );
    pr.show();
    Smartconfig.start(data['name'], data['bssid'], passwordController.text)
        .then((onValue) {
      if (onValue == null) {
        _showDialog("Error", "Error configuring sensor");
      } else {
        log("devices", error: onValue);
        log("IP: ", error: onValue.values.toList()[0]);
        Future.delayed(Duration(seconds: 5)).then((response) {
          WebRequestsHelpers.get(
                  domain: 'http://${onValue.values.toList()[0]}',
                  route: '/api/getConfig/')
              .then((response) {
            log("GET", error: response.content());
            Map<String, dynamic> res = jsonDecode(response.content());
            Map<String, dynamic> obj = {
              'ip': onValue.values.toList()[0],
              'sensorName': res['sensorName'],
              'freqMinutes': res['freqMinutes'],
              'sensorType': res['sensorType'],
              'ssid': data['name'],
              'password': passwordController.text
            };
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Devices(obj)));
            log("response", error: response);
          });
          log("sm version", error: onValue);
        });
      }
      pr.dismiss();
    });
  }

  StreamSubscription subscription;

  @override
  initState() {
    super.initState();

    subscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    subscription.cancel();
  }

  TextEditingController passwordController = new TextEditingController();
  TextEditingController ssidController = new TextEditingController();
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorsTheme.background,
        title: Text('Add device'),
      ),
      body: FutureBuilder(
        future: Future.wait([requestsPermissions(), getNetworkInfo()])
            .then((value) => value[1]),
        builder: (BuildContext context, AsyncSnapshot value) {
          if (value.connectionState == ConnectionState.waiting ||
              value.connectionState == ConnectionState.none) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else {
            if (value.hasData) {
              ssidController.text = value.data['name'].toString();
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CustomTextField(
                      inputType: TextInputType.text,
                      enabled: false,
                      icon: Icon(MdiIcons.routerWireless),
                      controller: ssidController,
                      placeholder: "SSID",
                    ),
                    CustomTextField(
                      inputType: TextInputType.text,
//                      isPassword: isPasswordVisible,
                      icon: Icon(MdiIcons.lockOutline),
                      controller: passwordController,
                      onChanged: (value) {},
                      suffix: IconButton(
                        onPressed: () {
//                          setState(() {
//                            isPasswordVisible = !isPasswordVisible;
//                          });
                        },
                        icon: Icon(isPasswordVisible
                            ? MdiIcons.eyeOffOutline
                            : MdiIcons.eyeOutline),
                      ),
                      placeholder: "Password",
                    ),
                    SizedBox(height: 10,),
                    FloatingActionButton.extended(
                      onPressed: () {
                        startESPTouchConfig(value.data);
                      },
                      icon: Icon(MdiIcons.check),
                      label: Text("Start Config"),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        MdiIcons.wifiOff,
                        size: 80,
                      ),
                      Text(
                        value.error.toString(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
