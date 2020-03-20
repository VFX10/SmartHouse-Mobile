import 'package:Homey/data/models/room_edit_model.dart';
import 'package:Homey/data/room_edit_state.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/design/rooms_styles.dart';
import 'package:Homey/design/widgets/buttons/round_button.dart';
import 'package:Homey/design/widgets/network_status.dart';
import 'package:Homey/design/widgets/textfield.dart';
import 'package:Homey/helpers/data_types.dart';
import 'package:Homey/helpers/forms_helpers/form_validations.dart';
import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:Homey/main.dart';
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
  final RoomEditState _state = getIt<RoomEditState>();
  final ScrollController ctrl = ScrollController();

  Widget getHeader(String image) {
    return Container(
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: const Alignment(0, -0.5),
            end: Alignment.bottomCenter,
            colors: [ColorsTheme.background, Colors.transparent],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.dstIn,
        child: FractionallySizedBox(
          heightFactor:  0.25,
          widthFactor: 1,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
                ColorsTheme.background.withOpacity(0.3),
                BlendMode.multiply),
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
    _state.getStyleByName(widget.room.name);
    _roomNameController.text = _state.currentRoom.roomName;

    return Scaffold(
      body: Stack(
        children: <Widget>[
//          StreamBuilder<RoomEditModel>(
//              stream: _state.currentRoomStream$,
//              builder: (BuildContext context,
//                  AsyncSnapshot<RoomEditModel> snapshot) {
//                return Positioned.fill(
//                  child: AnimatedCrossFade(
//                    key: _animationKey,
//                    duration: const Duration(seconds: 1),
//                    firstChild: Container(
//                      child: ShaderMask(
//                        shaderCallback: (Rect rect) {
//                          return LinearGradient(
//                            begin: const Alignment(0, -0.5),
//                            end: Alignment.bottomCenter,
//                            colors: [
//                              ColorsTheme.background,
//                              Colors.transparent
//                            ],
//                          ).createShader(
//                              Rect.fromLTRB(0, 0, rect.width, rect.height));
//                        },
//                        blendMode: BlendMode.dstIn,
//                        child: Container(
//                          height: Utils.getPercentValueFromScreenHeight(40, context),
//                          width: Utils.getPercentValueFromScreenWidth(100, context),
//                          child: ColorFiltered(
//                            colorFilter: ColorFilter.mode(
//                                ColorsTheme.background.withOpacity(0.3),
//                                BlendMode.multiply),
//                            child: Image.asset(
//                              _state.currentRoom.roomStyle['image'],
//                              fit: BoxFit.cover,
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                    secondChild: Container(
//                      child: ShaderMask(
//                        shaderCallback: (Rect rect) {
//                          return LinearGradient(
//                            begin: const Alignment(0, -0.5),
//                            end: Alignment.bottomCenter,
//                            colors: [
//                              ColorsTheme.background,
//                              Colors.transparent
//                            ],
//                          ).createShader(
//                              Rect.fromLTRB(0, 0, rect.width, rect.height));
//                        },
//                        blendMode: BlendMode.dstIn,
//                        child: Container(
//                          height: Utils.getPercentValueFromScreenHeight(40, context),
//                          width: Utils.getPercentValueFromScreenWidth(100, context),
//                          child: ColorFiltered(
//                            colorFilter: ColorFilter.mode(
//                                ColorsTheme.background.withOpacity(0.3),
//                                BlendMode.multiply),
//                            child: Image.asset(
//                              _state.currentRoom.roomStyle['image'],
//                              fit: BoxFit.cover,
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                    crossFadeState: _state.currentRoom.didChanged
//                        ? CrossFadeState.showFirst
//                        : CrossFadeState.showSecond,
//                  ),
//                );
//              }),
          Align(
            alignment: Alignment.topCenter,
            child: StreamBuilder<RoomEditModel>(
                stream: _state.currentRoomStream$,
                builder: (BuildContext context,
                    AsyncSnapshot<RoomEditModel> snapshot) {
                  return getHeader(_state.currentRoom.roomStyle['image']);
                }),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    RoundButton(
                      icon: Icon(MdiIcons.chevronLeft, color: Colors.black),
                      padding: const EdgeInsets.all(8),
                      onPressed: () => Navigator.pop(context),
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
                        }),
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
                inputType: TextInputType.emailAddress,
                icon: const Icon(MdiIcons.email),
                controller: _roomNameController,
                validator: FormValidation.simpleValidator,
                placeholder: 'Room name',
                textLength: 50,
                onChanged: (String value) {
                  print(value);
                  _state.getStyleByName(value);
                },
              ),
            ),
          ), Align(
            alignment: const Alignment(0, -0.5),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomTextField(
                autoValidate: true,
                inputType: TextInputType.emailAddress,
                icon: const Icon(MdiIcons.email),
                controller: _roomNameController,
                validator: FormValidation.simpleValidator,
                placeholder: 'Room name',
                textLength: 50,
                onChanged: (String value) {
                  print(value);
                  _state.getStyleByName(value);
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.65,
              child: ListView.builder(
                controller: ctrl,
                padding: const EdgeInsets.all(16),
                itemCount: widget.room.sensors.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 20,
                    color: ColorsTheme.backgroundCard,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          Icon(DataTypes.sensorsType[
                              widget.room.sensors[index].sensorType]['icon']),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(widget.room.sensors[index].name),
                          const Spacer(),
                          RoundButton(
                            padding: const EdgeInsets.all(8),
                            onPressed: () {},
                            icon: Icon(MdiIcons.close,
                                color: Colors.red, size: 16),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        child: Icon(MdiIcons.plus),
      ),
    );
  }
}
