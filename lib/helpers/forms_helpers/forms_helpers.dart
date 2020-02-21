import 'package:flutter/material.dart';

class FormHelpers {
  static fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static clearField(TextEditingController controller) {
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.clear());
  }
}
