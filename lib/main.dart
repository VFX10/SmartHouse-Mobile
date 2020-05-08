import 'dart:async';

import 'package:Homey/helpers/firebase.dart';
import 'package:Homey/helpers/states_manager.dart';

import 'package:flutter/material.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/screens/login.dart';
import 'package:Homey/screens/menu/menu.dart';
import 'package:flare_flutter/flare_cache.dart';

import 'app_data_manager.dart';
import 'helpers/sql_helper/sql_helper.dart';
import 'helpers/utils.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initStatesManager();

  FlareCache.doesPrune = false;
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
        textTheme: const TextTheme(body1: TextStyle()).apply(
          bodyColor: ColorsTheme.textColor,
        ),
        iconTheme: const IconThemeData(
          color: ColorsTheme.textColor,
        ),
        scaffoldBackgroundColor: ColorsTheme.background,
        dialogBackgroundColor: ColorsTheme.backgroundCard,
        cardTheme: CardTheme(elevation: 20, color: ColorsTheme.backgroundCard),
      ),
      home: Scaffold(
        body: FutureBuilder<dynamic>(
          future: Future.wait<dynamic>(<Future<dynamic>>[
            SqlHelper().initDatabase(),
//            Future<dynamic>.delayed(const Duration(seconds: 2)),
          ]).then<dynamic>((List<dynamic> data) async {
            final String data = await AppDataManager().fetchData();
            getIt.get<FirebaseHelper>().initFirebase();
            return data;
          }),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
