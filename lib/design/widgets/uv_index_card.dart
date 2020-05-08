import 'package:Homey/design/colors.dart';
import 'package:Homey/helpers/data_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';


enum UVIndex { low, medium, high, veryHigh, extreme }

class UVIndexCard extends StatelessWidget {
  const UVIndexCard({@required this.uvLevel, this.selected = false});

  final bool selected;
  final UVIndex uvLevel;

  @override
  Widget build(BuildContext context) {
    final double selectedAnimationMargin =
        -(MediaQuery.of(context).size.width / 3.5 - 10) -
            (MediaQuery.of(context).size.width / 3.5 - 10) / 2;
    final double animationMargin =
    -(MediaQuery.of(context).size.width / 3.5 - 10);
    return AnimationConfiguration.staggeredList(
      position: uvLevel.index,
      duration: const Duration(milliseconds: 700),
      delay: const Duration(milliseconds: 100),
      child: FadeInAnimation(
        child: SlideAnimation(
          horizontalOffset:
          selected ? selectedAnimationMargin : animationMargin,
          child: Transform.translate(
            offset: selected ? const Offset(45, 0) : const Offset(0, 0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 4 - 10),
              child: AspectRatio(
                aspectRatio: 1,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: selected
                      ? DataTypes.uvLevelsText[uvLevel.index]['selectedColor']
                      : ColorsTheme.backgroundCard,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                DataTypes.uvLevelsText[uvLevel.index]['label'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textScaleFactor: 1.1,
                                style: GoogleFonts.getFont(
                                  'Montserrat',
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: selected
                                        ? DataTypes.uvLevelsText[uvLevel.index]
                                    ['color']
                                        : ColorsTheme.textColor,
                                  ),
                                ),
                              ),
                              Text(
                                DataTypes.uvLevelsText[uvLevel.index]['text'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textScaleFactor: 0.8,
                                style: GoogleFonts.getFont(
                                  'Montserrat',
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: selected
                                        ? DataTypes.uvLevelsText[uvLevel.index]
                                    ['color']
                                        : ColorsTheme.textColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: ShapeDecoration(
                              shape: const CircleBorder(),
                              color: selected
                                  ? DataTypes.uvLevelsText[uvLevel.index]
                              ['color']
                                  : DataTypes.uvLevelsText[uvLevel.index]
                              ['dotColor'],
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
        ),
      ),
    );
  }
}