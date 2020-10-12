import 'package:Homey/design/colors.dart';
import 'package:Homey/design/widgets/buttons/round_button.dart';
import 'package:Homey/design/widgets/device_list_item.dart';
import 'package:Homey/design/widgets/empty_list_card.dart';
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
  const DevicePage({this.deviceType = DevicesType.undefined}) : super();
  final DevicesType deviceType;

  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  void navigateToPage(SensorModel sensor) {
    switch (widget.deviceType) {
      case DevicesType.undefined:
        break;
      case DevicesType.uv:
        Navigator.push<UVSensorPage>(
            context,
            MaterialPageRoute<UVSensorPage>(
                builder: (_) => UVSensorPage(sensor: sensor)));
        break;
      case DevicesType.switchDevice:
        Navigator.push<SwitchDevicePage>(
            context,
            MaterialPageRoute<SwitchDevicePage>(
                builder: (_) => SwitchDevicePage(sensor: sensor)));
        break;
      case DevicesType.temperature:
        Navigator.push<TempDevicePage>(
            context,
            MaterialPageRoute<TempDevicePage>(
                builder: (_) => TempDevicePage(sensor: sensor)));
        break;
      case DevicesType.light:
        Navigator.push<LightDevicePage>(
            context,
            MaterialPageRoute<LightDevicePage>(
                builder: (_) => LightDevicePage(sensor: sensor)));
        break;
      case DevicesType.gasAndSmoke:
        Navigator.push<GasDevicePage>(
            context,
            MaterialPageRoute<GasDevicePage>(
                builder: (_) => GasDevicePage(sensor: sensor)));
        break;
      case DevicesType.contact:
        Navigator.push<DoorDevicePage>(
            context,
            MaterialPageRoute<DoorDevicePage>(
                builder: (_) => DoorDevicePage(sensor: sensor)));
        break;
      case DevicesType.powerConsumption:
        Navigator.push<TempDevicePage>(
            context,
            MaterialPageRoute<TempDevicePage>(
                builder: (_) => PowerConsumptionDevicePage(sensor: sensor)));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<SensorModel> sortedDevices = AppDataManager()
        .sensors
        .where((SensorModel sensor) => sensor.sensorType == widget.deviceType)
        .toList();
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                RoundButton(
                  icon: const Icon(MdiIcons.chevronLeft, color: Colors.black),
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
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: sortedDevices.isEmpty
                  ? EmptyListItem(
                      title: 'You don\'t have any device.\nAdd one now',
                      onPressed: () => Navigator.push<AddDevice>(
                            context,
                            MaterialPageRoute<AddDevice>(
                              builder: (_) => AddDevice(),
                            ),
                          ),
                      icon: MdiIcons.help)
                  : ListView.builder(
                      itemCount: sortedDevices.length,
                      itemBuilder: (BuildContext context, int index) {
                        return DeviceListItem(
                          sensor: sortedDevices[index],
                          onPressed: () => navigateToPage(sortedDevices[index]),
                        );
                      },
                    ),
            )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push<AddDevice>(
            context, MaterialPageRoute<AddDevice>(builder: (_) => AddDevice())),
        child: const Icon(MdiIcons.plus),
      ),
    );
  }
}
