import 'package:Homey/helpers/firebase.dart';
import 'package:Homey/helpers/mqtt.dart';
import 'package:Homey/states/add_house_state.dart';
import 'package:Homey/states/add_room_state.dart';
import 'package:Homey/states/devices_states/add_device_state.dart';
import 'package:Homey/states/devices_states/device_selector_state.dart';
import 'package:Homey/states/devices_states/devices_temp_state.dart';
import 'package:Homey/states/devices_states/network_status_state.dart';
import 'package:Homey/states/devices_states/power_consumption_state.dart';
import 'package:Homey/states/login_state.dart';
import 'package:Homey/states/menu_state.dart';
import 'package:Homey/states/register_state.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void initStatesManager() {
  getIt.registerSingleton<LoginState>(LoginState(), signalsReady: true);
  // ignore: cascade_invocations
  getIt.registerSingleton<RegisterState>(RegisterState(), signalsReady: true);
  // ignore: cascade_invocations
  getIt.registerSingleton<MenuState>(MenuState(), signalsReady: true);
  // ignore: cascade_invocations
  getIt.registerSingleton<AddHouseState>(AddHouseState(), signalsReady: true);
  // ignore: cascade_invocations
  getIt.registerSingleton<AddRoomState>(AddRoomState(), signalsReady: true);
  // ignore: cascade_invocations
  getIt.registerSingleton<AddDeviceState>(AddDeviceState(), signalsReady: true);
  // ignore: cascade_invocations
  getIt.registerSingleton<NetworkStatusState>(NetworkStatusState(),
      signalsReady: true);
  // ignore: cascade_invocations
  getIt.registerSingleton<DeviceTempState>(DeviceTempState(),
      signalsReady: true);
  // ignore: cascade_invocations
  getIt.registerSingleton<DeviceSelectorState>(DeviceSelectorState(),
      signalsReady: true);
  // ignore: cascade_invocations
  getIt.registerSingleton<PowerConsumptionState>(PowerConsumptionState(),
      signalsReady: true);
  // ignore: cascade_invocations
  getIt.registerSingleton<FirebaseHelper>(FirebaseHelper(), signalsReady: true);
  // ignore: cascade_invocations
  getIt.registerSingleton<MqttHelper>(MqttHelper(), signalsReady: true);
}
