import 'package:Homey/data/add_house_state.dart';
import 'package:Homey/design/widgets/buttons/round_rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Homey/design/colors.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:Homey/design/widgets/textfield.dart';
import 'package:Homey/helpers/forms_helpers/form_validations.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FirstPage extends StatelessWidget {
  FirstPage(
      {@required this.submitEvent,
      this.buttonIcon,
      final this.buttonText = '',
      this.buttonColor = Colors.green,
      this.backgroundColor = ColorsTheme.background,
      this.hasButton = true,
      @required this.animationWidthFactor,
      @required this.animationHeightFactor,
      @required this.animationPath,
      @required this.animationName,
      @required this.title,
      @required this.state,
      this.description = ''});

  final Function() submitEvent;
  final bool hasButton;
  final Icon buttonIcon;
  final Color buttonColor, backgroundColor;
  final double animationWidthFactor, animationHeightFactor;
  final String animationPath, title, description, buttonText, animationName;
  final AddHouseState state;
  final TextEditingController homeNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
//    final HouseDataState hds = HouseDataState();
    state.autoValidate = false;
    return StreamBuilder<bool>(
        stream: state.autoValidateStream$,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Form(
            key: _formKey,
            autovalidate: state.autoValidate,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (MediaQuery.of(context).viewInsets.bottom == 0)
                    Flexible(
                      child: FractionallySizedBox(
                        widthFactor: animationWidthFactor,
                        heightFactor: animationHeightFactor,
                        child: FlareActor.asset(
                          AssetFlare(
                              bundle: rootBundle, name: animationPath),
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          animation: animationName,
                        ),
                      ),
                    ),
                  const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          Utils.getPercentValueFromScreenWidth(8, context),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize:
                            Utils.getPercentValueFromScreenWidth(5, context)),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                  CustomTextField(
                    inputType: TextInputType.text,
                    icon: const Icon(MdiIcons.home),
                    controller: homeNameController,
                    validator: FormValidation.simpleValidator,
                    placeholder: 'Home name',
                    onSubmitted: () {
                      if (_formKey.currentState.validate()) {
                        FocusScope.of(context).unfocus();
                        state.houseName = homeNameController.text;
                        submitEvent();
                      } else {
                        state.autoValidate = true;
                      }
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                  if (hasButton)
                    Center(
                      child: RoundRectangleButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            FocusScope.of(context).unfocus();
                            state.houseName = homeNameController.text;
                            submitEvent();
                          } else {
                            state.autoValidate = true;
                          }
                        },
                        label: buttonText,
                        icon: buttonIcon,
                      ),
                    ),
                ],
              ),
            ),
          );
        });
  }
}
