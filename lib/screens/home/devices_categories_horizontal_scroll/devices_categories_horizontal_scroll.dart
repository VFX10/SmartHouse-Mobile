import 'package:Homey/design/widgets/device_card.dart';
import 'package:Homey/screens/devices_pages/device_page.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DevicesHorizontalScroll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            DeviceCard(
                icon: MdiIcons.lightbulb,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<DevicePage>(
                          builder: (_) => const DevicePage(
                                deviceType: 3,
                              )));
                },
                label: 'Lights'),
            DeviceCard(
                icon: MdiIcons.lightSwitch,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<DevicePage>(
                          builder: (_) => const DevicePage(
                                deviceType: 1,
                              )));
                },
                label: 'Switches'),
            DeviceCard(
                icon: MdiIcons.powerSocketEu,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<DevicePage>(
                          builder: (_) => const DevicePage(
                                deviceType: 2,
                              )));
                },
                label: 'Plugs'),
            DeviceCard(
                icon: MdiIcons.playSpeed, onPressed: () {}, label: 'Scenes'),
            DeviceCard(
                icon: MdiIcons.dotsHorizontal,
                onPressed: () {},
                label: 'All devices'),
          ],
        ));
  }
}
