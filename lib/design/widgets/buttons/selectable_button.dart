
import 'package:Homey/design/colors.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:flutter/material.dart';

class SelectableButton extends StatelessWidget {
  const SelectableButton({@required this.onPressed, @required this.text, this.selected = false});

  final Function onPressed;
  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(16),
      splashColor: Colors.transparent,
      child: TweenAnimationBuilder<Color>(
        duration: const Duration(milliseconds: 500),
        tween: selected ? ColorTween(begin: const Color(0xff68737d), end: ColorsTheme.accent) : ColorTween(begin: ColorsTheme.accent, end: const Color(0xff68737d)),
        builder: (_, Color color, Widget widget) {
          return ColorFiltered(
            colorFilter: ColorFilter.mode(color, BlendMode.modulate),
            child: widget,
          );
        },
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: Utils.getPercentValueFromScreenWidth(4, context), fontFamily: 'Montserrat',
              fontWeight: FontWeight.w300),
        ),
      )
    );
  }
}
