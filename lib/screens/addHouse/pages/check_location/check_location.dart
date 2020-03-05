import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Homey/screens/addHouse/pages/check_location/location_form_page.dart';
import 'package:Homey/screens/addHouse/pages/check_location/location_received.dart';
import 'package:Homey/screens/addHouse/pages/first_setup_template/first_setup_template_page.dart';
import 'package:Homey/screens/addHouse/dataModelManager.dart';

class CheckLocation extends StatefulWidget {
  CheckLocation({Key key, @required this.submitEvent, this.location = false})
      : super(key: key);
  final Function() submitEvent;
  final bool location;

  _CheckLocationState createState() => _CheckLocationState();
}

class _CheckLocationState extends State<CheckLocation>
    with SingleTickerProviderStateMixin {
  Position _currentPosition;
  PermissionHandler _permissionHandler = PermissionHandler();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool location = true;

  Future<List<Placemark>> getPlaceMark() async {
    final permission = await Geolocator().checkGeolocationPermissionStatus();
    if (permission == GeolocationStatus.denied) {
      await _permissionHandler.requestPermissions([
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
        throw ('Location permissions denied');
      }
    } else {
      _currentPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      return await Geolocator().placemarkFromPosition(_currentPosition);
    }
    throw ('Unknown error has occured');
  }

  @override
  Widget build(BuildContext context) {
    HouseDataState hds = HouseDataState();
    log('wlocation', error: widget.location);
    log('location', error: location);
    if (widget.location && location) {
      return FutureBuilder<List<Placemark>>(
          future: Future.wait([getPlaceMark()]).then((response) => response[0]),
          builder:
              (BuildContext context, AsyncSnapshot<List<Placemark>> placeMark) {
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
                final Map<String, dynamic> geolocation = {
                  'Country': placeMark.data[0].country,
                  'CountryCode': placeMark.data[0].isoCountryCode,
                  'County': placeMark.data[0].administrativeArea,
                  'Locality': placeMark.data[0].locality,
                  'Street': placeMark.data[0].thoroughfare,
                  'Number': placeMark.data[0].subThoroughfare,
                  'Position': placeMark.data[0].position
                };
                log(placeMark.data[0].toJson().toString());
                hds.geolocation = geolocation;
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
          });
    } else {
      return LocationFormPage(
        autoDetectEvent: () {
          setState(() => location = true);
        },
        submit: widget.submitEvent,
      );
    }
  }
}
