import 'package:Homey/design/colors.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/buttons/round_button.dart';
import 'package:Homey/design/widgets/device_list_item.dart';
import 'package:Homey/design/widgets/textfield.dart';
import 'package:Homey/helpers/forms_helpers/form_validations.dart';
import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/models/room_edit_model.dart';
import 'package:Homey/screens/menu/menu.dart';
import 'package:Homey/screens/room/device_selector.dart';
import 'package:Homey/states/on_result_callback.dart';
import 'package:Homey/states/room_edit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RoomEdit extends StatefulWidget {
  const RoomEdit({@required this.room});

  final RoomModel room;

  @override
  _RoomEditState createState() => _RoomEditState();
}

class _RoomEditState extends State<RoomEdit> {
  final TextEditingController _roomNameController = TextEditingController();

  final RoomEditState _state = RoomEditState();
  final ScrollController ctrl = ScrollController();

  Widget getHeader(String image) {
    return Container(
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: const Alignment(0, -0.5),
            end: Alignment.bottomCenter,
            colors: <Color>[ColorsTheme.background, Colors.transparent],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.dstIn,
        child: FractionallySizedBox(
          heightFactor: 0.25,
          widthFactor: 1,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
                ColorsTheme.background.withOpacity(0.3), BlendMode.multiply),
            child: Image.asset(
              image == '' ? 'assets/images/custom_room.jpg' : image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _state.init(widget.room);
    _roomNameController.text = _state.currentRoom.roomName;
    return WillPopScope(
      onWillPop: () async {
        await _state.updateRoom(onUpdateResult);
        return true;
      },
      child: Scaffold(
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<DeviceSelector>(
                  builder: (_) => DeviceSelector(
                      roomDbId: widget.room.dbId, roomId: widget.room.id))),
//          backgroundColor: Colors.white,
          child: Icon(MdiIcons.plus),
        ),
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: StreamBuilder<Map<String, dynamic>>(
                  stream: _state.roomStyleStream$,
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    return getHeader(_state.roomStyle['image']);
                  }),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        flex: 7,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            RoundButton(
                              icon: Icon(MdiIcons.chevronLeft,
                                  color: Colors.black),
                              padding: const EdgeInsets.all(8),
                              onPressed: () => _state
                                  .updateRoom(onUpdateResult)
                                  .then((_) => Navigator.pop(context)),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            StreamBuilder<RoomEditModel>(
                              stream: _state.currentRoomStream$,
                              builder: (BuildContext context,
                                  AsyncSnapshot<RoomEditModel> snapshot) {
                                return Flexible(
                                  child: Text(
                                    _state.currentRoom.roomName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: RoundButton(
                          onPressed: () => _state.removeRoom(onDeleteResult),
                          padding: const EdgeInsets.all(12),
                          backgroundColor: Colors.red,
                          icon: Icon(MdiIcons.trashCanOutline,
                              color: Colors.white, size: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.5),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomTextField(
                  autoValidate: true,
                  inputType: TextInputType.text,
                  icon: const Icon(MdiIcons.email),
                  controller: _roomNameController,
                  validator: FormValidation.simpleValidator,
                  placeholder: 'Room name',
                  onSubmitted: () => FocusScope.of(context).unfocus(),
                  textLength: 50,
                  onChanged: _state.getStyleByName,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: 0.65,
                child: StreamBuilder<List<SensorModel>>(
                  stream: _state.currentSensorsStream$,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<SensorModel>> snapshot) {
                    return ListView.builder(
                      controller: ctrl,
                      padding: const EdgeInsets.only(left:16, top: 16, right: 16, bottom: 90),
                      itemCount: _state.currentSensors.length,
                      itemBuilder: (BuildContext context, int index) {
                        return DeviceListItem(
                          sensor: _state.currentSensors[index],
                          action: RoundButton(
                            padding: const EdgeInsets.all(8),
                            onPressed: () => _state.removeDeviceFromRoom(
                                _state.currentSensors[index], onResult),
                            icon: Icon(MdiIcons.close,
                                color: Colors.red, size: 16),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onResult(dynamic data, ResultState state) {
    switch (state) {
      case ResultState.error:
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        Dialogs.showSimpleDialog('Error', data, context);
        break;
      case ResultState.successful:
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        break;
      case ResultState.loading:
        Dialogs.showProgressDialog(data, context);
        break;
    }
  }

  void onDeleteResult(dynamic data, ResultState state) {
    switch (state) {
      case ResultState.error:
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        Dialogs.showSimpleDialog('Error', data, context);
        break;
      case ResultState.successful:
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute<Menu>(builder: (_) => Menu()));
        }
        break;
      case ResultState.loading:
        Dialogs.showProgressDialog(data, context);
        break;
    }
  }

  void onUpdateResult(dynamic data, ResultState state) {
    switch (state) {
      case ResultState.error:
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        Dialogs.showSimpleDialog('Error', data, context);
        break;
      case ResultState.successful:
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        break;
      case ResultState.loading:
        Dialogs.showProgressDialog(data, context);
        break;
    }
  }
}
