import 'dart:developer';

import 'package:Homey/data/devices_states/devices_temp_state.dart';
import 'package:Homey/data/models/devices_models/device_temp_model.dart';
import 'package:Homey/data/on_result_callback.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/network_status.dart';
import 'package:Homey/helpers/mqtt.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/main.dart';
import 'package:Homey/screens/devices_pages/device_info.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TempDevicePage extends StatefulWidget {
  const TempDevicePage({@required this.sensor}) : super();

  final SensorModel sensor;

  @override
  _TempDevicePageState createState() => _TempDevicePageState();
}

class _TempDevicePageState extends State<TempDevicePage> {
  final DeviceTempState _state = getIt.get<DeviceTempState>();

  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Mqtt mqttClient;
  @override
  void dispose() {
    super.dispose();
    mqttClient.disconnect();
  }
  Future<void> _onRefresh() async {
    await _state.getDeviceState(widget.sensor, onResult);
  }

  void onResult(dynamic data, ResultState resultState) {
    switch (resultState) {
      case ResultState.successful:
        if (data is DeviceTempModel) {
          _refreshController.refreshCompleted();
        }
        break;
      case ResultState.error:
        if (data is DeviceTempModel) {
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
    mqttClient = Mqtt(widget.sensor)
      ..connect();
    return Scaffold(
      key: _keyLoader,
      appBar: AppBar(
        title: Text(widget.sensor.name),
        actions: <Widget>[
          RawMaterialButton(
            shape: const CircleBorder(),
            elevation: 0.0,
            onPressed: () => Navigator.push(context, MaterialPageRoute<DeviceInfo>(builder: (BuildContext context) => DeviceInfo(sensor: widget.sensor, state: _state,))),

            child: const Icon(
              MdiIcons.informationOutline,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _onRefresh,
        child: FutureBuilder<DeviceTempModel>(
          future: _state.getDeviceState(widget.sensor, onResult),
          builder:
              (BuildContext context, AsyncSnapshot<DeviceTempModel> snapshot) {
            if (snapshot.hasError) {
              log('error', error: snapshot.error);
            }
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.none) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return Container(
                  child: StreamBuilder<DeviceTempModel>(
                      stream: _state.dataStream$,
                      builder: (BuildContext context,
                          AsyncSnapshot<DeviceTempModel> snapshot) {
                        return Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: FractionallySizedBox(
                                widthFactor: 0.6,
                                heightFactor: 0.3,
                                child: Stack(
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: ClipOval(
                                          child: Container(
                                            color: ColorsTheme.backgroundCard,
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    _state.device
                                                        .data['temperature']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Sriracha',
                                                        fontSize: 32),
                                                  ),
                                                  const SizedBox(
                                                    width: 1,
                                                  ),
                                                  Icon(
                                                    MdiIcons.temperatureCelsius,
                                                    size: 32,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: const Alignment(1, -1.3),
                                      child: FractionallySizedBox(
                                        widthFactor: 0.4,
                                        heightFactor: 0.4,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: ClipOval(
                                              child: Container(
                                                color: ColorsTheme.primary,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        _state.device
                                                            .data['humidity']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Sriracha',
                                                            fontSize: 18),
                                                      ),
                                                      const SizedBox(
                                                        width: 1,
                                                      ),
                                                      Icon(
                                                        MdiIcons.water,
                                                        size: 18,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(0, 0.42),
                              child: NetworkStatusLabel(online: _state.device.networkStatus)
                            ),
                          ],
                        );
                      }),
                );
              } else {
                return const Center(
                  child: Text(
                    'Cannnot retrieve device status',
                    textAlign: TextAlign.center,
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
