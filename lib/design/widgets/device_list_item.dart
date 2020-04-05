import 'package:Homey/design/colors.dart';
import 'package:Homey/design/widgets/network_status.dart';
import 'package:Homey/helpers/data_types.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DeviceListItem extends StatelessWidget {
  const DeviceListItem(
      {@required this.sensor,
      this.onPressed,
      this.action,
      this.selected = false});

  final SensorModel sensor;
  final Function onPressed;
  final Widget action;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 20,
      color: ColorsTheme.backgroundCard,
      child: InkWell(
        splashColor: ColorsTheme.backgroundDarker,
        onTap: onPressed,
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Icon(DataTypes.sensorsType[sensor.sensorType]['icon']),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(sensor.name),
                  const Spacer(),
                  if (action != null)
                    action
                  else
                    NetworkStatusLabel(online: sensor.networkStatus),
                ],
              ),
            ),
            if (selected)
              Positioned.fill(
                child: Container(
                  color: ColorsTheme.backgroundDarker.withOpacity(0.6),
                  child: Center(
                    child: Icon(MdiIcons.check),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
