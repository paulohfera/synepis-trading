import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/alert.dart';
import '../../../../containers.dart';
import '../../../../core/datasources/local_data_source.dart';
import '../../../../router.dart';
import '../bloc/forgot_password/forgot_password_bloc.dart';

class ForgotPasswordConfirmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _currentTheme = sl.get<LocalDataSource>().theme.getTheme();
    var _code = TextEditingController();
    var _email = TextEditingController();
    var _password = TextEditingController();
    var _confirmpassword = TextEditingController();
    final _form = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: _currentTheme.background), title: Text("Esqueci minha senha")),
      body: BlocProvider<ForgotPasswordBloc>(
        create: (_) => sl.get<ForgotPasswordBloc>(),
        child: Container(
          padding: EdgeInsets.only(left: 40, right: 40),
          child: Form(
            key: _form,
            child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
              listener: (context, state) {
                if (state is Error) Alert.alert(context, "Erro", state.message);
                if (state is Success) {
                  Alert.alert(context, "Confirmação", state.message, () {
                    Navigator.of(context).pushReplacementNamed(homeRoute);
                  });
                }
              },
              child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                builder: (context, state) {
                  return ListView(children: [
                    SizedBox(height: 40),
                    SizedBox(
                      width: 128,
                      height: 128,
                      child: Image.asset('assets/images/' + _currentTheme.logo),
                    ),
                    SizedBox(height: 20),
                    Text(
                        "Preencha os campos abaixo com o código que você recebeu por e-mail para alterar a sua senha."),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Código de confirmação"),
                      controller: _code,
                      validator: (x) => context.bloc<ForgotPasswordBloc>().codeValidation(x),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: "E-mail"),
                      controller: _email,
                      validator: (x) => context.bloc<ForgotPasswordBloc>().emailValidation(x),
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Nova senha"),
                      controller: _password,
                      validator: (x) => context.bloc<ForgotPasswordBloc>().passwordValidation(x),
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Confirme a senha"),
                      controller: _confirmpassword,
                      validator: (x) => context.bloc<ForgotPasswordBloc>().confirmPasswordValidation(x, _password.text),
                    ),
                    SizedBox(height: 30),
                    Container(
                      height: 40,
                      child: FlatButton(
                        child: state is Loading
                            ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))
                            : Text("Alterar senha", style: TextStyle(fontSize: 18)),
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
                                    .bloc<ForgotPasswordBloc>()
                                    .add(ResetPassword(_code.text, _email.text, _password.text));
                              },
                      ),
                    ),
                  ]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
