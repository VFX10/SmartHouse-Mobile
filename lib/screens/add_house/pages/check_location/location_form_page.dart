
import 'package:Homey/data/add_house_state.dart';
import 'package:Homey/design/widgets/buttons/round_rectangle_button.dart';
import 'package:flutter/material.dart';
import 'package:Homey/design/colors.dart';

import 'package:Homey/design/widgets/textfield.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Homey/helpers/forms_helpers/form_validations.dart';
import 'package:Homey/helpers/forms_helpers/forms_helpers.dart';

class LocationFormPage extends StatelessWidget {
  LocationFormPage(
      {@required this.autoDetectEvent,
      @required this.submit,
      @required this.state});

  final Function() autoDetectEvent;
  final Function() submit;
  final AddHouseState state;

  final TextEditingController countryController = TextEditingController(),
      countyController = TextEditingController(),
      localityController = TextEditingController(),
      streetController = TextEditingController(),
      numberController = TextEditingController();
  final FocusNode countryFocusNode = FocusNode(),
      countyFocusNode = FocusNode(),
      localityFocusNode = FocusNode(),
      streetFocusNode = FocusNode(),
      numberFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void finish() {
    if (_formKey.currentState.validate()) {
      state.geolocation = <String, dynamic>{
        'Country': countryController.text,
        'County': countyController.text,
        'Locality': localityController.text,
        'Street': streetController.text,
        'Number': numberController.text,
      };
      submit();
    } else {
      state.locationFormAutoValidate = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    countryController.text = state.geolocation['Country'];
    countyController.text =
        state.geolocation['County'].toString().replaceAll('Județul ', '');
    localityController.text = state.geolocation['Locality'];
    streetController.text = state.geolocation['Street'];
    numberController.text = state.geolocation['Number'];
    return Scaffold(
      backgroundColor: ColorsTheme.background,
      body: Builder(
        builder: (BuildContext context) => Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              child: StreamBuilder<bool>(
                  stream: state.locationFormAutoValidateStream$,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return Form(
                        key: _formKey,
                        autovalidate: state.locationFormAutoValidate,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            CustomTextField(
                              inputType: TextInputType.text,
                              icon: const Icon(MdiIcons.map),
                              controller: countryController,
                              placeholder: 'Country',
                              validator: FormValidation.simpleValidator,
                              focusNode: countryFocusNode,
                              onSubmitted: () => FormHelpers.fieldFocusChange(
                                  context, countryFocusNode, countyFocusNode),
                            ),
                            CustomTextField(
                              inputType: TextInputType.text,
                              icon: const Icon(MdiIcons.mapMarker),
                              controller: countyController,
                              placeholder: 'County',
                              validator: FormValidation.simpleValidator,
                              focusNode: countyFocusNode,
                              onSubmitted: () => FormHelpers.fieldFocusChange(
                                  context, countyFocusNode, localityFocusNode),
                            ),
                            CustomTextField(
                              inputType: TextInputType.text,
                              icon: const Icon(MdiIcons.homeCity),
                              controller: localityController,
                              placeholder: 'Locality',
                              validator: FormValidation.simpleValidator,
                              focusNode: localityFocusNode,
                              onSubmitted: () => FormHelpers.fieldFocusChange(
                                  context, localityFocusNode, streetFocusNode),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: CustomTextField(
                                    icon: const Icon(MdiIcons.account),
                                    controller: streetController,
                                    placeholder: 'Street',
                                    validator: FormValidation.simpleValidator,
                                    focusNode: streetFocusNode,
                                    onSubmitted: () =>
                                        FormHelpers.fieldFocusChange(context,
                                            streetFocusNode, numberFocusNode),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: CustomTextField(
                                    icon: const Icon(MdiIcons.numeric),
                                    controller: numberController,
                                    placeholder: 'Number',
                                    validator: FormValidation.simpleValidator,
                                    focusNode: numberFocusNode,
                                    onSubmitted: finish,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 10,
                              runSpacing: 10,
                              children: <Widget>[
                                RoundRectangleButton(
                                  onPressed: autoDetectEvent,
                                  label: 'Auto detect location',
                                  icon: const Icon(MdiIcons.crosshairsGps),
                                ),
                                RoundRectangleButton(
                                  onPressed: finish,
                                  label: 'Add your house',
                                  icon: const Icon(MdiIcons.check),
                                ),
                              ],
                            ),
                          ],
                        ));
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
