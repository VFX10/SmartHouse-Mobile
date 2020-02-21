import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home_mobile/design/colors.dart';
import 'package:smart_home_mobile/helpers/utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flare_flutter/flare_controller.dart';


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
  Map<String, dynamic> address;

  _LocationReceivedPageState createState() => _LocationReceivedPageState();
}

class _LocationReceivedPageState extends State<LocationReceivedPage>
    with SingleTickerProviderStateMixin {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

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
        body: Container(
          padding: new EdgeInsets.all(16.0),
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
              Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
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
                    fontSize: Utils.getPercentValueFromScreenWidth(8, context)),
              ),
              Padding(padding: EdgeInsets.only(top: 10, bottom: 20)),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  RawMaterialButton(
                    elevation: 20,
                    onPressed: widget.submitEvent,
                    fillColor: ColorsTheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                      child:
                      Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Padding(
                            child: Icon(MdiIcons.pencil),
                            padding: EdgeInsets.only(right: 10.0)),
                        Text(
                          'I will complete it manually',
                          style: TextStyle(color: Colors.white),
                        ),
                      ]),
                    ),
                  ),
                  RawMaterialButton(
                    elevation: 20,
                    onPressed: widget.isLocationCorrectEvent,
                    fillColor: ColorsTheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                      child:
                      Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Padding(
                            child: Icon(MdiIcons.check),
                            padding: EdgeInsets.only(right: 10.0)),
                        Text(
                          'This is correct',
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
//      bottomNavigationBar: Container(
//        color: ColorsTheme.background,
//        padding: EdgeInsets.all(16),
//        child: Column(
//          mainAxisSize: MainAxisSize.min,
//          mainAxisAlignment: MainAxisAlignment.start,
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          children: <Widget>[
//            Text(
//              '${widget.address['Street']}, ${widget.address['Number']}\n${widget.address['County'].toString().replaceAll('Județul ', '')}, ${widget.address['Locality']}',
//              textAlign: TextAlign.start,
//              style: TextStyle(
//                  fontWeight: FontWeight.bold,
//                  fontSize: Utils.getPercentValueFromScreenWidth(8, context)),
//            ),
//            Padding(padding: EdgeInsets.only(top: 10, bottom: 20)),
//            Wrap(
//              alignment: WrapAlignment.spaceBetween,
//              spacing: 10,
//              runSpacing: 10,
//              children: <Widget>[
//                RawMaterialButton(
//                  elevation: 20,
//                  onPressed: widget.submitEvent,
//                  fillColor: ColorsTheme.primary,
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(25))),
//                  child: Container(
//                    padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
//                    child:
//                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
//                      Padding(
//                          child: Icon(MdiIcons.pencil),
//                          padding: EdgeInsets.only(right: 10.0)),
//                      Text(
//                        'I will complete it manually',
//                        style: TextStyle(color: Colors.white),
//                      ),
//                    ]),
//                  ),
//                ),
//                RawMaterialButton(
//                  elevation: 20,
//                  onPressed: widget.isLocationCorrectEvent,
//                  fillColor: ColorsTheme.primary,
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(25))),
//                  child: Container(
//                    padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
//                    child:
//                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
//                      Padding(
//                          child: Icon(MdiIcons.check),
//                          padding: EdgeInsets.only(right: 10.0)),
//                      Text(
//                        'This is correct',
//                        style: TextStyle(color: Colors.white),
//                      ),
//                    ]),
//                  ),
//                ),
//              ],
//            ),
//          ],
//        ),
//      ),
      ),
    );
  }
}
