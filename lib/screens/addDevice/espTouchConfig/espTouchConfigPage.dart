import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/buttons/roundRectangleButton.dart';
import 'package:Homey/screens/addDevice/AddDeviceDataManager.dart';
import 'package:connectivity/connectivity.dart';
import 'package:Homey/design/widgets/textfield.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smartconfig/smartconfig.dart';

class EspTouchConfigPage extends StatefulWidget {
  EspTouchConfigPage({@required this.event}) : super();
  final Function event;

  @override
  _EspTouchConfigPageState createState() => _EspTouchConfigPageState();
}

class _EspTouchConfigPageState extends State<EspTouchConfigPage> with SingleTickerProviderStateMixin {
  _EspTouchConfigPageState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    subscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {});
  }

  var progressBar;

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
    final result = await _permissionHandler.requestPermissions([
      PermissionGroup.location,
      PermissionGroup.locationAlways,
      PermissionGroup.locationWhenInUse,
    ]);
    if (result[PermissionGroup.location] != PermissionStatus.granted &&
        result[PermissionGroup.locationAlways] != PermissionStatus.granted &&
        result[PermissionGroup.locationWhenInUse] != PermissionStatus.granted) {
      throw ('You must accept location permissions');
    }
  }

  void startESPTouchConfig(Map<String, dynamic> data) async {
    progressBar = Dialogs.showProgressDialog('Configuring...', context);
    progressBar.show();
    log('data', error: data);
    log('pass', error: passwordController.text);

    Smartconfig.start(data['name'], data['bssid'], passwordController.text)
        .then((onValue) {
      progressBar.dismiss();

      if (onValue == null) {
        Dialogs.showSimpleDialog("Error", "Error configuring sensor", context);
      } else {
        log("devices", error: onValue);
        log("IP: ", error: onValue.values.toList()[0]);
        log("Mac: ", error: onValue.keys.toList()[0]);
        WebRequestsHelpers.get(
                domain: 'http://${onValue.values.toList()[0]}',
                route: '/api/getConfig/')
            .then((response) {
          final Map<String, dynamic> res = jsonDecode(response.content());
          AddDeviceDataManager().deviceData = {
            'ip': onValue.values.toList()[0],
            'sensorName': res['sensorName'],
            'freqMinutes': res['freqMinutes'],
            'sensorType': res['sensorType'],
            'macAddress': res['macAddress'],
            'ssid': data['name'],
            'password': passwordController.text
          };
          widget.event();
          log("response", error: response);
        });
        log("sm version", error: onValue);
      }
    });
  }

  StreamSubscription subscription;

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    subscription.cancel();
  }

  AnimationController _controller;
  Animation _animation;
  TextEditingController passwordController = new TextEditingController();
  TextEditingController ssidController = new TextEditingController();
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return FadeTransition(
      opacity: _animation,
      child: FutureBuilder(
        future: Future.wait([requestsPermissions(), getNetworkInfo()])
            .then((value) => value[1]),
        builder: (BuildContext context, AsyncSnapshot value) {
          if (value.connectionState == ConnectionState.waiting ||
              value.connectionState == ConnectionState.none) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (value.hasData) {
              ssidController.text = value.data['name'].toString();
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CustomTextField(
                      inputType: TextInputType.text,
                      enabled: false,
                      icon: const Icon(MdiIcons.routerWireless),
                      controller: ssidController,
                      placeholder: "SSID",
                    ),
                    CustomTextField(
                      inputType: TextInputType.text,
                      icon: const Icon(MdiIcons.lockOutline),
                      controller: passwordController,
                      onChanged: (value) {},
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: Icon(isPasswordVisible
                            ? MdiIcons.eyeOffOutline
                            : MdiIcons.eyeOutline),
                      ),
                      placeholder: "Password",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RoundMaterialButton(
                        onPressed: () {
                          startESPTouchConfig(value.data);
                        },
                        icon: const Icon(MdiIcons.check),
                        label: "Start Config"),
                  ],
                ),
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Icon(
                        MdiIcons.wifiOff,
                        size: 80,
                      ),
                      Text(
                        value.error.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (value.error.toString() ==
                          'You must accept location permissions')
                        RoundMaterialButton(
                            onPressed: () => setState(() {}), label: 'Retry')
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
