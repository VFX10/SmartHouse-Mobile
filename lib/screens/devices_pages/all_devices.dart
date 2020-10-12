import 'package:Homey/app_data_manager.dart';
import 'package:Homey/design/widgets/buttons/round_button.dart';
import 'package:Homey/design/widgets/device_list_item.dart';
import 'package:Homey/design/widgets/empty_list_card.dart';
import 'package:Homey/helpers/data_types.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/screens/add_device/add_device_page.dart';
import 'package:Homey/screens/devices_pages/devices_types/temp_device_page.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'devices_types/switch_device_page.dart';


class AllDevices extends StatelessWidget {
  final List<SensorModel> sortedDevices = AppDataManager()
      .sensors
      .where((SensorModel sensor) => sensor.roomId == null)
      .toList();

  @override
  Widget build(BuildContext context) {
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
                    RoundButton
                      (
                      icon: Icon(MdiIcons.chevronLeft, color: Colors.black),
                      padding: const EdgeInsets.all(8),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'All devices',
                      style: TextStyle(fontSize: 18),
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
                      EmptyListItem(
                          title: 'You don\'t have any device.\nAdd one now',
                          onPressed: () =>
                              Navigator.push<AddDevice>(context,
                                MaterialPageRoute<AddDevice>(
                                  builder: (_) => AddDevice(),),),
                          icon: MdiIcons.help),

                    for (final SensorModel sensor in sortedDevices)
                      DeviceListItem(
                        sensor: sensor,
                        onPressed: () {
                          switch (sensor.sensorType) {
                            case DevicesType.undefined:
                              break;
                            case DevicesType.uv:
                              break;
                            case DevicesType.switchDevice:
                              Navigator.push<SwitchDevicePage>(
                                  context,
                                  MaterialPageRoute<SwitchDevicePage>(
                                      builder: (_) =>
                                          SwitchDevicePage(sensor: sensor)));
                              break;
                            case DevicesType.temperature:
                              Navigator.push<TempDevicePage>(
                                  context,
                                  MaterialPageRoute<TempDevicePage>(
                                      builder: (_) =>
                                          TempDevicePage(sensor: sensor)));
                              break;
                            case DevicesType.light:
                              break;
                            case DevicesType.gasAndSmoke:
                              break;
                            case DevicesType.contact:
                              break;
                            case DevicesType.powerConsumption:
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
        onPressed: () =>
            Navigator.push<AddDevice>(
                context,
                MaterialPageRoute<AddDevice>(builder: (_) => AddDevice())),
        child: const Icon(MdiIcons.plus),
      ),
    );
  }
}
