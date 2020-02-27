import 'package:flutter/cupertino.dart';
import 'package:Homey/helpers/web_requests_helpers/web_requests_helpers.dart';

class FormValidation {
  static const REQUIRED = 'Field required';

  static String simpleValidator(String value) {
    return value.isEmpty ? REQUIRED : null;
  }

  static String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    if (value.isEmpty || !RegExp(pattern).hasMatch(value))
      return 'Invalid email';
    else
      return null;
  }
  static Future<String> emailValidatorWithDatabaseCheck(String value) async {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    if (value.isEmpty || !RegExp(pattern).hasMatch(value))
      return 'Invalid email';
    else{
      
       var r = await WebRequestsHelpers.get(
          route: '/api/checkemail/?email=$value');
       return r.json()['success'];
//       Future.doWhile(action)

    }
//      return null;
  }

  static String passwordValidator(String value) {
    Pattern pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$';
    if (value.isEmpty || !RegExp(pattern).hasMatch(value))
      return 'Password must be minimum 8 characters long and include at least one uppercase letter, one lowercase letter and one number';
    else
        return null;

  }
}
