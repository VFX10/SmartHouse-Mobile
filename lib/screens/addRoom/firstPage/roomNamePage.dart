import 'dart:convert';
import 'dart:developer';

import 'package:Homey/design/dialogs.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:Homey/screens/home/homePageState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/design/widgets/textfield.dart';
import 'package:Homey/helpers/forms_helpers/form_validations.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';


import '../../../AppDataManager.dart';

class RoomName extends StatefulWidget {


  @override
  _RoomName createState() => _RoomName();
}

class _RoomName extends State<RoomName> with SingleTickerProviderStateMixin {
  final TextEditingController roomNameController = new TextEditingController();
  var progressBar;

  @override
  void dispose() {
    _controller.dispose();
    roomNameController.dispose();
    super.dispose();
  }

  AnimationController _controller;
  Animation _animation;

  void onError(e) {
    log('Error: ', error: e);
    progressBar.dismiss();
    Dialogs.showSimpleDialog("Error", e.toString(), context);
  }
  
  void addRoom() async {

    final HomePageState state =
    Provider.of<HomePageState>(context, listen: false);
    var _formData = {
      'roomName': roomNameController.text,
      'houseId': state.selectedHome['id'],
    };
    FocusScope.of(context).unfocus();

    progressBar = Dialogs.showProgressDialog('Please wait...', context);
    await progressBar.show();
    WebRequestsHelpers.post(route: '/api/add/room', body: _formData).then(
        (response) async {
      progressBar.dismiss();
      if (response.json()['success'] != null) {
        await AppDataManager().addRoom(response.json()['data']);

        state.selectedRooms = AppDataManager().defaultHome['rooms'];
          Navigator.pop(context);

      } else {
        Dialogs.showSimpleDialog("Error", response.json()['error'], context);
      }
    }, onError: onError);
  }

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

  final _formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  var roomNames = {
    'Living room',
    'Bathroom',
    'Bedroom',
    'Kitchen',
    'Hall',
    'Office',
    'Guest room'
  };

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
          backgroundColor: ColorsTheme.background,
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Form(
          key: _formKey,
          autovalidate: autoValidate,
          child: Container(
            padding: new EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                    child: Icon(
                      MdiIcons.floorPlan,
                      color: Colors.white,
                      size: 140,
                    ),

                ),

                Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                Text(
                  'Enter your room name',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Utils.getPercentValueFromScreenWidth(8, context),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                Wrap(
                  spacing: 10,
                  children: <Widget>[
                    for (var name in roomNames)
                      GestureDetector(
                        onTap: () {
                          roomNameController.text = name;
                          addRoom();
                        },
                        child: Chip(
                          label: Text(name),
                          backgroundColor: ColorsTheme.primary,
                        ),
                      ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                CustomTextField(
                  inputType: TextInputType.text,
                  icon: Icon(MdiIcons.floorPlan),
                  controller: roomNameController,
                  validator: (value) => FormValidation.simpleValidator(value),
                  placeholder: "Room name",
                  onSubmitted: () {
                    if (_formKey.currentState.validate()) {
                      FocusScope.of(context).unfocus();
                      addRoom();
                    } else {
                      setState(() {
                        autoValidate = true;
                      });
                    }
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                Center(
                  child: FloatingActionButton.extended(
                    elevation: 20,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        FocusScope.of(context).unfocus();
                        addRoom();
                      } else {
                        setState(() {
                          autoValidate = true;
                        });
                      }
                    },
                    backgroundColor: ColorsTheme.primary,
                    icon: Icon(MdiIcons.plus),
                    label: Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
