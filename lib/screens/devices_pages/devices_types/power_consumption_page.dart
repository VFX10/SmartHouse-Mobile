import 'package:Homey/design/colors.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/buttons/round_button.dart';
import 'package:Homey/design/widgets/buttons/selectable_button.dart';
import 'package:Homey/design/widgets/network_status.dart';
import 'package:Homey/helpers/mqtt.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:Homey/helpers/states_manager.dart';
import 'package:Homey/models/devices_models/device_page_model.dart';
import 'package:Homey/screens/devices_pages/device_info.dart';
import 'package:Homey/states/devices_states/power_consumption_state.dart';
import 'package:Homey/states/on_result_callback.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fl_chart/fl_chart.dart';

class PowerConsumptionDevicePage extends StatefulWidget {
  const PowerConsumptionDevicePage({@required this.sensor}) : super();

  final SensorModel sensor;

  @override
  _PowerConsumptionDevicePageState createState() =>
      _PowerConsumptionDevicePageState();
}

class _PowerConsumptionDevicePageState
    extends State<PowerConsumptionDevicePage> {
  final PowerConsumptionState _state = getIt.get<PowerConsumptionState>();

  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    super.dispose();
    getIt.get<MqttHelper>().sensor = null;
  }

  Future<void> _onRefresh() async {
    await _state.getWeeklyPowerConsumptionGraph(widget.sensor, onResult);
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

//  List<Color> gradientColors = [
//    const Color(0xff23b6e6),
//    const Color(0xff02d39a),
//  ];
  int chartType = 1;

  @override
  Widget build(BuildContext context) {
    getIt.get<MqttHelper>().sensor = widget.sensor;

    _state.getDeviceState(widget.sensor, onResult);
    return Scaffold(
      key: _keyLoader,
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _onRefresh,
        child: Stack(
          children: <Widget>[
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
                              stream: _state.sensorStream$,
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: Utils.getPercentValueFromScreenWidth(100, context),
                color: ColorsTheme.backgroundDarker,
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: StreamBuilder<LineChartData>(
                      stream: _state.dataStream$,
                      builder: (BuildContext context,
                          AsyncSnapshot<LineChartData> snapshot) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            StreamBuilder<ChartTypes>(
                                stream: _state.chartTypeStream$,
                                builder: (BuildContext context,
                                    AsyncSnapshot<ChartTypes> snapshot) {
                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SelectableButton(
                                          text: 'Weekly',
                                          selected: _state.chartType ==
                                              ChartTypes.weekly,
                                          onPressed: () {
                                            if (_state.chartType !=
                                                ChartTypes.weekly) {
                                              _state
                                                  .getWeeklyPowerConsumptionGraph(
                                                      widget.sensor, onResult);
                                            }
                                          },
                                        ),
                                        SelectableButton(
                                          text: 'Monthly',
                                          selected: _state.chartType ==
                                              ChartTypes.monthly,
                                          onPressed: () {
                                            if (_state.chartType !=
                                                ChartTypes.monthly) {
                                              _state
                                                  .getMonthlyPowerConsumptionGraph(
                                                      widget.sensor, onResult);
                                            }
                                          },
                                        ),
                                        SelectableButton(
                                          text: 'Yearly',
                                          selected: _state.chartType ==
                                              ChartTypes.yearly,
                                          onPressed: () {
                                            if (_state.chartType !=
                                                ChartTypes.yearly) {
                                              _state
                                                  .getYearlyPowerConsumptionGraph(
                                                      widget.sensor, onResult);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            LineChart(
                              _state.data,
                              swapAnimationDuration:
                                  const Duration(milliseconds: 500),
                            ),
                          ],
                        );
                      }),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.5),
              child: Container(
//                width: Utils.getPercentValueFromScreenWidth(40, context),
//                height: Utils.getPercentValueFromScreenWidth(40, context),
//                decoration: BoxDecoration(
//                    color: ColorsTheme.backgroundDarker,
//                    shape: BoxShape.circle,
//                    border: Border.all(color: ColorsTheme.accent, width: 3)),
//                child: const Center(
//                  child: Text('28 W/h', style: TextStyle(fontSize: 18, color: ColorsTheme.accent, fontWeight: FontWeight.bold),),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    StreamBuilder<DevicePageModel>(
                      stream: _state.sensorStream$,
                      builder: (BuildContext context, AsyncSnapshot<DevicePageModel> snapshot) {
                        return Text(
                          _state.device.data['power'].toString(),
                          style: TextStyle(
                              fontSize:
                                  Utils.getPercentValueFromScreenWidth(25, context),
                              color: ColorsTheme.accent,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w100),
                        );
                      }
                    ),
                    Text(
                      'Wh',
                      style: TextStyle(
                          fontSize:
                              Utils.getPercentValueFromScreenWidth(10, context),
                          color: ColorsTheme.accent,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
