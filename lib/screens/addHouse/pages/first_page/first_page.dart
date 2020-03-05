import 'dart:developer';

import 'package:Homey/design/widgets/buttons/roundRectangleButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Homey/design/colors.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:Homey/design/widgets/textfield.dart';
import 'package:Homey/helpers/forms_helpers/form_validations.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Homey/screens/addHouse/dataModelManager.dart';

class FirstPage extends StatefulWidget {
  FirstPage(
      {@required this.submitEvent,
      this.buttonIcon,
      final this.buttonText = '',
      this.buttonColor = Colors.green,
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
  final String animationPath, title, description, buttonText, animationName;

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController homeNameController = new TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    homeNameController.dispose();
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

  final _formKey = GlobalKey<FormState>();
  bool autoValidate = false;

  @override
  Widget build(BuildContext context) {
    HouseDataState hds = HouseDataState();
    _controller.forward();
    log(MediaQuery.of(context).viewInsets.bottom.toString());
    return FadeTransition(
      opacity: _animation,
      child: Form(
        key: _formKey,
        autovalidate: autoValidate,
        child: Container(
          padding: new EdgeInsets.all(16.0),
          color: widget.backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (MediaQuery.of(context).viewInsets.bottom == 0)
                Flexible(
                  child: FractionallySizedBox(
                    widthFactor: widget.animationWidthFactor,
                    heightFactor: widget.animationHeightFactor,
                    child: FlareActor.asset(
                      AssetFlare(
                          bundle: rootBundle, name: widget.animationPath),
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
              CustomTextField(
                inputType: TextInputType.text,
                icon: Icon(MdiIcons.home),
                controller: homeNameController,
                validator: (value) => FormValidation.simpleValidator(value),
                placeholder: "Home name",
                onSubmitted: () {
                  if (_formKey.currentState.validate()) {
                    FocusScope.of(context).unfocus();
                    hds.homeName = homeNameController.text;
                    widget.submitEvent();
                  } else {
                    setState(() {
                      autoValidate = true;
                    });
                  }
                },
              ),
              Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
              if (widget.hasButton)
                Center(
                    child: RoundMaterialButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      FocusScope.of(context).unfocus();
                      hds.homeName = homeNameController.text;
                      widget.submitEvent();
                    } else {
                      setState(() {
                        autoValidate = true;
                      });
                    }
                  },
                  label: widget.buttonText,
                      icon: widget.buttonIcon,
                )
//                  child: FloatingActionButton.extended(
//                    elevation: 20,
//                    onPressed: ,
//                    tooltip: widget.buttonText,
//                    backgroundColor: widget.buttonColor,
//                    icon: widget.buttonIcon,
//                    label: Text(widget.buttonText),
//                  ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
