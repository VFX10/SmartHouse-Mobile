import 'dart:convert';
import 'dart:developer';

import 'package:smart_home_mobile/config.dart';
import 'package:smart_home_mobile/design/widgets/textfield.dart';
import 'package:smart_home_mobile/helpers/forms_helpers/form_validations.dart';
import 'package:smart_home_mobile/helpers/forms_helpers/forms_helpers.dart';
import 'package:smart_home_mobile/helpers/utils.dart';
import 'package:smart_home_mobile/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:requests/requests.dart' as http;

class Devices extends StatefulWidget {
  Devices(Map<String, dynamic> obj) {
    this.obj = obj;
    log("devices", error: obj);
  }

  Map<String, dynamic> obj;

  @override
  _DevicesState createState() => _DevicesState(obj);
}

class _DevicesState extends State<Devices> with SingleTickerProviderStateMixin {
  Map<String, dynamic> obj;

  _DevicesState(Map<String, dynamic> obj) {
    this.obj = obj;
    sensorNameController.text = obj['sensorName'];
    readingFrequencyController.text = obj['freqMinutes'].toString();
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
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(seconds: 1),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

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

  @override
  Widget build(BuildContext context) {
    _formData = {
      'port': portController.text,
      'server': serverController.text,
      'sensorName': sensorNameController.text,
      'freqMinutes': readingFrequencyController.text,
      'ssid': obj['ssid'],
      'password': obj['password']
    };
    var Sensors = [
      'undefined',
      'UV',
      'SWITCH',
      'Temperature and Humidity',
      'Light',
      'Gas and Smoke',
      'Door'
    ];
    _controller.forward();
    log("data", error: _formData);
    return Scaffold(
      body: Builder(
        builder: (context) => FadeTransition(
          opacity: _animation,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                width: Utils.getPercentValueFromScreenWidth(100, context),
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      Sensors[obj['sensorType']],
                      textAlign: TextAlign.center,
                    ),
                    CustomTextField(
                      inputType: TextInputType.url,
                      icon: Icon(Icons.email),
                      controller: sensorNameController,
                      focusNode: sensorNameFocus,
                      suffix: IconButton(
                        onPressed: () {
                          FormHelpers.clearField(sensorNameController);
                        },
                        icon: Icon(Icons.clear),
                      ),
                      placeholder: "Sensor name",
                    ),
                    CustomTextField(
                      inputType: TextInputType.number,
                      icon: Icon(Icons.phone),
                      controller: readingFrequencyController,
                      placeholder: "Reading frequency",
                      focusNode: readingFrequencyFocus,
                      suffix: IconButton(
                        onPressed: () {
                          FormHelpers.clearField(readingFrequencyController);
                        },
                        icon: Icon(Icons.clear),
                      ),
                      onSubmitted: clickEvent,
                    ),
                    CustomTextField(
                      inputType: TextInputType.url,
                      icon: Icon(Icons.account_circle),
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
                      icon: Icon(Icons.account_circle),
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
                      onPressed: clickEvent,
                      icon: Icon(Icons.check),
                      backgroundColor: Colors.green,
                      label: Text("Finalizare"),
                    ),
                    FloatingActionButton.extended(
                      heroTag: "2",
                      onPressed: onEvents,
                      icon: Icon(Icons.check),
                      backgroundColor: Colors.green,
                      label: Text("ON"),
                    ),
                    FloatingActionButton.extended(
                      heroTag: "3",
                      onPressed: offEvents,
                      icon: Icon(Icons.check),
                      backgroundColor: Colors.green,
                      label: Text("OFF"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void offEvents() {
    var body = {'event': 'off'};
    WebRequestsHelpers.post(
            domain: 'http://${obj['ip']}', route: '/api/events', body: body)
        .then((response) {
      if (response.json()['state'] != null) {
        _showDialog("Success", response.json()['state'] == 1 ? "ON" : "OFF");
      } else {
        _showDialog("Error", response.json()['error']);
      }
    });
  }

  void onEvents() {
    var body = {'event': "on"};
    log("body", error: body);
    WebRequestsHelpers.post(
            domain: 'http://${obj['ip']}', route: '/api/events', body: body)
        .then((response) {
      if (response.json()['state'] != null) {
        _showDialog("Success", response.json()['state'] == 1 ? "ON" : "OFF");
      } else {
        _showDialog("Error", response.json()['error']);
      }
    });
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

  void clickEvent() async {
    setState(() {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        log("submit", error: _formData);
        var pr = ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: false);
        pr.style(
          message: "Asteptati...",
          insetAnimCurve: Curves.easeInOut,
          progressWidget: Container(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator()),
        );
        pr.show();
        WebRequestsHelpers.post(
                domain: 'http://${obj['ip']}',
                route: '/api/config',
                body: _formData)
            .then((response) {
          pr.dismiss();
          if (response != null) {
            if (response.json()['message'] != null) {
              _showDialog("Success", response.json()['message']);
            } else {
              _showDialog("Error", response.json()['error']);
            }
          }
        });
      } else {
        setState(() {
          formAutoValidate = true;
          final res = FormValidation.emailValidator(sensorNameController.text);
        });
      }
    });
  }
}
