import 'dart:async';
import 'dart:convert';

import 'package:Homey/AppDataManager.dart';
import 'package:Homey/screens/home/homePageState.dart';
import 'package:flutter/material.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/screens/login/login.dart';
import 'package:Homey/screens/home/home.dart';
import 'package:smartconfig/smartconfig.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'helpers/utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Don't prune the Flare cache, keep loaded Flare files warm and ready
  // to be re-displayed.
  FlareCache.doesPrune = false;
  warmupFlare().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Future.wait([AppDataManager().fetchData()]).then((_) {
        return AppDataManager().token;
      }),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => HomePageState()),
            ],
            child: MaterialApp(
              title: 'Homey',
              theme: ThemeData(
                accentColor: ColorsTheme.accent,
                primaryColor: ColorsTheme.primary,
                buttonColor: ColorsTheme.primary,
                brightness: Brightness.dark,
                scaffoldBackgroundColor: ColorsTheme.background,
                dialogBackgroundColor: ColorsTheme.backgroundDarker,
              ),
              home: Scaffold(
                body: Home(),
              ),
            ),
          );
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => HomePageState()),
            ],
            child: MaterialApp(
              title: 'Homey',
              theme: ThemeData(
                accentColor: ColorsTheme.accent,
                primaryColor: ColorsTheme.primary,
                buttonColor: ColorsTheme.primary,
                brightness: Brightness.dark,
                scaffoldBackgroundColor: ColorsTheme.background,
                dialogBackgroundColor: ColorsTheme.backgroundDarker,
              ),
              home: Scaffold(
                body: Login(),
              ),
            ),
          );
        }
      },
    );
  }
}

