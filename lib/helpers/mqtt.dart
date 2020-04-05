import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/helpers/sql_helper/sql_helper.dart';
import 'package:Homey/models/devices_models/device_switch_model.dart';
import 'package:Homey/models/devices_models/device_temp_model.dart';
import 'package:Homey/states/devices_states/devices_switch_state.dart';
import 'package:Homey/states/devices_states/devices_temp_state.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../main.dart';

class Mqtt {
  Mqtt(this.sensor);

  final SensorModel sensor;
  String broker = '192.168.0.118';
  int port = 1883;
  String username = 'matteo';
  String passwd = '1234';
  String clientIdentifier = 'android';
  MqttClient client;
  MqttConnectionState connectionState;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>
      onMessageSubscription;

  Future<void> connect() async {
    client = MqttServerClient(broker, '')
      ..port = port
      ..logging(on: true)
      ..keepAlivePeriod = 30;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier('{"name": "test@test.ro"}')
        .keepAliveFor(
            60 * 5) // Must agree with the keep alive set above or not set
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMess;

    try {
      await client.connect(username, passwd);
    } catch (e) {
      log('error', error: e);
    }

    if (client.connectionStatus.state == MqttConnectionState.connected) {
      connectionState = client.connectionStatus.state;
    } else {
      disconnect();
    }

    _subscribeToTopic('SensorsDataChannel');
    _subscribeToTopic('SensorsStatusChannel');
    onMessageSubscription = client.updates.listen(onMessageReceived);
  }

  void disconnect() {
    print('[MQTT client] _disconnect()');
    client.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    print('[MQTT client] _onDisconnected');
    connectionState = client.connectionStatus.state;
    client = null;
    onMessageSubscription.cancel();
    onMessageSubscription = null;
    print('[MQTT client] MQTT client disconnected');
  }

  void _subscribeToTopic(String topic) {
    if (connectionState == MqttConnectionState.connected) {
      client.subscribe(topic, MqttQos.exactlyOnce);
    }
  }

  void onSensorDataChanged(Map<String, dynamic> payload) {
    if (sensor.macAddress.toLowerCase() ==
        payload['macAddress'].toString().toLowerCase()) {
      switch (sensor.sensorType) {
        case 2:
          final DeviceSwitchState _state = getIt.get<DeviceSwitchState>();
          _state.device = DeviceSwitchModel(
              name: _state.device.name,
              networkStatus: _state.device.networkStatus,
              data: payload['data']);
          break;
        case 3:
          final DeviceTempState _state = getIt.get<DeviceTempState>();
          _state.device = DeviceTempModel(
              name: _state.device.name,
              networkStatus: _state.device.networkStatus,
              data: payload['data']);
          break;
      }
    }
  }

  Future<void> onSensorStatusChanged(Map<String, dynamic> payload) async  {
    if (sensor.macAddress.toLowerCase() ==
        jsonDecode(payload['client'])['name'].toString().toLowerCase()) {
      log('is ok');
      switch (sensor.sensorType) {
        case 2:
          final DeviceSwitchState _state = getIt.get<DeviceSwitchState>();
          _state.device = DeviceSwitchModel(
            name: _state.device.name,
            networkStatus: payload['status'] == 'online',
            data: _state.device.data,
          );
          break;
        case 3:
          final DeviceTempState _state = getIt.get<DeviceTempState>();
          _state.device = DeviceTempModel(
            name: _state.device.name,
            networkStatus: payload['status'] == 'online',
            data: _state.device.data,
          );
          break;
      }
      sensor.networkStatus = payload['status'] == 'online';
      await SqlHelper().updateSensor(sensor);
    }
  }

  void onMessageReceived(List<MqttReceivedMessage<MqttMessage>> event) {
    if (event.isNotEmpty) {
      final MqttPublishMessage recMess = event[0].payload;
      final String payloadString =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      log('Message received on <${event[0].topic}> topic, payload is <-- $payloadString -->');
      switch (event[0].topic) {
        case 'SensorsDataChannel':
          onSensorDataChanged(jsonDecode(payloadString));
          break;
        case 'SensorsStatusChannel':
          onSensorStatusChanged(jsonDecode(payloadString));
          break;
      }
    }
  }
}
