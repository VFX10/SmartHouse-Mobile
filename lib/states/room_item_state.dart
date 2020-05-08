import 'package:Homey/helpers/sql_helper/sql_helper.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';
import 'package:Homey/states/on_result_callback.dart';
import 'package:rxdart/rxdart.dart';

class RoomItemState {
  static bool state;
  final BehaviorSubject<bool> _devicesState =
      BehaviorSubject<bool>.seeded(false);

  Stream<bool> get devicesStateStream$ => _devicesState.stream;

  bool get devicesState => _devicesState.value;

  set devicesState(bool state) {
    _devicesState.value = state;
  }

  Future<void> init(int roomId) async {
    _devicesState.value = await SqlHelper().getSwitchLastStatus(roomId);
  }

  Future<void> changeSwitchesState(bool state, int roomId,
      {OnResult onResult}) async {
    final List<String> devices =
        await SqlHelper().getRoomSensorsMacAddress(roomId);
    final Map<String, dynamic> body = <String, dynamic>{
      'devices': devices,
      'event': state ? 'on' : 'off'
    };
    await WebRequestsHelpers.post(
            route: '/api/sendEventToAllDevices',
            body: body,
            displayResponse: true)
        .then((dynamic response) async {
      final dynamic data = response.json();
      if (data['success'] != null) {
//        onResult('Device will reboot now!', ResultState.successful);
        _devicesState.value = state;
//        for (final String device in devices) {
//          await SqlHelper().updateSensorData(
//              '{status: ${state ? 1 : 0}}', device.toLowerCase());
//        }
      } else {
//        onResult('Error sending event to device', ResultState.error);
      }
    }, onError: (Object e) {
      onResult('Error sending event to device', ResultState.error);
    });
  }

  void dispose() {
    _devicesState.close();
  }
}
