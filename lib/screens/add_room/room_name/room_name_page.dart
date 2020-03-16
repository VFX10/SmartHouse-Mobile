import 'dart:developer';

import 'package:Homey/app_data_manager.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:Homey/screens/home/home_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/design/widgets/textfield.dart';
import 'package:Homey/helpers/forms_helpers/form_validations.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/provider/asset_flare.dart';

import 'package:progress_dialog/progress_dialog.dart';

class RoomName extends StatefulWidget {
  @override
  _RoomName createState() => _RoomName();
}

class _RoomName extends State<RoomName> with SingleTickerProviderStateMixin {
  final TextEditingController roomNameController = TextEditingController();
  ProgressDialog progressBar;

  @override
  void dispose() {
    _controller.dispose();
    roomNameController.dispose();
    super.dispose();
  }

  AnimationController _controller;
  Animation<double> _animation;

  void onError(Object e) {
    log('Error: ', error: e);
    progressBar.dismiss();
    Dialogs.showSimpleDialog('Error', e.toString(), context);
  }

  Future<void> addRoom() async {
    final HomePageState state =
        Provider.of<HomePageState>(context, listen: false);
    final Map<String, dynamic> formData = <String, dynamic>{
      'roomName': roomNameController.text,
      'houseId': state.selectedHome.dbId,
    };
    FocusScope.of(context).unfocus();

    progressBar = Dialogs.showProgressDialog('Please wait...', context);
    await progressBar.show();
    await WebRequestsHelpers.post(route: '/api/add/room', body: formData).then(
        (dynamic response) async {
      progressBar.dismiss();
      final dynamic data = response.json();
      if (data['success'] != null) {
        final RoomModel room = RoomModel(
          dbId: data['data']['id'],
          houseId: AppDataManager().defaultHome.id,
          name: data['data']['name'],
        );
        await AppDataManager().addRoom(room);
//        state.selectedRooms.add(room);
        Navigator.pop(context);
      } else {
        Dialogs.showSimpleDialog('Error', response.json()['error'], context);
      }
    }, onError: onError);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  final List<String> roomNames = <String>[
    'Living room',
    'Bathroom',
    'Bedroom',
    'Kitchen',
    'Hall',
    'Office',
    'Guest room'
  ];

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return Scaffold(
      appBar: AppBar(),
      body: FadeTransition(
        opacity: _animation,
        child: Form(
          key: _formKey,
          autovalidate: autoValidate,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (MediaQuery.of(context).viewInsets.bottom == 0)
                  Flexible(
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      heightFactor: 0.5,
                      child: FlareActor.asset(
                        AssetFlare(
                            bundle: rootBundle,
                            name: 'assets/flare/add_room.flr'),
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: 'animation',
                      ),
                    ),
                  ),
                const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                Text(
                  'Enter your room name',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Utils.getPercentValueFromScreenWidth(8, context),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                Wrap(
                  spacing: 10,
                  children: <Widget>[
                    for (final String name in roomNames)
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
                const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                CustomTextField(
                  inputType: TextInputType.text,
                  icon: Icon(MdiIcons.floorPlan),
                  controller: roomNameController,
                  validator: FormValidation.simpleValidator,
                  placeholder: 'Room name',
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
                const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
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
                    label: const Text('Next'),
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
