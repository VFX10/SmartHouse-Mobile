import 'package:Homey/design/widgets/buttons/roundRectangleButton.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LocationReceivedPage extends StatefulWidget {
  LocationReceivedPage(
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

  _LocationReceivedPageState createState() => _LocationReceivedPageState();
}

class _LocationReceivedPageState extends State<LocationReceivedPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  _LocationReceivedPageState() {
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
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
      child: Scaffold(
        body: Container(
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
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: Utils.getPercentValueFromScreenWidth(5, context),
                ),
              ),
              Text(
                '${widget.address['Street']}, ${widget.address['Number']}\n${widget.address['County'].toString().replaceAll('Județul ', '')}, ${widget.address['Locality']}',
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
                  RoundMaterialButton(
                    onPressed: widget.submitEvent,
                    label: 'I will complete it manually',
                    icon: Icon(MdiIcons.pencil),
                  ),
                  RoundMaterialButton(
                    onPressed: widget.isLocationCorrectEvent,
                    label: 'This is correct',
                    icon: Icon(MdiIcons.check),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
