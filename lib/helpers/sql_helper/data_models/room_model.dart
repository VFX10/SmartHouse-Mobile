import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';

class RoomModel {
  const RoomModel({this.id, this.dbId, this.houseId, this.name, this.sensors});

  final int id;
  final int dbId;
  final int houseId;
  final String name;
  final List<SensorModel> sensors;

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dbId': dbId,
      'houseId': houseId,
      'name': name,
      'sensors': sensors,
    };
  }
}
