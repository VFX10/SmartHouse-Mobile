import 'dart:developer';
import 'package:Homey/helpers/sql_helper/data_models/home_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/user_model.dart';
import 'package:Homey/helpers/sql_helper/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDataManager {
  factory AppDataManager() {
    return _instance;
  }
  AppDataManager._internal() {
    log('created instance of AppDataManager');
  }

  @protected
  SharedPreferences prefs;
  UserDataModel userData;
  HomeModel defaultHome;
  final List<HomeModel> houses = <HomeModel>[];
  final List<SensorModel> sensors = <SensorModel>[];
  String token;

  static final AppDataManager _instance = AppDataManager._internal();

  Future<dynamic> addHouse(HomeModel house) async {
    await SqlHelper().addHome(house);
    if (houses.isEmpty) {
      await prefs.setInt('defaultHomeId', 1);
    }
    houses.add(house);
    defaultHome ??= houses[0];
    houses.addAll(await SqlHelper().getAllHouses());
  }

  Future<dynamic> addRoom(RoomModel room) async {
    await SqlHelper().addRoom(room);
    defaultHome.rooms.add(room);
  }

  Future<dynamic> addSensor(SensorModel sensor) async {
    log('dfsfs', error: sensor.toMap());
    final List<SensorModel> find = sensors
        .where((SensorModel sensorF) => sensorF.macAddress == sensor.macAddress)
        .toList();
    log('find', error: find);
    if (find.isNotEmpty) {
      log('update');
      await SqlHelper().updateSensor(sensor);
    } else {
      log('insert');
      await SqlHelper().addSensor(sensor);
      sensors.add(sensor);
    }
  }

  Future<dynamic> removeData() async {
    await SqlHelper().dropDatabase();
    userData = null;
    defaultHome = null;
    houses.clear();
    await prefs.remove('defaultHomeId');
    await prefs.remove('token');
  }

  Future<dynamic> fetchData() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    userData = await SqlHelper().getUserData();
    defaultHome = await SqlHelper()
        .getHomeInfoById(prefs.getInt('defaultHomeId') ?? 1);
    houses.addAll(await SqlHelper().getAllHouses());
    sensors.addAll(await SqlHelper().getAllSensors());
  }

  Future<dynamic>  changeDefaultHome(int homeId) async {
    defaultHome = await SqlHelper().getHomeInfoById(homeId);
    await prefs.setInt('defaultHomeId', homeId);
  }


}
