import 'package:flutter/material.dart';
import 'package:Homey/design/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {@required this.text, @required this.onPressed, this.isSecondary = false})
      : super();
  final String text;
  final Function onPressed;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        side: isSecondary
            ? const BorderSide(color: ColorsTheme.primary, width: 2)
            : BorderSide.none,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      color: isSecondary ? ColorsTheme.background : ColorsTheme.primary,
      textColor: Colors.white,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      padding: const EdgeInsets.all(10.0),
      splashColor: ColorsTheme.accent,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
