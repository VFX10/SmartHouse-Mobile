import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:Homey/design/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool isSecondary;

  CustomButton(
      {@required this.text,
        @required this.onPressed,
        this.isSecondary = false})
      : super();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        side: this.isSecondary
            ? BorderSide(color: ColorsTheme.primary, width: 2)
            : BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      color: this.isSecondary ? ColorsTheme.background : ColorsTheme.primary,
      textColor: Colors.white,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      padding: EdgeInsets.all(10.0),
      splashColor: ColorsTheme.accent,
      child: Text(this.text),
      onPressed: this.onPressed,
    );
  }
}
