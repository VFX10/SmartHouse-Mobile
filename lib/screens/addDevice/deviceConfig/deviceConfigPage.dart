import 'dart:developer';

import 'package:Homey/design/colors.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/textfield.dart';
import 'package:Homey/helpers/data_types.dart';
import 'package:Homey/helpers/forms_helpers/forms_helpers.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:Homey/screens/addDevice/AddDeviceDataManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DeviceConfig extends StatefulWidget {
  DeviceConfig({this.event}):super();
  final Function event;
  @override
  _DeviceConfigState createState() => _DeviceConfigState();
}

class _DeviceConfigState extends State<DeviceConfig> with SingleTickerProviderStateMixin {
  _DeviceConfigState() {
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(seconds: 1),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  String selectedCounty;
  final TextEditingController portController = TextEditingController(),
      serverController = TextEditingController(),
      sensorNameController = TextEditingController(),
      readingFrequencyController = TextEditingController();
  final FocusNode portFocus = FocusNode(),
      serverFocus = FocusNode(),
      sensorNameFocus = FocusNode(),
      readingFrequencyFocus = FocusNode();
  bool formAutoValidate = false;
  final _formKey = GlobalKey<FormState>();
  Map<dynamic, dynamic> _formData;

  @override
  void setState(fn) {
    // check if state is mounted before calling setState() method
    if (mounted) {
      super.setState(fn);
    }
  }

  AnimationController _controller;
  Animation _animation;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    portController.dispose();
    serverController.dispose();
    sensorNameController.dispose();
    readingFrequencyController.dispose();
    _controller.dispose();
    super.dispose();
  }

  var progressBar;
  var deviceData;


  @override
  Widget build(BuildContext context) {
    progressBar = Dialogs.showProgressDialog('Configuring device...', context);
    deviceData = AddDeviceDataManager().deviceData;

    sensorNameController.text =
        deviceData != null ? deviceData['sensorName'] : '';
    readingFrequencyController.text =
        deviceData != null ? deviceData['freqMinutes'].toString() : '';
    _controller.forward();
    return Scaffold(
      body: Builder(
        builder: (context) => FadeTransition(
          opacity: _animation,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  width: Utils.getPercentValueFromScreenWidth(100, context),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                          deviceData != null
                              ? DataTypes.sensorsType[deviceData['sensorType']]['icon']
                              : MdiIcons.help,
                          size: 40),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        deviceData != null
                            ? DataTypes.sensorsType[deviceData['sensorType']]['text']
                            : DataTypes.sensorsType[0]['text'],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                      CustomTextField(
                        inputType: TextInputType.url,
                        icon: Icon(MdiIcons.text),
                        controller: sensorNameController,
                        focusNode: sensorNameFocus,
                        suffix: IconButton(
                          onPressed: () {
                            FormHelpers.clearField(sensorNameController);
                          },
                          icon: Icon(
                            Icons.clear,
                          ),
                        ),
                        placeholder: "Sensor name",
                      ),
                      CustomTextField(
                        inputType: TextInputType.number,
                        icon: Icon(MdiIcons.clockOutline),
                        controller: readingFrequencyController,
                        placeholder: "Reading frequency",
                        focusNode: readingFrequencyFocus,
                        suffix: IconButton(
                          onPressed: () {
                            FormHelpers.clearField(readingFrequencyController);
                          },
                          icon: Icon(Icons.clear),
                        ),
                        onSubmitted: saveConfig,
                      ),
                      CustomTextField(
                        inputType: TextInputType.url,
                        icon: Icon(MdiIcons.server),
                        placeholder: "Server",
                        focusNode: serverFocus,
                        controller: serverController,
                        suffix: IconButton(
                          onPressed: () {
                            FormHelpers.clearField(serverController);
                          },
                          icon: Icon(Icons.clear),
                        ),
                        onSubmitted: () {
                          FormHelpers.fieldFocusChange(
                              context, serverFocus, portFocus);
                        },
                      ),
                      CustomTextField(
                        inputType: TextInputType.number,
                        icon: Icon(MdiIcons.numeric),
                        placeholder: "Port",
                        controller: portController,
                        focusNode: portFocus,
                        suffix: IconButton(
                          onPressed: () {
                            FormHelpers.clearField(portController);
                          },
                          icon: Icon(Icons.clear),
                        ),
                        onSubmitted: () {
                          FormHelpers.fieldFocusChange(
                              context, portFocus, sensorNameFocus);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      FloatingActionButton.extended(
                        heroTag: "1",
                        onPressed: saveConfig,
                        icon: Icon(Icons.check),
                        backgroundColor: ColorsTheme.primary,
                        label: Text("Select room"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onError(e) {
    log('Error: ', error: e);
    Dialogs.showSimpleDialog("Error", e.toString(), context);
  }

  void saveConfig() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      log("submit", error: _formData);

      _formData = {
        'port': portController.text,
        'server': serverController.text,
        'sensorName': sensorNameController.text,
        'freqMinutes': readingFrequencyController.text,
        'roomId': AddDeviceDataManager().deviceData['roomId'],
        'ssid': deviceData['ssid'],
        'password': deviceData['password']
      };

      progressBar.show();
      WebRequestsHelpers.post(
              domain: 'http://${deviceData['ip']}',
              route: '/api/config',
              body: _formData)
          .then((response) async{
        progressBar.dismiss();
        if (response != null) {
          if (response.json()['message'] != null) {
//            Dialogs.showSimpleDialog(
//                "Success", response.json()['message'], context);
          AddDeviceDataManager().deviceData['sensorName'] = sensorNameController.text;
          AddDeviceDataManager().deviceData['freqMinutes'] = readingFrequencyController.text;
          log('data', error: AddDeviceDataManager().deviceData);

           widget.event();
          } else {
            Dialogs.showSimpleDialog(
                "Error", response.json()['error'], context);
          }
        }
      });
      progressBar.dismiss();

    } else {
      setState(() {
        formAutoValidate = true;
      });
    }
  }
}
