import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Homey/screens/home/home_page_state.dart';
import 'package:flutter/material.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/screens/login/login.dart';
import 'package:Homey/screens/home/home.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:provider/provider.dart';

import 'app_data_manager.dart';
import 'helpers/sql_helper/sql_helper.dart';
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
    return MultiProvider(
      providers: <ChangeNotifierProvider<dynamic>>[
        ChangeNotifierProvider<HomePageState>(create: (_) => HomePageState()),
      ],
      child: MaterialApp(
        title: 'Homey',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            elevation: 0,
            color: ColorsTheme.background,
          ),
          accentColor: ColorsTheme.accent,
          primaryColor: ColorsTheme.primary,
          buttonColor: ColorsTheme.primary,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: ColorsTheme.background,
          dialogBackgroundColor: ColorsTheme.backgroundDarker,
        ),
        home: Scaffold(
          body: FutureBuilder<String>(
            future: Future.wait(<Future<dynamic>>[SqlHelper().initDatabase()])
                .then((_) {
              return AppDataManager().token;
            }),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              log('fsfs', error: snapshot);
              if (snapshot.hasData && snapshot.data.isNotEmpty) {
                return Home();
              } else {
                return Login();
              }
            },
          ),
        ),
      ),
    );
  }
}
