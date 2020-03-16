import 'package:flutter/material.dart';
import 'package:Homey/helpers/utils.dart';

class RoundButton extends StatelessWidget {
  RoundButton(
      {this.widthFactor = 11,
      this.heightFactor = 11,
      this.icon,
      this.backgroundColor = Colors.white,
      @required this.onPressed});

  final int widthFactor, heightFactor;
  final Icon icon;
  final Function onPressed;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Utils.getPercentValueFromScreenWidth(this.widthFactor, context),
      height: Utils.getPercentValueFromScreenWidth(this.heightFactor, context),
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: RawMaterialButton(
          onPressed: this.onPressed,
          shape: CircleBorder(),
          elevation: 4,
          fillColor: this.backgroundColor,
          child: this.icon,
        ),
      ),
    );
  }
}
