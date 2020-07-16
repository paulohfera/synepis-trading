import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synepistrading/router.dart';

import '../../../../components/alert.dart';
import '../../../../containers.dart';
import '../../../../core/datasources/local_data_source.dart';
import '../bloc/register/register_bloc.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _currentTheme = sl.get<LocalDataSource>().theme.getTheme();
    var _name = TextEditingController();
    var _email = TextEditingController();
    var _password = TextEditingController();
    var _confirmpassword = TextEditingController();
    final _form = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: Text("Criar nova conta")),
      body: BlocProvider<RegisterBloc>(
        create: (_) => sl.get<RegisterBloc>(),
        child: Container(
          padding: EdgeInsets.only(left: 40, right: 40),
          child: Form(
            key: _form,
            child: BlocListener<RegisterBloc, RegisterState>(
              listener: (context, state) {
                if (state is Error) Alert.alert(context, "Erro", state.message);
                if (state is Success)
                  Alert.alert(context, "Informação", state.message, () {
                    Navigator.of(context).pushReplacementNamed(homeRoute);
                  });
              },
              child: BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  return ListView(
                    children: [
                      SizedBox(height: 40),
                      SizedBox(
                        width: 128,
                        height: 128,
                        child: Image.asset('assets/images/' + _currentTheme.logo),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Nome"),
                        controller: _name,
                        validator: (x) => context.bloc<RegisterBloc>().nameValidation(x),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: "E-mail"),
                        controller: _email,
                        validator: (x) => context.bloc<RegisterBloc>().emailValidation(x),
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Senha"),
                        controller: _password,
                        validator: (x) => context.bloc<RegisterBloc>().passwordValidation(x),
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Confirme a senha"),
                        controller: _confirmpassword,
                        validator: (x) => context.bloc<RegisterBloc>().confirmPasswordValidation(x, _password.text),
                      ),
                      SizedBox(height: 30),
                      Container(
                        height: 40,
                        child: FlatButton(
                          child: state is Loading
                              ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))
                              : Text("Registrar", style: TextStyle(fontSize: 18)),
                          color: _currentTheme.buttonColor,
                          disabledColor: _currentTheme.buttonDisabledColor,
                          textColor: _currentTheme.buttonTextColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          onPressed: state is Loading
                              ? null
                              : () {
                                  if (!_form.currentState.validate()) return;
                                  _form.currentState.save();
                                  context
                                      .bloc<RegisterBloc>()
                                      .add(SendRegister(_name.text, _email.text, _password.text));
                                },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
