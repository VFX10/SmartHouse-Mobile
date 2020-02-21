import 'package:flutter/material.dart';

class AnimationListSecondaryItem extends StatelessWidget {
  AnimationListSecondaryItem(this.title) : super();
  final String title;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title.toString(),
        textDirection: TextDirection.ltr,
        style: TextStyle(color: Color(0xFF2E1E7A), fontWeight: FontWeight.bold),
      ),
    );
  }
}
