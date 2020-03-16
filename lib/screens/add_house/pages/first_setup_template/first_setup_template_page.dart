import 'package:Homey/design/widgets/buttons/roundRectangleButton.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:flare_flutter/provider/asset_flare.dart';

class FirstSetupTemplatePage extends StatefulWidget {
  FirstSetupTemplatePage(
      {@required this.submitEvent,
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

  _FirstSetupTemplatePageState createState() => _FirstSetupTemplatePageState();
}

class _FirstSetupTemplatePageState extends State<FirstSetupTemplatePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  _FirstSetupTemplatePageState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return FadeTransition(
      opacity: _animation,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: widget.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: FractionallySizedBox(
                widthFactor: widget.animationWidthFactor,
                heightFactor: widget.animationHeightFactor,
                child: FlareActor.asset(
                  AssetFlare(bundle: rootBundle, name: widget.animationPath),
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: widget.animationName,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Utils.getPercentValueFromScreenWidth(8, context),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Utils.getPercentValueFromScreenWidth(5, context)),
            ),
            const SizedBox(height: 10),
            if (widget.hasButton)
              Center(
                child: RoundMaterialButton(
                  onPressed: widget.submitEvent,
                  label: widget.buttonText,
                  icon: widget.buttonIcon,
                ),
              )
          ],
        ),
      ),
    );
  }
}
