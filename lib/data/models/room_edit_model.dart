import 'package:Homey/design/rooms_styles.dart';

class RoomEditModel{

  const RoomEditModel({this.roomName, this.roomStyle, this.didChanged = false, });
  final String roomName;
  final bool didChanged;
  final Map<String, dynamic> roomStyle;

}