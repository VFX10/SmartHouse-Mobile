import 'package:Homey/design/widgets/device_card.dart';
import 'package:Homey/helpers/data_types.dart';
import 'package:Homey/screens/devices_pages/all_devices.dart';
import 'package:Homey/screens/devices_pages/device_page.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DevicesHorizontalScroll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      scrollDirection: Axis.horizontal,
//        child: Row(
      children: <Widget>[
        DeviceCard(
          icon: MdiIcons.thermometer,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<DevicePage>(
                builder: (_) => const DevicePage(
                  deviceType: DevicesType.temperature,
                ),
              ),
            );
          },
          label: 'Temperature',
        ),
        DeviceCard(
          icon: MdiIcons.weatherSunny,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<DevicePage>(
                builder: (_) => const DevicePage(
                  deviceType: DevicesType.uv,
                ),
              ),
            );
          },
          label: 'UV',
        ),
        DeviceCard(
          icon: MdiIcons.smokeDetector,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<DevicePage>(
                builder: (_) => const DevicePage(
                  deviceType: DevicesType.gasAndSmoke,
                ),
              ),
            );
          },
          label: 'Smoke',
        ),
        DeviceCard(
          icon: MdiIcons.themeLightDark,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<DevicePage>(
                builder: (_) => const DevicePage(
                  deviceType: DevicesType.light,
                ),
              ),
            );
          },
          label: 'Light',
        ),
        DeviceCard(
          icon: MdiIcons.powerSocketEu,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<DevicePage>(
                builder: (_) => const DevicePage(
                  deviceType: DevicesType.switchDevice,
                ),
              ),
            );
          },
          label: 'Plugs',
        ),
        DeviceCard(
          icon: MdiIcons.door,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<DevicePage>(
                builder: (_) => const DevicePage(
                  deviceType: DevicesType.contact,
                ),
              ),
            );
          },
          label: 'Door/Window',
        ),
        DeviceCard(
          icon: MdiIcons.counter,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<DevicePage>(
              builder: (_) => const DevicePage(
                deviceType: DevicesType.powerConsumption,
              ),
            ),
          ),
          label: 'Power Consumption Sensors',
        ),
        DeviceCard(
          icon: MdiIcons.playSpeed,
          onPressed: () {},
          label: 'Scenes',
        ),
        DeviceCard(
          icon: MdiIcons.dotsHorizontal,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<DevicePage>(
              builder: (_) => AllDevices(),
            ),
          ),
          label: 'Unassigned devices',
        ),
      ],
    );
  }
}
