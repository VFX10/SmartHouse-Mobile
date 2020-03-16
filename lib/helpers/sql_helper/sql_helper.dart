import 'dart:developer';
import 'dart:io';

import 'package:Homey/helpers/sql_helper/data_models/home_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../app_data_manager.dart';
import 'data_models/room_model.dart';
import 'data_models/user_model.dart';

class SqlHelper {
  factory SqlHelper() {
    return _instance;
  }

  SqlHelper._internal() {
    log('SqlHelper create');
  }

  @protected
  Database _database;
  @protected
  String path;
  @protected
  static final SqlHelper _instance = SqlHelper._internal();

  Future<void> initDatabase() async {
    final String databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'data.db');
// Make sure the directory exists
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {}

// open the database
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE IF NOT EXISTS UserData (id INTEGER PRIMARY KEY, email TEXT, firstName TEXT, lastName TEXT);');
          await db.execute(
              'CREATE TABLE IF NOT EXISTS Houses (id INTEGER PRIMARY KEY, userId INTEGER, dbId INTEGER, name TEXT, address TEXT);');
          await db.execute(
              'CREATE TABLE IF NOT EXISTS Rooms (id INTEGER PRIMARY KEY, houseId INTEGER, dbId INTEGER, name TEXT);');
          await db.execute(
              'CREATE TABLE IF NOT EXISTS Sensors (id INTEGER PRIMARY KEY, roomId INTEGER, dbId INTEGER, name TEXT, sensorType INTEGER, ipAddress TEXT, macAddress TEXT, readingFrequency INTEGER, networkStatus BOOLEAN);');
        });
    log('database', error: _database.isOpen);
  }

  Future<void> dropDatabase() async {
    await deleteDatabase(path);
    await _database.close();
  }

  Future<void> insert(dynamic data) async {
    if (!_database.isOpen) {
      log('o sa init');
      await initDatabase();
    }
    await _database.transaction((Transaction transaction) async {
      final int userId = await transaction.rawInsert(
          'INSERT INTO UserData(email, firstName, lastName) VALUES ("${data['email']}", "${data['firstName']}", "${data['lastName']}");');
      for (final Map<String, dynamic> house in data['houses']) {
        final int houseId = await transaction.rawInsert(
            'INSERT INTO Houses(userId, dbId, name, address) VALUES ($userId, ${house['id']}, "${house['name']}", "${house['address']}");');
        for (final Map<String, dynamic> room in house['rooms']) {
          final int roomId = await transaction.rawInsert(
              'INSERT INTO Rooms(houseId, dbId, name) VALUES ($houseId, ${room['id']}, "${room['name']}");');
          for (final Map<String, dynamic> sensor in room['sensors']) {
            await transaction.rawInsert(
                'INSERT INTO Sensors(roomId, dbId, name, sensorType, readingFrequency, macAddress, networkStatus) VALUES ($roomId, ${sensor['id']}, "${sensor['name']}", "${sensor['sensorType']}",${sensor['readingFrequency']}, "${sensor['macAddress']}", "${sensor['networkStatus'] ==
                    1}");');
          }
        }
      }
    }).then((_) async {
      await AppDataManager().fetchData();
    }, onError: (Object e) {
      log('transaction error', error: e);
      log(e.toString());
    });
  }

  Future<List<HomeModel>> getAllHouses() async {
    final List<Map<String, dynamic>> list =
    await _database.rawQuery('SELECT DISTINCT * FROM Houses ORDER BY dbId');
    return List<HomeModel>.generate(list.length, (int i) {
      return HomeModel(
        id: list[i]['id'],
        dbId: list[i]['dbId'],
        name: list[i]['name'],
      );
    });
  }

  Future<List<SensorModel>> getAllSensors() async {
    final List<Map<String, dynamic>> list = await _database
        .rawQuery('SELECT DISTINCT * FROM SENSORS ORDER BY dbId');
    return List<SensorModel>.generate(list.length, (int i) {
      return SensorModel(
        id: list[i]['id'],
        dbId: list[i]['dbId'],
        roomId: list[i]['roomId'],
        readingFrequency: list[i]['readingFrequency'],
        ipAddress: list[i]['ipAddress'],
        macAddress: list[i]['macAddress'],
        sensorType: list[i]['sensorType'],
        networkStatus: list[i]['networkStatus'] == 'true',
        name: list[i]['name'],
      );
    });
  }

  Future<void> addHome(HomeModel house) async {
    await _database.rawInsert(
        'INSERT INTO Houses(userId, dbId, name, address) VALUES (${house
            .userId}, ${house.dbId}, "${house.name}", "${house.address}");');
  }

  Future<void> addRoom(RoomModel room) async {
    await _database.rawInsert(
        'INSERT INTO Rooms(houseId, dbId, name) VALUES (${room.houseId}, ${room
            .dbId}, "${room.name}");');
  }

  Future<void> addSensor(SensorModel sensor) async {
    await _database.rawInsert(
        'INSERT INTO Sensors(roomId, dbId, name, sensorType, ipAddress, macAddress) VALUES (${sensor
            .roomId}, ${sensor.dbId}, "${sensor.name}", "${sensor
            .sensorType}", "${sensor.ipAddress}", "${sensor.macAddress}");');
  }

  Future<void> updateSensor(SensorModel sensor) async {
//    await _database.update(
//      'Sensors',
//      sensor.toMap(),
//      // Ensure that the Dog has a matching id.
//      where: "macAddress = ?",
//      // Pass the Dog's id as a whereArg to prevent SQL injection.
//      whereArgs: [sensor.macAddress],
//    );

    await _database.rawUpdate(
        'UPDATE Sensors SET roomId = ${sensor.roomId}, dbId = ${sensor
            .dbId}, name = "${sensor.name}", sensorType = ${sensor
            .sensorType}, ipAddress = "${sensor
            .ipAddress}", networkStatus = "${sensor
            .networkStatus}", readingFrequency = ${sensor
            .readingFrequency} WHERE macAddress = "${sensor.macAddress}";');
  }

  Future<List<Map<String, dynamic>>> getRoomsByHouseId(int houseId) async {
    final List<Map<String, dynamic>> list = await _database
        .rawQuery('SELECT * FROM Rooms WHERE houseId = $houseId');
    if (list.isEmpty) {
      return null;
    }
    return list;
  }

  Future<UserDataModel> getUserData() async {
    log('getUserData database', error: _database.isOpen);

    final List<Map<String, dynamic>> list =
    await _database.rawQuery('SELECT DISTINCT * FROM UserData LIMIT 1');
    log('list Users', error: list);
    if (list.isEmpty) {
      return null;
    }
    return UserDataModel(
      id: list[0]['id'],
      email: list[0]['email'],
      firstName: list[0]['firstName'],
      lastName: list[0]['lastName'],
    );
  }

  Future<HomeModel> getHomeInfoById(int homeId) async {
    final List<Map<String, dynamic>> list = await _database
        .rawQuery('SELECT DISTINCT * FROM Houses WHERE id = $homeId');

    final List<Map<String, dynamic>> rooms = await _database.rawQuery(
        'SELECT DISTINCT r.* FROM Rooms AS r INNER JOIN Houses AS h ON h.id = r.houseId WHERE h.id = $homeId ORDER BY r.name');
    final List<Map<String, dynamic>> sensors =
    await _database.rawQuery('SELECT DISTINCT s.* '
        'FROM Sensors AS s '
        'INNER JOIN Rooms AS r ON r.id = s.roomId '
        'INNER JOIN Houses AS h ON h.id = r.houseId '
        'WHERE h.id = $homeId '
        'ORDER BY s.sensorType'
    );
    log('gggg', error: sensors.toString());
    if (list.isEmpty) {
      return null;
    }
    final HomeModel home = HomeModel(
        id: list[0]['id'],
        dbId: list[0]['dbId'],
        userId: list[0]['userId'],
        name: list[0]['name'],
        address: list[0]['address'],
        rooms: List<RoomModel>.generate(rooms.length, (int i) {
          final List<dynamic> sortedSensors = sensors
              .where((Map<String, dynamic> sensor) =>
          sensor['roomId'] == rooms[i]['id'])
              .toList();
          return RoomModel(
              id: rooms[i]['id'],
              houseId: homeId,
              dbId: rooms[i]['dbId'],
              name: rooms[i]['name'],
              sensors:
              List<SensorModel>.generate(sortedSensors.length, (int j) {
                return SensorModel(
                    id: sortedSensors[j]['id'],
                    dbId: sortedSensors[j]['dbId'],
                    roomId: sortedSensors[j]['roomId'],
                    name: sortedSensors[j]['name'],
                    macAddress: sortedSensors[j]['macAddress'],
                    networkStatus: sortedSensors[j]['networkStatus'] == 'true',
                    sensorType: sortedSensors[j]['sensorType']);
              }));
        }));
    log(home.toMap().toString());
    return home;
  }

  Future<void> selectAll() async {
    final List<Map<String, dynamic>> list =
    await _database.rawQuery('SELECT DISTINCT * FROM UserData');
    final List<Map<String, dynamic>> list1 =
    await _database.rawQuery('SELECT DISTINCT* FROM Houses');
    final List<Map<String, dynamic>> list2 =
    await _database.rawQuery('SELECT DISTINCT * FROM Rooms');
    final List<Map<String, dynamic>> list3 =
    await _database.rawQuery('SELECT DISTINCT * FROM Sensors');
    log('selectU', error: list);
    log('selectH', error: list1);
    log('selectR', error: list2);
    log('selectS', error: list3);
  }
}
