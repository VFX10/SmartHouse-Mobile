import 'package:Homey/data/devices_states/add_device_state.dart';
import 'package:Homey/data/models/devices_models/network_config_model.dart';
import 'package:Homey/data/devices_states/network_status_state.dart';
import 'package:Homey/data/on_result_callback.dart';
import 'package:Homey/design/dialogs.dart';
import 'package:Homey/design/widgets/buttons/round_rectangle_button.dart';
import 'package:Homey/helpers/forms_helpers/form_validations.dart';
import 'package:Homey/helpers/utils.dart';
import 'package:Homey/main.dart';
import 'package:connectivity/connectivity.dart';
import 'package:Homey/design/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flare_flutter/provider/asset_flare.dart';

import 'package:flare_flutter/flare_actor.dart';

class EspTouchConfigPage extends StatelessWidget {
  EspTouchConfigPage({@required this.state, @required this.event});

  final Function event;
  final AddDeviceState state;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController _networkSSIDController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  final NetworkStatusState _networkState = getIt.get<NetworkStatusState>();

  void onResult(dynamic data, ResultState resultState) {
    if (data is NetworkConfigModel) {
      _networkSSIDController.text = data.networkSSID;
      state.networkConfig = data;
    } else if (data is String) {
      switch (resultState) {
        case ResultState.successful:
          if (Navigator.canPop(_keyLoader.currentContext)) {
            Navigator.pop(_keyLoader.currentContext);
          }
          event();
          break;
        case ResultState.error:
            if (Navigator.canPop(_keyLoader.currentContext)) {
              Navigator.pop(_keyLoader.currentContext);
            }
          Dialogs.showSimpleDialog('Error', data, _keyLoader.currentContext);
          break;
        case ResultState.loading:
          Dialogs.showProgressDialog(data, _keyLoader.currentContext);
          break;
      }
    }
  }

  void startConfiguration() {
    FocusScope.of(_keyLoader.currentContext).unfocus();
    if (_formKey.currentState.validate()) {
      state.startESPTouchConfiguration(
          networkConfigModel: NetworkConfigModel(
              networkSSID: state.networkConfig.networkSSID,
              networkBSSID: state.networkConfig.networkBSSID,
              networkPassword: passwordController.text,
              onResult: onResult));
    } else {
      state.networkConfigAutoValidate = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _networkState.getNetworkInfo(onResult: onResult);
    state.networkConfigAutoValidate = false;
    return StreamBuilder<ConnectivityResult>(
      key: _keyLoader,
      stream: _networkState.connectionTypeStream$,
      builder:
          (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _networkState.connectionType != ConnectivityResult.wifi
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[

                              Container(
                                width: Utils.getPercentValueFromScreenWidth(70, context),
                                height: Utils.getPercentValueFromScreenHeight(30, context),
                                child: FlareActor.asset(
                                  AssetFlare(bundle: rootBundle, name: 'assets/flare/no_wifi.flr'),
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                  animation: 'init',
                                ),
                              ),
                            
                            const Text(
                              'You have to be connected to a 2G WiFi network',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : StreamBuilder<bool>(
                      stream: state.networkFormStream$,
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return Form(
                          autovalidate: state.networkConfigAutoValidate,
                          key: _formKey,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Icon(
                                  MdiIcons.wifi,
                                  size: 80,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Make sure you are connected to a 2G WiFi network',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  inputType: TextInputType.text,
                                  enabled: false,
                                  icon: const Icon(MdiIcons.routerWireless),
                                  controller: _networkSSIDController,
                                  placeholder: 'SSID',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                StreamBuilder<bool>(
                                  stream: state.networkConfigPasswordStream$,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snapshot) {
                                    return CustomTextField(
                                      inputType: TextInputType.text,
                                      isPassword: state.networkConfigPassword,
                                      icon: const Icon(MdiIcons.lockOutline),
                                      validator: FormValidation.simpleValidator,
                                      controller: passwordController,
                                      onSubmitted: startConfiguration,
                                      suffix: IconButton(
                                        onPressed:
                                            state.toggleNetworkConfigAPassword,
                                        icon: Icon(
                                          state.networkConfigPassword
                                              ? MdiIcons.eyeOffOutline
                                              : MdiIcons.eyeOutline,
                                        ),
                                      ),
                                      placeholder: 'Password',
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RoundRectangleButton(
                                  onPressed: startConfiguration,
                                  icon: const Icon(MdiIcons.check),
                                  label: 'Start Config',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}
