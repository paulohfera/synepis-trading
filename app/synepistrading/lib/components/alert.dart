import 'package:flutter/material.dart';

import '../containers.dart';
import 'navigation_helper.dart';

abstract class Alert {
  static var _context = sl.get<NavigationHelper>().navigatorKey.currentState.overlay.context;

  static alert(String title, String text) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(_context).pop();
      },
    );

    AlertDialog dialog = AlertDialog(
      title: Text(title ?? ""),
      content: Text(text ?? ""),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: _context,
      builder: (x) => dialog,
    );
  }
}
