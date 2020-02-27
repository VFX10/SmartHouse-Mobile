import 'dart:convert';
import 'dart:developer';

import 'package:Homey/AppDataManager.dart';
import 'package:flutter/material.dart';

class HomePageState extends ChangeNotifier {
  @protected
  Map<String, dynamic> _selectedHome;

  @protected
  List _selectedRooms;

  Map<String, dynamic> get selectedHome => _selectedHome;

  List get selectedRooms => _selectedRooms;

  set selectedHome(Map<String, dynamic> value) {
    _selectedHome = value;
    notifyListeners();
  }

  set selectedRooms(List value) {
    _selectedRooms = value;
    notifyListeners();
  }

  void setHome(Map<String, dynamic> defaultHome) {
    _selectedHome = defaultHome;
    _selectedRooms = defaultHome != null ? defaultHome['rooms'] : [];
  }
}
