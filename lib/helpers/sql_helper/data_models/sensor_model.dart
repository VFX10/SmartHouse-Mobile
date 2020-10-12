import 'package:Homey/helpers/data_types.dart';

class SensorModel {
  SensorModel(
      {this.id,
      this.dbId,
      this.roomId,
      this.name,
      this.sensorType,
      this.readingFrequency,
      this.ipAddress,
      this.macAddress,
      this.networkStatus});

  final int id;
  final int dbId;
  final int roomId;
  String name;
  DevicesType sensorType;
  final String ipAddress;
  final String macAddress;
  dynamic networkStatus;
  int readingFrequency;
  String account;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dbId': dbId,
      'roomId': roomId,
      'name': name,
      'readingFrequency': readingFrequency,
      'sensorType': sensorType.index,
      'ipAddress': ipAddress,
      'macAddress': macAddress,
      'networkStatus': networkStatus,
      'account': account,
    };
  }
}
