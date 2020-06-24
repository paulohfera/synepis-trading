import 'package:flutter/material.dart';

import '../../../../containers.dart';
import '../../../../core/datasources/local_data_source.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _currentTheme = sl.get<LocalDataSource>().theme.getTheme();
    final _form = GlobalKey<FormState>();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60, left: 40, right: 40),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: 128,
                height: 128,
                child: Image.asset('assets/images/' + _currentTheme.logo),
              ),
              SizedBox(
                height: 60,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "E-mail"),
                // onSaved: (x) => _controller.login = x,
                // validator: _controller.loginValidation,
                initialValue: "teste@teste.com",
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: "Senha"),
                // onSaved: (x) => _controller.password = x,
                // validator: _controller.passwordValidation,
                initialValue: "asdasdad",
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  child: Text("Esqueci minha senha"),
                  onPressed: () {
                    //Navigator.pushNamed(context, forgotPasswordRoute);
                  },
                ),
              ),
              Container(
                height: 50,
                child: FlatButton(
                  child: Text("Acessar", style: TextStyle(fontSize: 18)),
                  color: Theme.of(context).buttonColor,
                  textColor: Theme.of(context).textTheme.button.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () async {
                    if (!_form.currentState.validate()) return;
                    _form.currentState.save();
                    //await _controller.submit();
                  },
                ),
              ),
              Container(
                height: 60,
                child: FlatButton(
                  child: Text("Cadastrar"),
                  onPressed: () {
                    //Navigator.pushNamed(context, registerRoute);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
