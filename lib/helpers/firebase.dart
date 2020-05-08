import 'dart:developer';
import 'dart:io';

import 'package:Homey/app_data_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseHelper {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  void initFirebase(){
    firebaseMessaging.subscribeToTopic(
        AppDataManager().userData.email.replaceAll('@', 'AT'));
//    firebaseMessaging.getToken().then(print);
    // ignore: cascade_invocations
    firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          log('onMessage', error: message);
        }, onLaunch: (Map<String, dynamic> message) async {
      log('onLaunch', error: message);
    }, onResume: (Map<String, dynamic> message) async {
      log('onLaunch', error: message);
    });

    // ignore: cascade_invocations
    if (Platform.isIOS) {
      firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
    }
  }
  void onLogout(){
    firebaseMessaging.unsubscribeFromTopic(AppDataManager().userData.email.replaceAll('@', 'AT'));
  }
}
