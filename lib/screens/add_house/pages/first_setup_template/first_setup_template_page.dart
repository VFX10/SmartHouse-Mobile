import 'package:Homey/design/widgets/buttons/round_rectangle_button.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:flare_flutter/provider/asset_flare.dart';

class FirstSetupTemplatePage extends StatelessWidget{
   const FirstSetupTemplatePage(
      {this.submitEvent,
        this.buttonIcon,
        final this.buttonText = '',
        this.buttonColor = ColorsTheme.primary,
        this.backgroundColor = ColorsTheme.background,
        this.hasButton = true,
        @required this.animationWidthFactor,
        @required this.animationHeightFactor,
        @required this.animationPath,
        @required this.animationName,
        @required this.title,
        this.description = ''});

  final Function() submitEvent;
  final bool hasButton;
  final Icon buttonIcon;
  final Color buttonColor, backgroundColor;
  final double animationWidthFactor, animationHeightFactor;
  final String animationPath, title, buttonText, description, animationName;


  @override
  Widget build(BuildContext context) {
    return Container(
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
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Utils.getPercentValueFromScreenWidth(8, context),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: Utils.getPercentValueFromScreenWidth(5, context)),
          ),
          const SizedBox(height: 10),
          if (hasButton)
            Center(
              child: RoundRectangleButton(
                onPressed: submitEvent,
                label: buttonText,
                icon: buttonIcon,
              ),
            )
        ],
      ),
    );
  }
}
