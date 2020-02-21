import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_home_mobile/design/colors.dart';
import 'package:smart_home_mobile/helpers/utils.dart';
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
      child: Container(
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
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Utils.getPercentValueFromScreenWidth(8, context),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Utils.getPercentValueFromScreenWidth(5, context)),
            ),
            Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
            widget.hasButton
                ? Center(
                    child: FloatingActionButton.extended(
                      elevation: 20,
                      onPressed: widget.submitEvent,
                      tooltip: widget.buttonText,
                      backgroundColor: widget.buttonColor,
                      icon: widget.buttonIcon,
                      label: Text(widget.buttonText),
                    ),
                  )
                : Center(),
          ],
        ),
      ),
    );
  }
}
