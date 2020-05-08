import 'package:Homey/design/colors.dart';
import 'package:Homey/design/widgets/buttons/round_button.dart';
import 'package:Homey/design/widgets/device_list_item.dart';
import 'package:Homey/helpers/data_types.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/screens/add_device/add_device_page.dart';
import 'package:Homey/screens/devices_pages/devices_types/door_device_page.dart';
import 'package:Homey/screens/devices_pages/devices_types/gas_device_page.dart';
import 'package:Homey/screens/devices_pages/devices_types/light_device_page.dart';
import 'package:Homey/screens/devices_pages/devices_types/power_consumption_page.dart';
import 'package:Homey/screens/devices_pages/devices_types/switch_device_page.dart';
import 'package:Homey/screens/devices_pages/devices_types/temp_device_page.dart';
import 'package:Homey/screens/devices_pages/devices_types/uv_sensor_page.dart';
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
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    RoundButton(
                      icon: Icon(MdiIcons.chevronLeft, color: Colors.black),
                      padding: const EdgeInsets.all(8),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      DataTypes.sensorsType[widget.deviceType]['title'],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: FractionallySizedBox(
                heightFactor: 0.90,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: <Widget>[
                    if (sortedDevices.isEmpty)
                      GestureDetector(
                        onTap: () => Navigator.push<AddDevice>(context,
                            MaterialPageRoute<AddDevice>(builder: (_) => AddDevice())),
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
                      DeviceListItem(
                        sensor: sensor,
                        onPressed: (){
                          switch(widget.deviceType){
                            case 0:

                              break;
                            case 1:
                              Navigator.push<UVSensorPage>(
                                  context,
                                  MaterialPageRoute<UVSensorPage>(
                                      builder: (_) => UVSensorPage(sensor: sensor)));
                              break;
                            case 2:
                              Navigator.push<SwitchDevicePage>(
                                  context,
                                  MaterialPageRoute<SwitchDevicePage>(
                                      builder: (_) => SwitchDevicePage(sensor: sensor)));
                              break;
                            case 3:
                              Navigator.push<TempDevicePage>(
                                  context,
                                  MaterialPageRoute<TempDevicePage>(
                                      builder: (_) => TempDevicePage(sensor: sensor)));
                              break;
                            case 4:
                              Navigator.push<LightDevicePage>(
                                  context,
                                  MaterialPageRoute<LightDevicePage>(
                                      builder: (_) => LightDevicePage(sensor: sensor)));
                              break;
                            case 5:
                              Navigator.push<GasDevicePage>(
                                  context,
                                  MaterialPageRoute<GasDevicePage>(
                                      builder: (_) => GasDevicePage(sensor: sensor)));
                              break;
                            case 6:
                              Navigator.push<DoorDevicePage>(
                                  context,
                                  MaterialPageRoute<DoorDevicePage>(
                                      builder: (_) => DoorDevicePage(sensor: sensor)));
                              break;
                            case 7:
                              Navigator.push<TempDevicePage>(
                                  context,
                                  MaterialPageRoute<TempDevicePage>(
                                      builder: (_) => PowerConsumptionDevicePage(sensor: sensor)));
                              break;
                          }
                        },
                      ),
//                      InkWell(
//                        splashColor: ColorsTheme.backgroundDarker,
//                        onTap: () {
//                          switch(widget.deviceType){
//                            case 0:
//
//                              break;
//                            case 1:
//
//                              break;
//                            case 2:
//                              Navigator.push<SwitchDevicePage>(
//                                  context,
//                                  MaterialPageRoute<SwitchDevicePage>(
//                                      builder: (_) => SwitchDevicePage(sensor: sensor)));
//                              break;
//                            case 3:
//                              Navigator.push<TempDevicePage>(
//                                  context,
//                                  MaterialPageRoute<TempDevicePage>(
//                                      builder: (_) => TempDevicePage(sensor: sensor)));
//                              break;
//                          }
//                        },
//                        child: Card(
//                          elevation: 20,
//                          color: ColorsTheme.backgroundCard,
//                          child: Container(
//                            padding: const EdgeInsets.all(16),
//                            child: Row(
//                              children: <Widget>[
//                                Icon(DataTypes.sensorsType[widget.deviceType]['icon']),
//                                const SizedBox(
//                                  width: 10,
//                                ),
//                                Text(sensor.name),
//                                const Spacer(),
//                                 NetworkStatusLabel(online: sensor.networkStatus),
//                              ],
//                            ),
//                          ),
//                        ),
//                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push<AddDevice>(
            context, MaterialPageRoute<AddDevice>(builder: (_) => AddDevice())),
        child: const Icon(MdiIcons.plus),
      ),
    );
  }
}
