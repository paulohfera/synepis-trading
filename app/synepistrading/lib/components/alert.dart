import 'package:flutter/material.dart';

abstract class Alert {
  static alert(BuildContext context, String title, String text) {
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title ?? ""),
          content: Text(text ?? ""),
          actions: <Widget>[okButton],
        );
      },
    );
  }
}
