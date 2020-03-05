import 'dart:developer';

class RoomDataModelManager {
  String roomName = '';
  static final RoomDataModelManager _instance =
      RoomDataModelManager._internal();

  factory RoomDataModelManager() {
    return _instance;
  }

  RoomDataModelManager._internal() {
    log('created room manager');
  }
}
