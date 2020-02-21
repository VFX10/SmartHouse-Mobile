
import 'dart:developer';

import 'package:flutter/material.dart';

class HouseDataState {
//  @protected
  Map<String, dynamic> geolocation;
  String homeName;
//  Map<String, dynamic> get currentGeolocation => geolocation;

//  void setStateText(Map<String, dynamic>  geolocation) {
//    this.geolocation = geolocation;
//  }
  static final HouseDataState _instance = HouseDataState._internal();

  factory HouseDataState() {
    return _instance;
  }

  HouseDataState._internal(){
    log('created');
  }
}