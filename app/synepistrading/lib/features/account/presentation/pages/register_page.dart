import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryTextTheme.headline6.color,
        ),
        title: Text("Criar nova conta"),
      ),
      body: Center(
        child: Text("Register"),
      ),
    );
  }
}
