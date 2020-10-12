import 'dart:developer';

import 'package:Homey/design/colors.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/helpers/sql_helper/sql_helper.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:Homey/models/devices_models/device_page_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:Homey/states/on_result_callback.dart';

enum ChartTypes { weekly, monthly, yearly }

class PowerConsumptionState {
  static final LineChartData emptyWeekChart = LineChartData(
    gridData: FlGridData(
      show: false,
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 50,
        textStyle: const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16),
        getTitles: (double value) {
          if (value < 7) {
            return dateTimeSymbolMap()[Intl.systemLocale]
                .SHORTWEEKDAYS[value.toInt()];
          }
          return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: false,
      ),
    ),
    borderData: FlBorderData(show: false),
    minX: 0,
    maxX: 6,
    minY: 0,
    maxY: 20,
    lineBarsData: <LineChartBarData>[
      LineChartBarData(
        spots: <FlSpot>[
          FlSpot(0, 0),
          FlSpot(1, 0),
          FlSpot(2, 0),
          FlSpot(3, 0),
          FlSpot(4, 0),
          FlSpot(5, 0),
          FlSpot(6, 0),
        ],
        isCurved: true,
        colors: <Color>[ColorsTheme.accent],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          strokeWidth: 2,
        ),
      ),
    ],
  );
  static final LineChartData emptyMonthChart = LineChartData(
    gridData: FlGridData(
      show: false,
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 50,
        textStyle: const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16),
        getTitles: (double value) {
          if (value < 12) {
            return dateTimeSymbolMap()[Intl.systemLocale]
                .SHORTMONTHS[value.toInt()];
          }
          return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: false,
      ),
    ),
    borderData: FlBorderData(show: false),
    minX: 0,
    maxX: 11,
    minY: 0,
    maxY: 20,
    lineBarsData: <LineChartBarData>[
      LineChartBarData(
        spots: <FlSpot>[
          FlSpot(0, 0),
          FlSpot(1, 0),
          FlSpot(2, 0),
          FlSpot(3, 0),
          FlSpot(4, 0),
          FlSpot(5, 0),
          FlSpot(6, 0),
          FlSpot(7, 0),
          FlSpot(8, 0),
          FlSpot(9, 0),
          FlSpot(10, 0),
          FlSpot(11, 0),
        ],
        isCurved: true,
        colors: <Color>[ColorsTheme.accent],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          strokeWidth: 2,
        ),
      ),
    ],
  );
  static final LineChartData emptyYearChart = LineChartData(
    gridData: FlGridData(
      show: false,
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 50,
        textStyle: const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16),
        getTitles: (double value) {
          return DateTime.now().subtract(const Duration(days: 5 * 365))
              .add(Duration(days: value.toInt() * 365))
              .year
              .toString();
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: false,
      ),
    ),
    borderData: FlBorderData(show: false),
    minX: 0,
    maxX: 5,
    minY: 0,
    maxY: 20,
    lineBarsData: <LineChartBarData>[
      LineChartBarData(
        spots: <FlSpot>[
          FlSpot(0, 0),
          FlSpot(1, 0),
          FlSpot(2, 0),
          FlSpot(3, 0),
          FlSpot(4, 0),
          FlSpot(5, 0),
        ],
        isCurved: true,
        colors: <Color>[ColorsTheme.accent],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          strokeWidth: 2,
        ),
      ),
    ],
  );
  final BehaviorSubject<LineChartData> _data =
      BehaviorSubject<LineChartData>.seeded(emptyWeekChart);
  final BehaviorSubject<ChartTypes> _chartType =
      BehaviorSubject<ChartTypes>.seeded(ChartTypes.weekly);

  Stream<LineChartData> get dataStream$ => _data.stream;

  Stream<ChartTypes> get chartTypeStream$ => _chartType.stream;

  LineChartData get data => _data.value;

  ChartTypes get chartType => _chartType.value;
  final BehaviorSubject<DevicePageModel> _sensor =
      BehaviorSubject<DevicePageModel>.seeded(
          DevicePageModel(data: <String, dynamic>{'power': 0}));

  Stream<DevicePageModel> get sensorStream$ => _sensor.stream;

  DevicePageModel get device => _sensor.value;

  set device(DevicePageModel state) {
    _sensor.value = state;
  }

  final BehaviorSubject<String> _currentValue =
      BehaviorSubject<String>.seeded('0');

  Stream<String> get currentValueStream$ => _currentValue.stream;

  String get currentValue => _currentValue.value;

  set currentValue(String state) {
    _currentValue.value = state;
  }

  Future<void> getDeviceState(SensorModel sensor, OnResult onResult) async {
    await WebRequestsHelpers.get(
      route: '/api/getSensorLastStatus?macAddress=${sensor.macAddress}',
    ).then((dynamic response) async {
      final dynamic res = response.json();
      if (res['data'] != null) {
        _sensor.value = DevicePageModel(
            data: res['data'],
            name: res['name'],
            networkStatus: res['networkStatus']);
        sensor.networkStatus = res['networkStatus'];
        await SqlHelper().updateSensor(sensor);
        onResult(_data.value, ResultState.successful);
      } else {
        onResult(_data.value, ResultState.error);
      }
    }, onError: (Object e) {
      onResult(_data.value, ResultState.error);
    });
    await getWeeklyPowerConsumptionGraph(sensor, onResult);
    //return _data.value;
  }

  Future<void> getWeeklyPowerConsumptionGraph(
      SensorModel sensor, OnResult onResult) async {
    _chartType.value = ChartTypes.weekly;
    await WebRequestsHelpers.get(
      route:
          '/api/getWeeklyPowerConsumption?macAddress=${sensor.macAddress}&currentDateTime=${DateTime.now()}',
    ).then((dynamic response) async {
      final dynamic res = response.json();
      log('Get*****', error: response);
      if (res['data'] != null && res['data'].length > 0) {
        final List<FlSpot> data = <FlSpot>[];
        double maxY = double.parse(res['data'][0]['power'].toString());
        for (int i = 0; i < res['data'].length; i++) {
          log('data j: ${double.parse(res['data'][i]['dayOfWeek'].toString())} i: $i',
              error: res['data'][i]['power']);
          if (double.parse(res['data'][i]['power'].toString()) > maxY) {
            maxY = double.parse(res['data'][i]['power'].toString());
          }
          data.add(FlSpot(double.parse(res['data'][i]['dayOfWeek'].toString()),
              double.parse(res['data'][i]['power'].toString())));
        }
        log('data', error: data);
        _data.value = LineChartData(
          gridData: FlGridData(
            show: false,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              textStyle: const TextStyle(
                  color: Color(0xff68737d),
                  fontFamily: 'Montserrat',
                  fontSize: 16),
              getTitles: (double value) {
                if (value < 7) {
                  return dateTimeSymbolMap()[Intl.systemLocale]
                      .SHORTWEEKDAYS[value.toInt()];
                }
                return '';
              },
              margin: 8,
            ),
            leftTitles: SideTitles(
              showTitles: false,
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: maxY,
          lineBarsData: <LineChartBarData>[
            LineChartBarData(
              spots: data,
              isCurved: true,
              colors: <Color>[ColorsTheme.accent, ColorsTheme.accent],
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
              ),
            ),
          ],
        );

        onResult(_data.value, ResultState.successful);
      } else {
        _data.value = emptyWeekChart;
        onResult(_data.value, ResultState.error);
      }
    }, onError: (Object e) {
      onResult(_data.value, ResultState.error);
    });
//    return _data.value;
  }

  Future<void> getMonthlyPowerConsumptionGraph(
      SensorModel sensor, OnResult onResult) async {
    _chartType.value = ChartTypes.monthly;
    await WebRequestsHelpers.get(
      route:
          '/api/getMonthlyPowerConsumption?macAddress=${sensor.macAddress}&currentDateTime=${DateTime.now()}',
    ).then((dynamic response) async {
      final dynamic res = response.json();
      log('Get*****', error: response);
      if (res['data'] != null && res['data'].length > 0) {
        final List<FlSpot> data = <FlSpot>[];
        double maxY = double.parse(res['data'][0]['power'].toString());
        for (int i = 0; i < res['data'].length; i++) {
          log('data j: ${double.parse(res['data'][i]['month'].toString())} i: $i',
              error: res['data'][i]['power']);
          if (double.parse(res['data'][i]['power'].toString()) > maxY) {
            maxY = double.parse(res['data'][i]['power'].toString());
          }
          //double.parse(res['data'][i]['month'].toString())-1
          data.add(FlSpot(
              i.toDouble(), double.parse(res['data'][i]['power'].toString())));
        }
        log('data', error: data);
        _data.value = LineChartData(
          gridData: FlGridData(
            show: false,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              textStyle: const TextStyle(
                  color: Color(0xff68737d),
                  fontFamily: 'Montserrat',
                  fontSize: 16),
              getTitles: (double value) {
                if (value < data.length) {
                  return dateTimeSymbolMap()[Intl.systemLocale]
                      .SHORTMONTHS[res['data'][value.toInt()]['month'] - 1];
                }
                return '';
              },
              margin: 8,
            ),
            leftTitles: SideTitles(
              showTitles: false,
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: 0,
          maxY: maxY,
          lineBarsData: <LineChartBarData>[
            LineChartBarData(
              spots: data,
              isCurved: true,
              colors: <Color>[ColorsTheme.accent],
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
              ),
            ),
          ],
        );

        onResult(_data.value, ResultState.successful);
      } else {
        _data.value = emptyMonthChart;

        onResult(_data.value, ResultState.error);
      }
    }, onError: (Object e) {
      onResult(_data.value, ResultState.error);
    });
//    return _data.value;
  }

  Future<void> getYearlyPowerConsumptionGraph(
      SensorModel sensor, OnResult onResult) async {
    _chartType.value = ChartTypes.yearly;

    await WebRequestsHelpers.get(
      route: '/api/getYearlyPowerConsumption?macAddress=${sensor.macAddress}',
    ).then((dynamic response) async {
      final dynamic res = response.json();
      log('Get*****', error: response);
      if (res['data'] != null && res['data'].length > 0) {
        final List<FlSpot> data = <FlSpot>[];
        double maxY = double.parse(res['data'][0]['power'].toString());
        log('length', error: res['data'].length);
        for (int i = 0; i < res['data'].length; i++) {
          log('data j: ${double.parse(res['data'][i]['year'].toString())} i: $i',
              error: res['data'][i]['power']);
          if (double.parse(res['data'][i]['power'].toString()) > maxY) {
            maxY = double.parse(res['data'][i]['power'].toString());
          }
          data.add(FlSpot(
              i.toDouble(), double.parse(res['data'][i]['power'].toString())));
        }
        log('data', error: data);
        _data.value = LineChartData(
          gridData: FlGridData(
            show: false,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              textStyle: const TextStyle(
                  color: Color(0xff68737d),
                  fontFamily: 'Montserrat',
                  fontSize: 16),
              getTitles: (double value) {
                if (value < data.length) {
                  return res['data'][value.toInt()]['year'].toString();
                }
                return '';
              },
              margin: 8,
            ),
            leftTitles: SideTitles(
              showTitles: false,
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: 0,
          maxY: maxY,
          lineBarsData: <LineChartBarData>[
            LineChartBarData(
              spots: data,
              isCurved: true,
              colors: <Color>[ColorsTheme.accent],
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
              ),
            ),
          ],
        );
        onResult(_data.value, ResultState.successful);
      } else {
        _data.value = emptyYearChart;
        onResult(_data.value, ResultState.error);
      }
    }, onError: (Object e) {
      onResult(_data.value, ResultState.error);
    });
//    return _data.value;
  }

  void dispose() {
    _data.close();
    _chartType.close();
    _sensor.close();
    _currentValue.close();
  }
}
