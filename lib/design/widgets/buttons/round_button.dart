import 'package:Homey/design/colors.dart';
import 'package:flutter/material.dart';
import 'package:Homey/helpers/utils.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {this.widthFactor = 11,
      this.heightFactor = 11,
      this.icon,
      this.backgroundColor = Colors.white,
        this.padding = const EdgeInsets.all(12),
      @required this.onPressed});

  final int widthFactor, heightFactor;
  final Icon icon;
  final Function onPressed;
  final Color backgroundColor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        elevation: 16.0,
        color: backgroundColor,// button color
        child: InkWell(

          splashColor: ColorsTheme.backgroundDarker,
          onTap: onPressed, // inkwell color
          child: Container(
            padding: padding,
            child: icon,
          ),
        ),
      ),
    );
    return RawMaterialButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(0),
      child: icon,
    );
    return SizedBox(
      width: Utils.getPercentValueFromScreenWidth(widthFactor, context),
      height: Utils.getPercentValueFromScreenWidth(heightFactor, context),
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: RawMaterialButton(
          onPressed: onPressed,
          shape: const CircleBorder(),
          elevation: 4,
          fillColor: backgroundColor,
          child: icon,
        ),
      ),
    );
  }
}
