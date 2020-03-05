import 'package:Homey/helpers/sql_helper/data_models/home_model.dart';
import 'package:Homey/helpers/sql_helper/data_models/room_model.dart';
import 'package:flutter/material.dart';

class HomePageState extends ChangeNotifier {
  @protected
  HomeModel _selectedHome;

  @protected
  List<RoomModel> _selectedRooms = <RoomModel>[];

  HomeModel get selectedHome => _selectedHome;

  List<RoomModel> get selectedRooms => _selectedRooms;

  set selectedHome(HomeModel value) {
    _selectedHome = value;
    notifyListeners();
  }

  set selectedRooms(List<RoomModel> value) {
    _selectedRooms = value;
    notifyListeners();
  }

  void setHome(HomeModel defaultHome) {
    _selectedHome = defaultHome;
//    _selectedRooms = defaultHome != null ? defaultHome['rooms'] : [];
    _selectedRooms = defaultHome != null ? defaultHome.rooms : <RoomModel>[];
  }
}
