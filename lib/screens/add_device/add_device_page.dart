import 'package:Homey/data/devices_states/add_device_state.dart';
import 'package:Homey/data/devices_states/network_status_state.dart';
import 'package:Homey/design/widgets/buttons/round_rectangle_button.dart';
import 'package:Homey/main.dart';
import 'package:Homey/screens/add_device/pages/esp_touch_config_page.dart';
import 'package:Homey/screens/add_device/pages/rooms_selector.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'pages/device_config_page.dart';

class AddDevice extends StatefulWidget {
  @override
  _AddDeviceState createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  final PageController controller = PageController();
  final AddDeviceState _state = getIt.get<AddDeviceState>();
  final NetworkStatusState _networkState = getIt.get<NetworkStatusState>();

  void next() {
    controller.nextPage(duration: kTabScrollDuration, curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Device'),
      ),
      body: FutureBuilder<Map<PermissionGroup, PermissionStatus>>(
        future: _networkState.getConnectivityType(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<PermissionGroup, PermissionStatus>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      MdiIcons.map,
                      size: 80,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'We need location permissions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            );
          } else {
            if (snapshot.hasData &&
                (snapshot.data[PermissionGroup.location] ==
                        PermissionStatus.granted ||
                    snapshot.data[PermissionGroup.locationWhenInUse] ==
                        PermissionStatus.granted)) {
              return PageView(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  EspTouchConfigPage(state: _state, event: next),
                  DeviceConfig(state: _state, event: next),
                  RoomSelectorPage(
                    state: _state,
                  ),
                ],
              );
            } else {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Icon(
                        MdiIcons.mapMarkerOffOutline,
                        size: 80,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'You must accept location permissions',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RoundRectangleButton(
                          onPressed: () => setState(() {}), label: 'Retry')
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
