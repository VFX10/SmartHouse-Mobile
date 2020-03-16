import 'package:Homey/design/widgets/device_card.dart';
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
        AnimationConfiguration.staggeredList(
          position: 1,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: -115,
            child: FadeInAnimation(
              child: DeviceCard(
                  icon: MdiIcons.thermometer,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<DevicePage>(
                            builder: (_) => const DevicePage(
                                  deviceType: 3,
                                )));
                  },
                  label: 'Temperature'),
            ),
          ),
        ),
        AnimationConfiguration.staggeredList(
          position: 2,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: -115,
            child: FadeInAnimation(
              child: DeviceCard(
                  icon: MdiIcons.weatherSunny,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<DevicePage>(
                            builder: (_) => const DevicePage(
                                  deviceType: 1,
                                )));
                  },
                  label: 'UV'),
            ),
          ),
        ),
        AnimationConfiguration.staggeredList(
          position: 3,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: -115,
            child: FadeInAnimation(
              child: DeviceCard(
                  icon: MdiIcons.smokeDetector,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<DevicePage>(
                            builder: (_) => const DevicePage(
                                  deviceType: 5,
                                )));
                  },
                  label: 'Smoke'),
            ),
          ),
        ),
        AnimationConfiguration.staggeredList(
          position: 4,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: -115,
            child: FadeInAnimation(
              child: DeviceCard(
                  icon: MdiIcons.themeLightDark,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<DevicePage>(
                            builder: (_) => const DevicePage(
                                  deviceType: 4,
                                )));
                  },
                  label: 'Light'),
            ),
          ),
        ),
        AnimationConfiguration.staggeredList(
          position: 5,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: -115,
            child: FadeInAnimation(
              child: DeviceCard(
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
            ),
          ),
        ),
        AnimationConfiguration.staggeredList(
          position: 6,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: -115,
            child: FadeInAnimation(
              child: DeviceCard(
                  icon: MdiIcons.door,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<DevicePage>(
                            builder: (_) => const DevicePage(
                                  deviceType: 6,
                                )));
                  },
                  label: 'Door/Window'),
            ),
          ),
        ),
        AnimationConfiguration.staggeredList(
          position: 7,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: -115,
            child: FadeInAnimation(
              child: DeviceCard(
                  icon: MdiIcons.playSpeed, onPressed: () {}, label: 'Scenes'),
            ),
          ),
        ),
        AnimationConfiguration.staggeredList(
          position: 8,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: -115,
            child: FadeInAnimation(
              child: DeviceCard(
                  icon: MdiIcons.dotsHorizontal,
                  onPressed: () {},
                  label: 'All devices'),
            ),
          ),
        ),
      ],
//        ),
    );
  }
}
