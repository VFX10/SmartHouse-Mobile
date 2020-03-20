import 'package:Homey/data/devices_states/add_device_state.dart';
import 'package:Homey/data/models/devices_models/add_device_model.dart';
import 'package:Homey/data/on_result_callback.dart';
import 'package:Homey/design/colors.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/textfield.dart';
import 'package:Homey/helpers/data_types.dart';
import 'package:Homey/helpers/forms_helpers/form_validations.dart';
import 'package:Homey/helpers/forms_helpers/forms_helpers.dart';
import 'package:Homey/helpers/sql_helper/data_models/sensor_model.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DeviceConfig extends StatelessWidget {
  DeviceConfig({@required this.state, this.event}) : super();
  final Function event;
  final AddDeviceState state;

  final TextEditingController portController = TextEditingController(),
      serverController = TextEditingController(),
      sensorNameController = TextEditingController(),
      readingFrequencyController = TextEditingController();
  final FocusNode portFocus = FocusNode(),
      serverFocus = FocusNode(),
      sensorNameFocus = FocusNode(),
      readingFrequencyFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    sensorNameController.text = state.deviceConfig.sensor.name;
    readingFrequencyController.text =
        state.deviceConfig.sensor.readingFrequency.toString();
    state.deviceConfigAutoValidate = false;
    return Center(
      key: _keyLoader,
      child: SingleChildScrollView(
        child: StreamBuilder<bool>(
            stream: state.deviceFormStream$,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return Form(
                key: _formKey,
                autovalidate: state.deviceConfigAutoValidate,
                child: Container(
                  width: Utils.getPercentValueFromScreenWidth(100, context),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                          state.deviceConfig.sensor.sensorType != null
                              ? DataTypes.sensorsType[
                                  state.deviceConfig.sensor.sensorType]['icon']
                              : MdiIcons.help,
                          size: 40),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        state.deviceConfig.sensor.sensorType != null
                            ? DataTypes
                                    .sensorsType[state.deviceConfig.sensor.sensorType]
                                ['text']
                            : DataTypes.sensorsType[0]['text'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 30),
                      ),
                      CustomTextField(
                        inputType: TextInputType.text,
                        icon: Icon(MdiIcons.text),
                        controller: sensorNameController,
                        focusNode: sensorNameFocus,
                        validator: FormValidation.simpleValidator,
                        suffix: IconButton(
                          onPressed: () {
                            FormHelpers.clearField(sensorNameController);
                          },
                          icon: Icon(
                            Icons.clear,
                          ),
                        ),
                        placeholder: 'Sensor name',
                      ),
                      CustomTextField(
                        inputType: TextInputType.number,
                        icon: Icon(MdiIcons.clockOutline),
                        controller: readingFrequencyController,
                        placeholder: 'Reading frequency',
                        focusNode: readingFrequencyFocus,
                        validator: FormValidation.simpleValidator,
                        suffix: IconButton(
                          onPressed: () {
                            FormHelpers.clearField(readingFrequencyController);
                          },
                          icon: Icon(Icons.clear),
                        ),
                        onSubmitted: saveConfig,
                      ),
                      CustomTextField(
                        inputType: TextInputType.url,
                        icon: Icon(MdiIcons.server),
                        placeholder: 'Server',
                        focusNode: serverFocus,
                        controller: serverController,
                        validator: FormValidation.simpleValidator,
                        suffix: IconButton(
                          onPressed: () {
                            FormHelpers.clearField(serverController);
                          },
                          icon: Icon(Icons.clear),
                        ),
                        onSubmitted: () {
                          FormHelpers.fieldFocusChange(
                              context, serverFocus, portFocus);
                        },
                      ),
                      CustomTextField(
                        inputType: TextInputType.number,
                        icon: Icon(MdiIcons.numeric),
                        placeholder: 'Port',
                        validator: FormValidation.simpleValidator,
                        controller: portController,
                        focusNode: portFocus,
                        suffix: IconButton(
                          onPressed: () {
                            FormHelpers.clearField(portController);
                          },
                          icon: Icon(Icons.clear),
                        ),
                        onSubmitted: saveConfig,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      FloatingActionButton.extended(
                        heroTag: '1',
                        onPressed: saveConfig,
                        icon: Icon(Icons.check),
                        backgroundColor: ColorsTheme.primary,
                        label: const Text('Select room'),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  void onResult(dynamic data, ResultState resultState) {
    switch (resultState) {
      case ResultState.error:
        if (Navigator.canPop(_keyLoader.currentContext)) {
          Navigator.pop(_keyLoader.currentContext);
        }
        Dialogs.showSimpleDialog('Error', data, _keyLoader.currentContext);
        break;
      case ResultState.successful:
        if (Navigator.canPop(_keyLoader.currentContext)) {
          Navigator.pop(_keyLoader.currentContext);
        }
        event();
        break;
      case ResultState.loading:
        Dialogs.showProgressDialog(data, _keyLoader.currentContext);
        break;
    }
  }

  void saveConfig() {
    FocusScope.of(_keyLoader.currentContext).unfocus();

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      state.saveDeviceConfiguration(
        model: AddDeviceModel(
          server: serverController.text,
          port: int.parse(portController.text),
          sensor: SensorModel(
              name: sensorNameController.text,
              readingFrequency: int.parse(readingFrequencyController.text)),
          onResult: onResult,
        ),
      );
    } else {
      state.deviceConfigAutoValidate = true;
    }
  }


}
