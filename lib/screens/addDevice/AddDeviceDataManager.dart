
import 'dart:developer';

class AddDeviceDataManager {
  Map<String, dynamic> deviceData;

  static final AddDeviceDataManager _instance = AddDeviceDataManager._internal();

  factory AddDeviceDataManager() {
    return _instance;
  }

  AddDeviceDataManager._internal(){
    log('created');
  }
}