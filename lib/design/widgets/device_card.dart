import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smart_home_mobile/design/colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DeviceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onPressed;

  DeviceCard({@required this.icon, @required this.onPressed, this.label})
      : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.5),
        child: Column(
          children: <Widget>[
            Expanded(
        flex: 3,
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Card(
                  elevation: 10,
                  color: ColorsTheme.backgroundCard,
                  child: Center(child: Icon(this.icon)),
                ),
              ),
            ),
            Expanded(flex: 1, child: Text(this.label, style: TextStyle(color: Color(0xFFA5AEBB)),)),
          ],
        ),
      ),
    );
  }
}
