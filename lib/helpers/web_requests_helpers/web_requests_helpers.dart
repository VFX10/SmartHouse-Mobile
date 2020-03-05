import 'dart:convert' as prefix0;
import 'dart:developer' as debuging;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebRequestsHelpers {
  static const String DOMAIN = 'http://192.168.0.118:8000';

//  static const String DOMAIN = 'http://192.168.43.51:8000';

  static Future<Response> get(
      {@required String route,
      String domain = DOMAIN,
      bool securized = false,
      bool jsonBody = true}) {
    assert(route != null, 'route argument is required');
    try {
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      var headers = {'Authorization': 'Bearer ${prefs.getString('token')}'};

      debuging.log("GET executed on:", error: domain + route);

      return Requests.get(domain + route).then((response) {
        debuging.log("request payload", error: response.content());
        return response;
      }).catchError((e) {
        throw (e);
      });
    } catch (e, s) {
//      debuging.log('Error trying to make a web request. Error:', error: e);
      debuging.log('Error trying to make a web request. StackTrace:', error: s);
      throw ('Error ocurred trying to make a web request. Check logs for details.');
    }
  }

  static Future<Response> post(
      {@required String route,
      @required Map<dynamic, dynamic> body,
      String domain = DOMAIN,
      bool displayResponse = false}) async {
    assert(route != null, 'route argument is required');
    assert(route != null, 'body argument is required');
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var headers = {'Authorization': 'Bearer ${prefs.getString('token')}'};
//      Map<String, String> headers = {
//        'Content-Type': 'application/json',
//        "Accept": "*/*",
//      };
    debuging.log("POST executed on:", error: domain + route);
    return Requests.post(domain + route, json: body).then((response) {
      if (displayResponse)
        debuging.log("request payload", error: response.content());
      return response;
    }).catchError((e) {
      throw (e);
    });
  }

  static Future<dynamic> put(
      {@required String route,
      @required String body,
      String domain = DOMAIN,
      bool securized = false,
      bool jsonBody = true}) async {
    assert(route != null, 'route argument is required');
    assert(route != null, 'body argument is required');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var headers = {'Authorization': 'Bearer ${prefs.getString('token')}'};
      if (securized) {
        return await Requests.put(domain + route, body: body, json: jsonBody);
      } else {
        return await Requests.put(domain + route,
            body: body, json: jsonBody, headers: headers);
      }
    } catch (e, s) {
      debuging.log('Error trying to make a web request. Error:', error: e);
      debuging.log('Error trying to make a web request. StackTrace:', error: s);
      throw ('Error ocurred trying to make a web request. Check logs for details.');
    }
  }

//  static Future<dynamic> delete(
//      {@required String route,
//      String domain = DOMAIN,
//      bool securized = false,
//      bool jsonBody = true}) async {
//    assert(route != null, 'route argument is required');
//    try {
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      var headers = {'Authorization': 'Bearer ${prefs.getString('token')}'};
//      if (securized) {
//        return await Requests.delete(domain + route, json: jsonBody);
//      } else {
//        return await Requests.delete(domain + route,
//            json: jsonBody, headers: headers);
//      }
//    } catch (e, s) {
//      debuging.log('Error trying to make a web request. Error:', error: e);
//      debuging.log('Error trying to make a web request. StackTrace:', error: s);
//      throw ('Error ocurred trying to make a web request. Check logs for details.');
//    }
//  }
}
