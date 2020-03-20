import 'dart:developer';

import 'package:Homey/app_data_manager.dart';
import 'package:Homey/data/add_room_state.dart';
import 'package:Homey/data/menu_state.dart';
import 'package:Homey/data/models/add_room_model.dart';
import 'package:Homey/data/on_result_callback.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/design/widgets/textfield.dart';
import 'package:Homey/helpers/forms_helpers/form_validations.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/provider/asset_flare.dart';

import 'package:Homey/main.dart';

class RoomName extends StatelessWidget {
  final TextEditingController roomNameController = TextEditingController();
  final GlobalKey<State> _stateKey = GlobalKey<State>();
  final AddRoomState _state = getIt.get<AddRoomState>();

//  Future<void> addRoom() async {
//
//    final Map<String, dynamic> formData = <String, dynamic>{
//      'roomName': roomNameController.text,
//      'houseId': getIt.get<MenuState>().selectedHome.dbId,
//    };
//    FocusScope.of(context).unfocus();
//
//    progressBar = Dialogs.showProgressDialog('Please wait...', context);
//    await progressBar.show();
//    await WebRequestsHelpers.post(route: '/api/add/room', body: formData).then(
//        (dynamic response) async {
//      progressBar.dismiss();
//      final dynamic data = response.json();
//      if (data['success'] != null) {
//        final RoomModel room = RoomModel(
//          dbId: data['data']['id'],
//          houseId: AppDataManager().defaultHome.id,
//          name: data['data']['name'],
//        );
//        await AppDataManager().addRoom(room);
////        state.selectedRooms.add(room);
//        Navigator.pop(context);
//      } else {
//        Dialogs.showSimpleDialog('Error', response.json()['error'], context);
//      }
//    }, onError: onError);
//  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> roomNames = <String>[
    'Living room',
    'Bathroom',
    'Bedroom',
    'Kitchen',
    'Hallway',
    'Office',
    'Guest room'
  ];

  void onResult(dynamic data, ResultState resultState) {
    switch (resultState) {
      case ResultState.error:
        if (Navigator.canPop(_stateKey.currentContext)) {
          Navigator.pop(_stateKey.currentContext);
        }
        Dialogs.showSimpleDialog('Error', data, _stateKey.currentContext);
        break;
      case ResultState.successful:
        if (Navigator.canPop(_stateKey.currentContext)) {
          Navigator.pop(_stateKey.currentContext);
          if (Navigator.canPop(_stateKey.currentContext)) {
            Navigator.pop(_stateKey.currentContext);
          }
        }
        break;
      case ResultState.loading:
        Dialogs.showProgressDialog(data, _stateKey.currentContext);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _stateKey,
      appBar: AppBar(),
      body: StreamBuilder<bool>(
          stream: _state.autoValidateStream$,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return Form(
              key: _formKey,
              autovalidate: _state.autoValidate,
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
                        fontSize:
                            Utils.getPercentValueFromScreenWidth(8, context),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                    Wrap(
                      spacing: 10,
                      children: <Widget>[
                        for (final String name in roomNames)
                          GestureDetector(
                            onTap: () => _state.addRoom(
                                model: AddRoomModel(
                                    roomName: name,
                                    onResult: onResult)),
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
                      icon: const Icon(MdiIcons.floorPlan),
                      controller: roomNameController,
                      validator: FormValidation.simpleValidator,
                      placeholder: 'Room name',
                      onSubmitted: () {
                        if (_formKey.currentState.validate()) {
                          FocusScope.of(context).unfocus();
                          _state.addRoom(
                              model: AddRoomModel(
                                  roomName: roomNameController.text,
                                  onResult: onResult));
                        } else {
                          _state.autoValidate = true;
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
                            _state.addRoom(
                                model: AddRoomModel(
                                    roomName: roomNameController.text,
                                    onResult: onResult));
                          } else {
                            _state.autoValidate = true;
                          }
                        },
                        backgroundColor: ColorsTheme.primary,
                        icon: const Icon(MdiIcons.plus),
                        label: const Text('Next'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
