import 'package:Homey/design/colors.dart';
import 'package:Homey/helpers/data_types.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/screens/addDevice/addDevicePage.dart';
import 'package:Homey/screens/devices_pages/switch_device_page/switch_device_page.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../app_data_manager.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({this.deviceType = 0}) : super();
  final int deviceType;

  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  @override
  Widget build(BuildContext context) {
    final List<SensorModel> sortedDevices = AppDataManager()
        .sensors
        .where((SensorModel sensor) => sensor.sensorType == widget.deviceType)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(DataTypes.sensorsType[widget.deviceType]['text']),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          if (sortedDevices.isEmpty)
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute<dynamic>(builder: (_) => AddDevice())),
              child: Container(
                child: AspectRatio(
                  aspectRatio: 21 / 9,
                  child: Card(
                    elevation: 10,
                    color: ColorsTheme.backgroundCard,
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 16, top: 16, right: 16, bottom: 10),
                      child: Stack(
                        children: const <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'You don\'t have any device.\nAdd one now',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              MdiIcons.help,
                              size: 50,
                              color: ColorsTheme.background,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          for (final SensorModel sensor in sortedDevices)
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<dynamic>(
                      builder: (_) => SwitchDevicePage(sensor: sensor))),
              child: Card(
                elevation: 20,
                color: ColorsTheme.backgroundCard,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Icon(DataTypes.sensorsType[widget.deviceType]['icon']),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(sensor.name),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute<dynamic>(builder: (_) => AddDevice())),
        child: const Icon(MdiIcons.plus),
      ),
    );
  }
}
