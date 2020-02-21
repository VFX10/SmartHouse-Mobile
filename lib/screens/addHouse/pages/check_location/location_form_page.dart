import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_home_mobile/design/colors.dart';
import 'package:smart_home_mobile/design/dialogs.dart';
import 'dart:developer';

import 'package:smart_home_mobile/design/widgets/textfield.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_home_mobile/helpers/forms_helpers/form_validations.dart';
import 'package:smart_home_mobile/helpers/forms_helpers/forms_helpers.dart';
import 'package:smart_home_mobile/screens/addHouse/dataModelManager.dart';

class LocationFormPage extends StatefulWidget {
  LocationFormPage({@required this.autoDetectEvent, @required this.submit});
  final Function() autoDetectEvent;
  final Function() submit;
  @override
  _LocationFormPageState createState() => _LocationFormPageState();
}

class _LocationFormPageState extends State<LocationFormPage> {
  @override
  void dispose() {
    super.dispose();
    countryController.dispose();
    countyController.dispose();
    localityController.dispose();
    streetController.dispose();
    numberController.dispose();
  }

  TextEditingController countryController = new TextEditingController(),
      countyController = new TextEditingController(),
      localityController = new TextEditingController(),
      streetController = new TextEditingController(),
      numberController = new TextEditingController();
  final FocusNode countryFocusNode = new FocusNode(),
      countyFocusNode = new FocusNode(),
      localityFocusNode = new FocusNode(),
      streetFocusNode = new FocusNode(),
      numberFocusNode = new FocusNode();
  bool formAutoValidate = false;
  final _formKey = GlobalKey<FormState>();

  void onError(e) {
    log('Error: ', error: e);
    Dialogs.showSimpleDialog("Error", e.toString(), context);
  }
  HouseDataState hds = HouseDataState();
  finish() {
    if(_formKey.currentState.validate()){
      hds.geolocation = {
        'Country': countryController.text,
        'County': countyController.text,
        'Locality': localityController.text,
        'Street': streetController.text,
        'Number': numberController.text,
      };
      widget.submit();
    } else{
      setState(() {
        formAutoValidate = true;
      });
    }

  }

  void cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    if(hds.geolocation.containsKey('Country')){
      countryController.text = hds.geolocation['Country'];
    }
    if(hds.geolocation.containsKey('County')){
      countyController.text = hds.geolocation['County'].toString().replaceAll('Județul ', '');
    }
    if(hds.geolocation.containsKey('Locality')){
      localityController.text = hds.geolocation['Locality'];
    }
    if(hds.geolocation.containsKey('Street')){
      streetController.text = hds.geolocation['Street'];
    }
    if(hds.geolocation.containsKey('Number')){
      numberController.text = hds.geolocation['Number'];
    }
    return Scaffold(
      backgroundColor: ColorsTheme.background,
      body: Builder(
        builder: (context) => Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Form(
                  key: _formKey,
                  autovalidate: formAutoValidate,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      CustomTextField(
                        inputType: TextInputType.text,
                        icon: Icon(MdiIcons.map),
                        controller: countryController,
                        placeholder: "Country",
                        validator: (value) =>
                            FormValidation.simpleValidator(value),
                        focusNode: countryFocusNode,
                        onSubmitted: () => FormHelpers.fieldFocusChange(
                            context, countryFocusNode, countyFocusNode),
                      ),
                      CustomTextField(
                        inputType: TextInputType.text,
                        icon: Icon(MdiIcons.mapMarker),
                        controller: countyController,
                        placeholder: "County",
                        validator: (value) =>
                            FormValidation.simpleValidator(value),
                        focusNode: countyFocusNode,
                        onSubmitted: () => FormHelpers.fieldFocusChange(
                            context, countyFocusNode, localityFocusNode),
                      ),
                      CustomTextField(
                        inputType: TextInputType.text,
                        icon: Icon(MdiIcons.homeCity),
                        controller: localityController,
                        placeholder: "Locality",
                        validator: (value) =>
                            FormValidation.simpleValidator(value),
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
                              icon: Icon(MdiIcons.account),
                              controller: streetController,
                              placeholder: "Street",
                              validator: (value) =>
                                  FormValidation.simpleValidator(value),
                              focusNode: streetFocusNode,
                              onSubmitted: () => FormHelpers.fieldFocusChange(
                                  context,
                                  streetFocusNode,
                                  numberFocusNode),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: CustomTextField(
                              icon: Icon(MdiIcons.numeric),
                              controller: numberController,
                              placeholder: "Number",
                              validator: (value) =>
                                  FormValidation.simpleValidator(value),
                              focusNode: numberFocusNode,
                              onSubmitted: finish,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 10,
                        runSpacing: 10,
                        children: <Widget>[
                          RawMaterialButton(
                            elevation: 20,
                            onPressed: widget.autoDetectEvent,
                            fillColor: ColorsTheme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25))),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                              child:
                              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                Padding(
                                    child: Icon(MdiIcons.crosshairsGps),
                                    padding: EdgeInsets.only(right: 10.0)),
                                Text(
                                  'Auto detect location',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ]),
                            ),
                          ),
                          RawMaterialButton(
                            elevation: 20,
                            onPressed: finish,
                            fillColor: ColorsTheme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25))),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                              child:
                              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                Padding(
                                    child: Icon(MdiIcons.check),
                                    padding: EdgeInsets.only(right: 10.0)),
                                Text(
                                  'Add your house',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
