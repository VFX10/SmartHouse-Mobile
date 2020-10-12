import 'package:Homey/helpers/data_types.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/helpers/sql_helper/sql_helper.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:Homey/models/devices_models/device_page_model.dart';
import 'package:Homey/states/on_result_callback.dart';
import 'package:rxdart/rxdart.dart';

class DeviceTempState {
  final BehaviorSubject<DevicePageModel> _data =
      BehaviorSubject<DevicePageModel>.seeded(DevicePageModel(data: <String, dynamic>{'UVIndex': 0}));
  final BehaviorSubject<double> _animationValue =
      BehaviorSubject<double>.seeded(0.0);

  Stream<DevicePageModel> get dataStream$ => _data.stream;
  Stream<double> get animationValueStream$ => _animationValue.stream;


  DevicePageModel get device => _data.value;

  set device(DevicePageModel state) {
    _data.value = state;
  }

  double get animationValue => _animationValue.value;

  set animationValue(double state) {
    _animationValue.value = state;
  }

  Future<DevicePageModel> getDeviceState(
      SensorModel sensor, OnResult onResult) async {
    onResult('Loading', ResultState.loading);
    await WebRequestsHelpers.get(
      route: '/api/getSensorLastStatus?macAddress=${sensor.macAddress}',
    ).then((dynamic response) async {
      final dynamic res = response.json();
      if (res['data'] != null) {
        _data.value = DevicePageModel(
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
    return _data.value;
  }

  Future<void> rebootDevice(SensorModel sensor, OnResult onResult) async {
    final Map<String, dynamic> body = <String, String>{
      'macAddress': sensor.macAddress,
      'event': 'reboot'
    };
    await WebRequestsHelpers.post(
            route: '/api/sendEventToSensor', body: body, displayResponse: true)
        .then((dynamic response) async {
      final dynamic data = response.json();
      if (data['success'] != null) {
        onResult('Device will reboot now!', ResultState.successful);
      } else {
        onResult('Error sending event to device', ResultState.error);
      }
    }, onError: (Object e) {
      onResult('Error sending event to device', ResultState.error);
    });
  }
  Future<void> changeStateOn(SensorModel sensor, OnResult onResult) async {
    if(sensor.sensorType == DevicesType.switchDevice) {
      final Map<String, dynamic> body = <String, String>{
        'macAddress': sensor.macAddress,
        'event': _data.value.data['status'] == 0 ? 'on' : 'off'
      };
      await WebRequestsHelpers.post(
          route: '/api/sendEventToSensor', body: body, displayResponse: true)
          .then((dynamic response) async {
        final dynamic data = response.json();
        if (data['success'] != null) {
//        await Future<dynamic>.delayed(const Duration(seconds: 2));
//        await getDeviceState(sensor,onResult);
        } else {
          onResult('Error sending event to device', ResultState.error);
        }
      }, onError: (Object e) {
        onResult('Error sending event to device', ResultState.error);
      });
    }
  }
  void dispose() {
    _data.close();
    _animationValue.close();
  }
}
