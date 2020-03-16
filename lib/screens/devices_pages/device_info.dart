import 'dart:developer';

import 'package:Homey/data/models/devices_models/device_switch_model.dart';
import 'package:Homey/data/on_result_callback.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/network_status.dart';
import 'package:Homey/helpers/data_types.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DeviceInfo extends StatefulWidget {
  const DeviceInfo({this.state, this.sensor});

  final dynamic state;
  final SensorModel sensor;

  @override
  _DeviceInfoState createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  @override
  Widget build(BuildContext context) {
    log('sssss', error: widget.sensor.toMap().toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsTheme.backgroundCard,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: ColorsTheme.backgroundCard,
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    DataTypes.sensorsType[widget.sensor.sensorType]['icon'],
                    size: 100,
                  ),
                  Text(
                    widget.sensor.name,
                    style: const TextStyle(fontSize: 35),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: const Alignment(1, -0.1),
                    child: ListView(
//                    mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: <Widget>[
                              const Icon(MdiIcons.wifi),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('Network information'),
                              const Spacer(),
                              Expanded(
                                flex: 1,
                                child: StreamBuilder<dynamic>(
                                    stream: widget.state.dataStream$,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot) {
                                      return AnimatedCrossFade(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          crossFadeState:
                                              widget.state.device.networkStatus
                                                  ? CrossFadeState.showFirst
                                                  : CrossFadeState.showSecond,
                                          secondChild: const NetworkStatusLabel(
                                              online: false),
                                          firstChild: const NetworkStatusLabel(
                                              online: true));
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: <Widget>[
                                const Icon(MdiIcons.ip),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.sensor.ipAddress ?? 'IP unset',
                                  style: TextStyle(
                                      color: widget.sensor.ipAddress == null
                                          ? Colors.red
                                          : Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: <Widget>[
                                const Icon(MdiIcons.developerBoard),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.sensor.macAddress ??
                                      'Cannot get MAC Address',
                                  style: TextStyle(
                                      color: widget.sensor.macAddress == null
                                          ? Colors.red
                                          : Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: ColorsTheme.backgroundDarker,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 20,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: Icon(MdiIcons.restart),
              onPressed: () => widget.state.rebootDevice(widget.sensor, onResult),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
//        label: const Text(
//          'Delete',
//          style: TextStyle(color: Colors.white),
//        ),
        child: const Icon(
          MdiIcons.trashCanOutline,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
    );
  }
  void onResult( dynamic data, ResultState state) {
    switch(state) {

      case ResultState.successful:
        Dialogs.showSimpleDialog('Success', data, context);
        break;
      case ResultState.error:
        // TODO: Handle this case.
        break;
      case ResultState.loading:
        // TODO: Handle this case.
        break;
    }
  }
}
