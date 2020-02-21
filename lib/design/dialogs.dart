import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
class Dialogs{
  static void showSimpleDialog(String title, String message, BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  static ProgressDialog showProgressDialog(String message, BuildContext context) {
    var pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(
      message: message,
      insetAnimCurve: Curves.easeInOut,
      progressWidget: Container(
          padding: EdgeInsets.all(10.0), child: CircularProgressIndicator()),
    );
    return pr;
  }
}