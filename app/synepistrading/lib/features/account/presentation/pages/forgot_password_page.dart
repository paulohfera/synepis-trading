import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryTextTheme.headline6.color,
        ),
        title: Text("Lembrar senha"),
      ),
      body: Center(
        child: Text("Lembrar"),
      ),
    );
  }
}
