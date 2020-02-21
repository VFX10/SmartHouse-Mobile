import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home_mobile/design/colors.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:smart_home_mobile/helpers/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flare_flutter/provider/asset_flare.dart';


class GeolocationPage extends StatefulWidget {
  GeolocationPage(
      {@required this.submitEvent,
      this.buttonIcon,
      final this.buttonText = '',
      this.buttonColor = Colors.green,
      this.backgroundColor = ColorsTheme.background,
      this.hasButton = true,
        this.currentLocationEvent,
      @required this.animationWidthFactor,
      @required this.animationHeightFactor,
      @required this.animationPath,
      @required this.animationName,
      @required this.title,
      this.description = ''});

  final Function() submitEvent;
  final Function() currentLocationEvent;
  final bool hasButton;
  final Icon buttonIcon;
  final Color buttonColor, backgroundColor;
  final double animationWidthFactor, animationHeightFactor;
  final String animationPath, title, description, buttonText, animationName;

  @override
  _GeolocationPageState createState() => _GeolocationPageState();
}

class _GeolocationPageState extends State<GeolocationPage>
    with SingleTickerProviderStateMixin {
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    _controller.forward();
    return FadeTransition(
      opacity: _animation,
      child: Scaffold(
        appBar: AppBar(backgroundColor: ColorsTheme.background, elevation: 0),
        backgroundColor: ColorsTheme.background,
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: FractionallySizedBox(
                  widthFactor: widget.animationWidthFactor,
                  heightFactor: widget.animationHeightFactor,
                  child:  FlareActor.asset(
                    AssetFlare(bundle: rootBundle, name: widget.animationPath),
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: widget.animationName,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Utils.getPercentValueFromScreenWidth(8, context),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  RawMaterialButton(
                    elevation: 20,
                    onPressed: widget.currentLocationEvent,
                    fillColor: ColorsTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                child: Icon(MdiIcons.crosshairsGps),
                                padding: EdgeInsets.only(right:10.0)),
                            Text(
                              'Use current location',
                              style: TextStyle(color: Colors.white),
                            ),
                          ]),
                    ),
                  ),
                  RawMaterialButton(
                    elevation: 20,
                    onPressed: widget.submitEvent,
                    fillColor: ColorsTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                child: Icon(MdiIcons.keyboardOutline),
                                padding: EdgeInsets.only(right:10.0)),
                            Text(
                              'Enter home address',
                              style: TextStyle(color: Colors.white),
                            ),
                          ]),
                    ),
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
