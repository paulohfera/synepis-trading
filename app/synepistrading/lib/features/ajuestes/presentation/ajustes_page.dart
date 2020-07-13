import 'package:flutter/material.dart';
import 'package:synepistrading/features/ajuestes/domain/usecases/logout.dart';

import '../../../containers.dart';
import '../../../router.dart';

class AjustesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FlatButton(
          child: Text("Sair"),
          onPressed: () async {
            var logout = sl.get<Logout>();
            await logout("");
            Navigator.pushNamed(context, homeRoute);
          },
        ),
      ),
    );
  }
}
