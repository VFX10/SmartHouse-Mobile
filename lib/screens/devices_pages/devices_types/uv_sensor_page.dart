import 'package:Homey/design/colors.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/buttons/round_button.dart';
import 'package:Homey/design/widgets/network_status.dart';
import 'package:Homey/design/widgets/uv_index_card.dart';
import 'package:Homey/helpers/mqtt.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/helpers/states_manager.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:Homey/models/devices_models/device_page_model.dart';
import 'package:Homey/screens/devices_pages/device_info.dart';
import 'package:Homey/states/devices_states/devices_temp_state.dart';
import 'package:Homey/states/on_result_callback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Homey/helpers/data_types.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:google_fonts/google_fonts.dart';

class UVSensorPage extends StatefulWidget {
  const UVSensorPage({@required this.sensor}) : super();

  final SensorModel sensor;

  @override
  _UVSensorPageState createState() => _UVSensorPageState();
}

class _UVSensorPageState extends State<UVSensorPage> {
  final DeviceTempState _state = getIt.get<DeviceTempState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    super.dispose();
    getIt.get<MqttHelper>().sensor = null;
  }

  Future<void> _onRefresh() async {
    await _state.getDeviceState(widget.sensor, onResult);
  }

  void onResult(dynamic data, ResultState resultState) {
    switch (resultState) {
      case ResultState.successful:
        if (data is DevicePageModel) {
          _refreshController.refreshCompleted();
        }
        break;
      case ResultState.error:
        if (data is DevicePageModel) {
          _refreshController.refreshFailed();
        } else {
          Dialogs.showSimpleDialog('Error', data, _keyLoader.currentContext);
        }
        break;
      case ResultState.loading:
        // do nothing
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    getIt.get<MqttHelper>().sensor = widget.sensor;
    return Scaffold(
      key: _keyLoader,
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _onRefresh,
        child: Column(
          children: <Widget>[
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    RoundButton(
                      icon: Icon(MdiIcons.chevronLeft, color: Colors.black),
                      padding: const EdgeInsets.all(8),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.sensor.name,
                          style: const TextStyle(fontSize: 18),
                        ),
                        StreamBuilder<DevicePageModel>(
                            stream: _state.dataStream$,
                            builder: (BuildContext context,
                                AsyncSnapshot<DevicePageModel> snapshot) {
                              return NetworkStatusLabel(
                                online: _state.device.networkStatus ?? false,
                              );
                            }),
                      ],
                    ),
                    const Spacer(),
                    RoundButton(
                      icon: Icon(
                        MdiIcons.informationOutline,
                        color: Colors.black,
                        size: 16,
                      ),
                      padding: const EdgeInsets.all(12),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<DeviceInfo>(
                          builder: (BuildContext context) => DeviceInfo(
                            sensor: widget.sensor,
                            state: _state,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RoundButton(
                      icon: Icon(
                        MdiIcons.pencil,
                        color: Colors.black,
                        size: 16,
                      ),
                      padding: const EdgeInsets.all(12),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder<DevicePageModel>(
                future: _state.getDeviceState(widget.sensor, onResult),
                builder: (BuildContext context,
                    AsyncSnapshot<DevicePageModel> snapshot) {
                  return Flexible(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.only(left: 16, top: 16),
                              height: Utils.getPercentValueFromScreenHeight(
                                  100, context),
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                      begin: const Alignment(0, -1.5),
                                      end: const Alignment(0, 1),
                                      colors: <Color>[
                                        Colors.transparent,
                                        ColorsTheme.background,
                                      ],
                                      stops: const <double>[
                                        0,
                                        0.02
                                      ]).createShader(bounds);
                                },
                                blendMode: BlendMode.dstIn,
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      begin: const Alignment(0, -1),
                                      end: const Alignment(0, 1),
                                      colors: <Color>[
                                        ColorsTheme.background,
                                        Colors.transparent,
                                      ],
                                      stops: const <double>[
                                        0.82,
                                        1,
                                      ],
                                    ).createShader(bounds);
                                  },
                                  blendMode: BlendMode.dstIn,
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 25,
                                          bottom: 60,
                                          right: (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.5 -
                                                  10) /
                                              2),
                                      child: StreamBuilder<DevicePageModel>(
                                          stream: _state.dataStream$,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DevicePageModel>
                                                  snapshot) {
                                            final bool isNotNull =
                                                _state.device.data != null;
                                            return Column(
                                              children: <Widget>[
                                                UVIndexCard(
                                                  uvLevel: UVIndex.low,
                                                  selected: isNotNull &&
                                                      int.parse(_state.device
                                                              .data['UVIndex']
                                                              .toString()) >=
                                                          0 &&
                                                      int.parse(_state.device
                                                              .data['UVIndex']
                                                              .toString()) <=
                                                          2,
                                                ),
                                                UVIndexCard(
                                                  uvLevel: UVIndex.medium,
                                                  selected: isNotNull &&
                                                      int.parse(_state.device
                                                              .data['UVIndex']
                                                              .toString()) >=
                                                          3 &&
                                                      int.parse(_state.device
                                                              .data['UVIndex']
                                                              .toString()) <=
                                                          5,
                                                ),
                                                UVIndexCard(
                                                  uvLevel: UVIndex.high,
                                                  selected: isNotNull &&
                                                      int.parse(_state.device
                                                              .data['UVIndex']
                                                              .toString()) >=
                                                          6 &&
                                                      int.parse(_state.device
                                                              .data['UVIndex']
                                                              .toString()) <=
                                                          7,
                                                ),
                                                UVIndexCard(
                                                  uvLevel: UVIndex.veryHigh,
                                                  selected: isNotNull &&
                                                      int.parse(_state.device
                                                              .data['UVIndex']
                                                              .toString()) >=
                                                          8 &&
                                                      int.parse(_state.device
                                                              .data['UVIndex']
                                                              .toString()) <=
                                                          10,
                                                ),
                                                UVIndexCard(
                                                  uvLevel: UVIndex.extreme,
                                                  selected: isNotNull &&
                                                      int.parse(_state.device
                                                              .data['UVIndex']
                                                              .toString()) >=
                                                          11,
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const Alignment(0.8, -0.85),
                            child: Container(
                              padding: const EdgeInsets.only(right: 16),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  StreamBuilder<DevicePageModel>(
                                      stream: _state.dataStream$,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DevicePageModel>
                                              snapshot) {
                                        return Text(
                                          '${_state.device.data == null ? -1 : _state.device.data['UVIndex'] ?? -1}',
                                          textScaleFactor: 8,
                                          style: GoogleFonts.getFont(
                                            'Montserrat',
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: ColorsTheme.textColor,
                                            ),
                                          ),
                                        );
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 24.0),
                                    child: Text(
                                      'UV',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textScaleFactor: 0.8,
                                      style: GoogleFonts.getFont(
                                        'Montserrat',
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color:  ColorsTheme.textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          StreamBuilder<DevicePageModel>(
                              stream: _state.dataStream$,
                              builder: (BuildContext context,
                                  AsyncSnapshot<DevicePageModel> snapshot) {
                                final bool isNotNull =
                                    _state.device.data != null;
                                UVIndex uvIndex = UVIndex.low;
                                if (isNotNull) {
                                  if (int.parse(_state.device.data['UVIndex']
                                              .toString()) >=
                                          0 &&
                                      int.parse(_state.device.data['UVIndex']
                                              .toString()) <=
                                          2) {
                                    uvIndex = UVIndex.low;
                                  } else if (int.parse(_state
                                              .device.data['UVIndex']
                                              .toString()) >=
                                          3 &&
                                      int.parse(_state.device.data['UVIndex']
                                              .toString()) <=
                                          5) {
                                    uvIndex = UVIndex.medium;
                                  } else if (int.parse(_state
                                              .device.data['UVIndex']
                                              .toString()) >=
                                          6 &&
                                      int.parse(_state.device.data['UVIndex']
                                              .toString()) <=
                                          7) {
                                    uvIndex = UVIndex.high;
                                  } else if (int.parse(_state
                                              .device.data['UVIndex']
                                              .toString()) >=
                                          8 &&
                                      int.parse(_state.device.data['UVIndex']
                                              .toString()) <=
                                          10) {
                                    uvIndex = UVIndex.veryHigh;
                                  } else if (int.parse(_state
                                          .device.data['UVIndex']
                                          .toString()) >=
                                      11) {
                                    uvIndex = UVIndex.extreme;
                                  }
                                }
                                return Align(
                                  alignment: const Alignment(0.8, 0.75),
                                  child: Container(
                                    width: Utils.getPercentValueFromScreenWidth(
                                        50, context),
                                    child: Text(
                                      DataTypes.uvLevelsText[uvIndex.index]
                                          ['details'],
                                      textScaleFactor: 1.3,
                                      style: GoogleFonts.getFont(
                                        'Montserrat',
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w100,
                                          color: ColorsTheme.textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}


