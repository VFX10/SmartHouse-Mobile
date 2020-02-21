import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_home_mobile/design/colors.dart';
import 'package:smart_home_mobile/screens/login/login.dart';
import 'package:smartconfig/smartconfig.dart';
import 'package:flare_flutter/flare_cache.dart';

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
    warmupFlare();

    return MaterialApp(
      title: 'Homey',
      theme: ThemeData(
        accentColor: ColorsTheme.accent,
        primaryColor: ColorsTheme.primary,
        buttonColor: ColorsTheme.primary,
        brightness: Brightness.dark,
        dialogBackgroundColor: ColorsTheme.backgroundDarker,
      ),
      home: Scaffold(
        body: Login(),
      ),
    );
  }
}
