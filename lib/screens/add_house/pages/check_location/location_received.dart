import 'package:Homey/design/widgets/buttons/round_rectangle_button.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LocationReceivedPage extends StatelessWidget {
  const LocationReceivedPage(
      {@required this.submitEvent,
        this.buttonIcon,
        final this.buttonText = '',
        this.buttonColor = ColorsTheme.primary,
        this.backgroundColor = ColorsTheme.background,
        this.hasButton = true,
        this.isLocationCorrectEvent,
        @required this.animationWidthFactor,
        @required this.animationHeightFactor,
        @required this.animationPath,
        @required this.animationName,
        @required this.title,
        this.address});

  final Function() submitEvent;
  final Function() isLocationCorrectEvent;
  final bool hasButton;
  final Icon buttonIcon;
  final Color buttonColor, backgroundColor;
  final double animationWidthFactor, animationHeightFactor;
  final String animationPath, title, buttonText, animationName;
  final Map<String, dynamic> address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: FractionallySizedBox(
                widthFactor: animationWidthFactor,
                heightFactor: animationHeightFactor,
                child: FlareActor.asset(
                  AssetFlare(bundle: rootBundle, name: animationPath),
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: animationName,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: Utils.getPercentValueFromScreenWidth(5, context),
              ),
            ),
            Text(
              '${address['Street']}, ${address['Number']}\n${address['County'].toString().replaceAll('Județul ', '')}, ${address['Locality']}',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Utils.getPercentValueFromScreenWidth(7, context)),
            ),
            const SizedBox(
              height: 30,
            ),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                RoundRectangleButton(
                  onPressed: submitEvent,
                  label: 'I will complete it manually',
                  icon: const Icon(MdiIcons.pencil),
                ),
                RoundRectangleButton(
                  onPressed: isLocationCorrectEvent,
                  label: 'This is correct',
                  icon: const Icon(MdiIcons.check),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
