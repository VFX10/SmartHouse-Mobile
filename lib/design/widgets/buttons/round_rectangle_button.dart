import 'package:flutter/material.dart';

import '../../colors.dart';

class RoundRectangleButton extends StatelessWidget {
  const RoundRectangleButton({@required this.onPressed, this.label, this.icon})
      : super();
  final Function onPressed;
  final String label;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 10,
      onPressed: onPressed,
      fillColor: ColorsTheme.primary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: icon,
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ]),
      ),
    );
  }
}
