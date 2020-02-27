import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDataManager {
  @protected
  var prefs;
  Map userData;
  Map defaultHome;
  List houses = [];
  List sensors = [];
  String token;

  static final AppDataManager _instance = AppDataManager._internal();

  factory AppDataManager() {
    return _instance;
  }

  Future addHouse(Map<String, dynamic> house) async {
    var data = prefs.getString('data') ?? '{}';
    Map<String, dynamic> allData = jsonDecode(data);
    if (houses.length == 0) {
      await prefs.setString('defaultHome', jsonEncode(house));
    }
    houses.add(house);
    if(defaultHome == null || defaultHome.length == 0)
      defaultHome = houses[0];

    allData['houses'] = houses;
    await prefs.setString('data', jsonEncode(allData));
  }

  Future addRoom(Map<String, dynamic> room) async {
    var data = prefs.getString('data') ?? '{}';
    Map<String, dynamic> allData = jsonDecode(data);
//    var defaultHouse = jsonDecode(prefs.getString('defaultHome') ?? '{}');
    if (allData.containsKey('houses')) {
      for(var h in allData['houses']){
        if(h['id'] == defaultHome['id']){
          log('added');
          h['rooms'].add(room);
        }
      }
      defaultHome['rooms'].add(room);
      await prefs.setString('data', jsonEncode(allData));
    }

  }

  Future removeData() async {
    userData = {};
    defaultHome = null;
    houses = [];
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('data');
    await prefs.remove('defaultHome');
    await prefs.remove('token');
  }

  Future fetchData() async {
    userData = {};
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data') ?? '{}';
    token = prefs.getString('token') ?? '';
    log('allData string', error: data);

    Map<String, dynamic> allData = jsonDecode(data);
//      log('allData', error: allData);

    if (allData.containsKey('email')) {
      userData['email'] = allData['email'];
      userData['firstName'] = allData['firstName'];
      userData['lastName'] = allData['lastName'];
      sensors = allData['allSensors'];
    }
    if (allData.containsKey('houses')) {
      houses = allData['houses'];
      if (houses != null &&
          houses.length > 0 &&
          (defaultHome == null || defaultHome.length == 0)) {
        await prefs.setString('defaultHome', jsonEncode(houses[0]));
      }
    }
    defaultHome = jsonDecode(prefs.getString('defaultHome') ?? '{}');
    log('userData', error: userData);
    log('houses', error: houses);
    log('defaultHome', error: defaultHome);
  }

  Future changeDefaultHome(Map<String, dynamic> home) async {
    defaultHome = home;
    await prefs.setString('defaultHome', home);
  }

  AppDataManager._internal() {
    log('created AppData');
  }
}
