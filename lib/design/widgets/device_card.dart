import 'package:Homey/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:Homey/design/colors.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard(
      {@required this.icon,
      @required this.onPressed,
      @required this.label,
      this.isOnline = false,
      this.isCategory = true})
      : super();
  final IconData icon;
  final String label;
  final Function onPressed;
  final bool isCategory;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    if (isCategory) {
      return Padding(
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
                  child: InkWell(
                    onTap: onPressed,
                    splashColor: ColorsTheme.backgroundDarker,
                    child: Center(
                      child: Icon(icon),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFFA5AEBB),
                  ),
                )),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.5),
      child: FractionallySizedBox(
        heightFactor: 1,
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Card(
            elevation: 10,
            color: Colors.white,
            child: InkWell(
              onTap: onPressed,
              splashColor: ColorsTheme.backgroundDarker,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        icon,
                        color: ColorsTheme.backgroundDarker,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: ClipOval(
                        child: Container(
                          width: 8,
                          height: 8,
                          color: isOnline ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(

                            color: ColorsTheme.backgroundDarker,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
