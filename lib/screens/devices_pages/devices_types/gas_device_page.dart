import 'dart:developer';

import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/buttons/round_button.dart';
import 'package:Homey/design/widgets/network_status.dart';
import 'package:Homey/helpers/mqtt.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:Homey/helpers/states_manager.dart';
import 'package:Homey/models/devices_models/device_page_model.dart';
import 'package:Homey/screens/devices_pages/device_info.dart';
import 'package:Homey/states/devices_states/devices_temp_state.dart';
import 'package:Homey/states/on_result_callback.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GasDevicePage extends StatefulWidget {
  const GasDevicePage({@required this.sensor}) : super();

  final SensorModel sensor;

  @override
  _GasDevicePageState createState() => _GasDevicePageState();
}

class _GasDevicePageState extends State<GasDevicePage>
    with SingleTickerProviderStateMixin {
  final DeviceTempState _state = getIt.get<DeviceTempState>();

  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _controller.dispose();
    getIt.get<MqttHelper>().sensor = null;
    super.dispose();
  }

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addStatusListener((_) {
        if (_animation.isCompleted) {
          _controller.reverse();
        } else if (_animation.isDismissed) {
          _controller.forward();
        }
      })
      ..addListener(() {
        _state.animationValue = _animation.value;
      });
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
        child: Stack(
          children: <Widget>[
            StreamBuilder<DevicePageModel>(
                stream: _state.dataStream$,
                builder: (BuildContext context,
                    AsyncSnapshot<DevicePageModel> snapshot) {
                  return Positioned.fill(
                    child: Container(
                      height:
                          Utils.getPercentValueFromScreenHeight(100, context),
                      child: AnimatedCrossFade(
                        duration: const Duration(seconds: 1),
                        firstChild: Container(
                          height: Utils.getPercentValueFromScreenHeight(
                              100, context),
                          child: Image.asset(
                            'assets/images/smoke_detector.jpg',
                            fit: BoxFit.cover,
                            color: Colors.black.withOpacity(0.3),
                            colorBlendMode: BlendMode.multiply,
                          ),
                        ),
                        secondChild: Container(
                          height: Utils.getPercentValueFromScreenHeight(
                              100, context),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.grey,
                              BlendMode.saturation,
                            ),
                            child: Image.asset(
                              'assets/images/smoke_detector.jpg',
                              fit: BoxFit.cover,
                              color: Colors.black.withOpacity(0.8),
                              colorBlendMode: BlendMode.multiply,
                            ),
                          ),
                        ),
                        crossFadeState: _state.device.networkStatus != null &&
                                _state.device.networkStatus
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ),
                  );
                }),
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
                                    ))),
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
            ),
            FutureBuilder<DevicePageModel>(
              future: _state.getDeviceState(widget.sensor, onResult),
              builder: (BuildContext context,
                  AsyncSnapshot<DevicePageModel> snapshot) {
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
                      child: StreamBuilder<DevicePageModel>(
                          stream: _state.dataStream$,
                          builder: (BuildContext context,
                              AsyncSnapshot<DevicePageModel> snapshot) {
                            if (_state.device.data != null && _state.device.data['warning'] != null && _state.device.data['warning'] == true) {
                              _controller.forward();
                            }
                            return Stack(
                              children: <Widget>[
                                if (_state.device.data != null && _state.device.data['warning'] != null && _state.device.data['warning'] == true)
                                  StreamBuilder<double>(
                                      stream: _state.animationValueStream$,
                                      builder: (BuildContext context, _) {
                                        return Align(
                                          alignment: const Alignment(0, 0.5),
                                          child: Opacity(
                                            opacity: _animation.value,
                                            child: Icon(
                                              MdiIcons.alertOutline,
                                              size: Utils
                                                  .getPercentValueFromScreenHeight(
                                                      10, context),
                                              color: Colors.red,
                                            ),
                                          ),

//                                    TweenAnimationBuilder(
//                                      duration: const Duration(milliseconds: 500),
//                                      tween: ColorTween(begin: Colors.transparent, end: Colors.red),
//                                      builder: (_, Color color, ___){
//                                        return ColorFiltered(
//                                          child: Icon(MdiIcons.alertOutline, size: Utils.getPercentValueFromScreenHeight(10, context)),
//                                          colorFilter: ColorFilter.mode(color, BlendMode.modulate),
//                                        );
//                                      },
//                                    )
                                        );
                                      }),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 32),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            const Text(
                                              'Smoke:',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontFamily: 'Montserrat',
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${_state.device.data != null && _state.device.data['methane'] != null ? _state.device.data['methane'] : 0} ppm' ??
                                                  'NaN',
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontFamily: 'Montserrat',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            const Text(
                                              'Methane:',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontFamily: 'Montserrat',
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${_state.device.data != null && _state.device.data['methane'] != null ? _state.device.data['methane'] : 0} ppm' ??
                                                  'NaN',
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontFamily: 'Montserrat',
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
//                                Align(
//                                  alignment: Alignment(0.9, 1),
//                                  child: FractionallySizedBox(
//                                    widthFactor: 0.3,
//                                    heightFactor: 0.3,
//                                    child: Stack(
//                                      overflow: Overflow.visible,
//                                      children: <Widget>[
//                                        Align(
//                                          alignment: Alignment.center,
//                                          child: AspectRatio(
//                                            aspectRatio: 1 / 1,
//                                            child: ClipOval(
//                                              child: Container(
//                                                color: ColorsTheme
//                                                    .backgroundDarker
//                                                    .withOpacity(0.7),
//                                                child: Center(
//                                                  child: Row(
//                                                    mainAxisAlignment:
//                                                        MainAxisAlignment
//                                                            .center,
//                                                    children: <Widget>[
//                                                      Text(
//                                                        '${_state.device.data['smoke']} %' ??
//                                                            'NaN',
//                                                        style: const TextStyle(
//                                                            fontWeight:
//                                                                FontWeight.bold,
//                                                            fontFamily:
//                                                                'Sriracha',
//                                                            fontSize: 18),
//                                                      ),
//                                                    ],
//                                                  ),
//                                                ),
//                                              ),
//                                            ),
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                ),
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
          ],
        ),
      ),
    );
  }
}
