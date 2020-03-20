import 'dart:async';
import 'dart:developer';

import 'package:Homey/data/devices_states/add_device_state.dart';
import 'package:Homey/data/add_house_state.dart';
import 'package:Homey/data/add_room_state.dart';
import 'package:Homey/data/devices_states/devices_switch_state.dart';
import 'package:Homey/data/devices_states/devices_temp_state.dart';
import 'package:Homey/data/menu_state.dart';
import 'package:Homey/data/login_state.dart';
import 'package:Homey/data/devices_states/network_status_state.dart';
import 'package:Homey/data/register_state.dart';
import 'package:Homey/data/room_edit_state.dart';
import 'package:flutter/material.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/screens/login/login.dart';
import 'package:Homey/screens/home/menu.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:get_it/get_it.dart';

import 'app_data_manager.dart';
import 'helpers/sql_helper/sql_helper.dart';
import 'helpers/utils.dart';

final GetIt getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
  getIt.registerSingleton<NetworkStatusState>(NetworkStatusState(), signalsReady: true);
  // ignore: cascade_invocations
  getIt.registerSingleton<DeviceSwitchState>(DeviceSwitchState(), signalsReady: true);
  // ignore: cascade_invocations
  getIt.registerSingleton<DeviceTempState>(DeviceTempState(), signalsReady: true);
  // ignore: cascade_invocations
  getIt.registerSingleton<RoomEditState>(RoomEditState(), signalsReady: true);


  FlareCache.doesPrune = false;
//  SqlHelper().initDatabase();
  warmUpFlare().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homey',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: ColorsTheme.background,
        ),
        accentColor: ColorsTheme.accent,
        primaryColor: ColorsTheme.primary,
        buttonColor: ColorsTheme.primary,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ColorsTheme.background,
        dialogBackgroundColor: ColorsTheme.backgroundCard,
        cardTheme: CardTheme(
          elevation: 20,
          color: ColorsTheme.backgroundCard
        ),
      ),
      home: Scaffold(
        body: FutureBuilder<dynamic>(
          future: Future.wait<dynamic>(<Future<dynamic>>[
            SqlHelper().initDatabase(),
//            Future<dynamic>.delayed(const Duration(seconds: 2)),
          ]).then<dynamic>((List<dynamic> data) async {
            return AppDataManager().fetchData();
          }),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            log('snapshot data', error: snapshot);
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.none) {
              return Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/Logo.png',
                        height: 60,
                      ),
//                        const SizedBox(height: 10,),
                      const Text(
                        'Homey',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Sriracha',
                          fontSize: 35,
                        ),
                      ),
                      const CircularProgressIndicator()
                    ],
                  ),
                ),
              );
            } else {
              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                return Menu();
              } else {
                return Login();
              }
            }
          },
        ),
      ),
    );
  }
}
