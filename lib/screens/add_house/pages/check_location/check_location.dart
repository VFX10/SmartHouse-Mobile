import 'dart:developer';
import 'dart:io';

import 'package:Homey/data/add_house_state.dart';
import 'package:Homey/screens/add_house/pages/first_setup_template/first_setup_template_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'location_form_page.dart';
import 'location_received.dart';

class CheckLocation extends StatefulWidget {
  const CheckLocation(
      {Key key,
      @required this.submitEvent,
      this.location = false,
      @required this.state})
      : super(key: key);
  final Function() submitEvent;
  final bool location;
  final AddHouseState state;

  @override
  _CheckLocationState createState() => _CheckLocationState();
}

class _CheckLocationState extends State<CheckLocation>
    with SingleTickerProviderStateMixin {
  _CheckLocationState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Position _currentPosition;
  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<List<Placemark>> getPlaceMark() async {
    final GeolocationStatus permission =
        await Geolocator().checkGeolocationPermissionStatus();
    if (permission == GeolocationStatus.denied) {
      await _permissionHandler.requestPermissions(<PermissionGroup>[
        PermissionGroup.location,
        PermissionGroup.locationAlways,
        PermissionGroup.locationWhenInUse,
      ]);
      if (await _permissionHandler
                  .checkPermissionStatus(PermissionGroup.locationWhenInUse) ==
              PermissionStatus.denied ||
          await _permissionHandler
                  .checkPermissionStatus(PermissionGroup.locationAlways) ==
              PermissionStatus.denied ||
          await _permissionHandler
                  .checkPermissionStatus(PermissionGroup.location) ==
              PermissionStatus.denied) {
        throw ArgumentError('Location permissions denied');
      }
    } else {
      _currentPosition = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      return Geolocator().placemarkFromPosition(_currentPosition);
    }
    throw ArgumentError('Unknown error has occured');
  }

  bool location = true;

  AnimationController _controller;
  Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    log('wlocation', error: widget.location);
    log('location', error: location);
    _controller.reset();
    // ignore: cascade_invocations
    _controller.forward();
    if (widget.location && location) {
      return FadeTransition(
        opacity: _animation,
        child: FutureBuilder<List<Placemark>>(
            future: Future.wait<List<Placemark>>(
                    <Future<List<Placemark>>>[getPlaceMark()])
                .then((List<List<Placemark>> response) => response[0]),
            builder: (BuildContext context,
                AsyncSnapshot<List<Placemark>> placeMark) {
              if (placeMark.connectionState == ConnectionState.waiting ||
                  placeMark.connectionState == ConnectionState.none) {
                return FirstSetupTemplatePage(
                    title: 'Please wait',
                    description: 'We are trying to get your location for you',
                    animationPath: 'assets/flare/search_location.flr',
                    animationName: 'search_location',
                    submitEvent: widget.submitEvent,
                    hasButton: false,
                    animationWidthFactor: 0.5,
                    animationHeightFactor: 0.3);
              } else {
                if (placeMark.hasData) {
                  final Map<String, dynamic> geolocation = <String, dynamic>{
                    'Country': placeMark.data[0].country,
                    'CountryCode': placeMark.data[0].isoCountryCode,
                    'County': placeMark.data[0].administrativeArea,
                    'Locality': placeMark.data[0].locality,
                    'Street': placeMark.data[0].thoroughfare,
                    'Number': placeMark.data[0].subThoroughfare,
                    'Position': placeMark.data[0].position
                  };
                  widget.state.geolocation = geolocation;
                  log(placeMark.data[0].toJson().toString());

                  return LocationReceivedPage(
                      title: '',
                      address: geolocation,
                      animationPath: 'assets/flare/search_location.flr',
                      animationName: 'search_location',
                      submitEvent: () {
                        setState(() {
                          location = false;
                        });
                      },
                      isLocationCorrectEvent: widget.submitEvent,
                      buttonIcon: Platform.isAndroid
                          ? const Icon(Icons.arrow_forward)
                          : const Icon(Icons.arrow_forward_ios),
                      hasButton: false,
                      animationWidthFactor: 0.5,
                      animationHeightFactor: 0.4);
                } else {
                  return FirstSetupTemplatePage(
                      title: 'We are sorry',
                      description: placeMark.error.toString(),
                      animationPath: 'assets/flare/search_location.flr',
                      animationName: 'search_location',
                      submitEvent: () {
                        setState(() {
                          location = false;
                        });
                      },
                      buttonIcon: Platform.isAndroid
                          ? const Icon(Icons.arrow_forward)
                          : const Icon(Icons.arrow_forward_ios),
                      buttonText: 'Enter address manually',
                      animationWidthFactor: 0.5,
                      animationHeightFactor: 0.3);
                }
              }
            }),
      );
    } else {
      return FadeTransition(
        opacity: _animation,
        child: LocationFormPage(
          state: widget.state,
          autoDetectEvent: () {
            setState(() => location = true);
          },
          submit: widget.submitEvent,
        ),
      );
    }
  }
}
