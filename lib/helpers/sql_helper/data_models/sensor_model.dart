// Update the Dog class to include a `toMap` method.
class SensorModel {
  final int id;
  final int dbId;
  final int roomId;
  final String name;
  final int sensorType;
  final String ipAddress;
  final String macAddress;
  final String networkStatus;
  final int readingFrequency;


  SensorModel({this.id, this.dbId, this.roomId, this.name, this.sensorType, this.readingFrequency, this.ipAddress, this.macAddress, this.networkStatus});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dbId': dbId,
      'roomId': roomId,
      'name': name,
      'readingFrequency': readingFrequency,
      'sensorType': sensorType,
      'ipAddress': ipAddress,
      'macAddress': macAddress,
      'networkStatus': networkStatus,
    };
  }
}
