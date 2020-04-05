import 'dart:developer';

import 'package:Homey/app_data_manager.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/buttons/round_button.dart';
import 'package:Homey/design/widgets/device_list_item.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/main.dart';
import 'package:Homey/states/devices_states/device_selector_state.dart';
import 'package:Homey/states/on_result_callback.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flip_card/flip_card.dart';

class DeviceSelector extends StatefulWidget {
  const DeviceSelector({@required this.roomDbId, @required this.roomId});

  final int roomId;
  final int roomDbId;

  @override
  _DeviceSelectorState createState() => _DeviceSelectorState();
}

class _DeviceSelectorState extends State<DeviceSelector> {
  final DeviceSelectorState _state = getIt.get<DeviceSelectorState>();
  final List<SensorModel> sortedDevices = AppDataManager()
      .sensors
      .where((SensorModel sensor) => sensor.roomId == null)
      .toList();
  void onResult(dynamic data, ResultState state) {
    switch (state) {
      case ResultState.error:
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        Dialogs.showSimpleDialog('Error', data, context);
        break;
      case ResultState.successful:
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        break;
      case ResultState.loading:
        Dialogs.showProgressDialog(data, context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _state.clear();
    return Scaffold(
      floatingActionButton: StreamBuilder<int>(
        stream: _state.selectedDevicesCount$,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          return TweenAnimationBuilder<Offset>(
            tween: snapshot.hasData && snapshot.data > 0
                ? Tween<Offset>(
                    begin: Offset(MediaQuery.of(context).size.width, 0),
                    end: const Offset(0, 0),
                  )
                : Tween<Offset>(
                    begin: const Offset(0, 0),
                    end: Offset(MediaQuery.of(context).size.width, 0),
                  ),
            builder: (BuildContext context, Offset value, Widget child) {
              return Transform.translate(offset: value, child: child);
            },
            duration: const Duration(milliseconds: 250),
            child: FloatingActionButton.extended(
              onPressed: () =>
                  _state.addDevices(roomId: widget.roomId, roomDbId: widget.roomDbId, onResult: onResult),
              label: const Text('Finish'),
              icon: const Icon(MdiIcons.check),
            ),
          );
        },
      ),
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
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Flexible(
                      child: Text(
                        'Select devices',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.89,
              child: StreamBuilder<int>(
                  stream: _state.selectedDevicesCount$,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    log('refreshed', error: snapshot);
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: sortedDevices.length,
                      itemBuilder: (BuildContext context, int index) {
                        final GlobalKey<FlipCardState> cardKey =
                            GlobalKey<FlipCardState>();
                        return FlipCard(
                          key: cardKey,
                          direction: FlipDirection.VERTICAL,
                          onFlipDone: (_) {
                            _state.changeElement(
                                sortedDevices[index]);
                            log('new list', error: _state.selectedDevices);
                          },
                          front: DeviceListItem(
                            selected: _state.selectedDevices.contains(
                                sortedDevices[index]),
                            sensor: sortedDevices[index],
                            onPressed: () => cardKey.currentState.toggleCard(),
                          ),
                          back: DeviceListItem(
                            sensor: sortedDevices[index],
                            selected: !_state.selectedDevices.contains(
                                sortedDevices[index]),
                            onPressed: () => cardKey.currentState.toggleCard(),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
