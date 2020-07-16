import 'package:flutter/material.dart';

abstract class Alert {
  static alert(BuildContext context, String title, String text, [Function okPressed]) {
    var onPressed = okPressed;
    if (onPressed == null) {
      onPressed = () {
        Navigator.of(context).pop();
      };
    }

    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: onPressed,
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
