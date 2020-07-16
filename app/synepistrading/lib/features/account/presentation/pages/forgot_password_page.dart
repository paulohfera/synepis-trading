import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synepistrading/components/alert.dart';
import 'package:synepistrading/features/account/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:synepistrading/router.dart';

import '../../../../containers.dart';
import '../../../../core/datasources/local_data_source.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _currentTheme = sl.get<LocalDataSource>().theme.getTheme();
    var _email = TextEditingController();
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
                if (state is Success) Navigator.of(context).pushReplacementNamed(forgotPasswordConfirmRoute);
              },
              child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
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
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: "E-mail"),
                        controller: _email,
                        validator: (x) => context.bloc<ForgotPasswordBloc>().emailValidation(x),
                      ),
                      SizedBox(height: 30),
                      Container(
                        height: 40,
                        child: FlatButton(
                          child: state is Loading
                              ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))
                              : Text("Resetar senha", style: TextStyle(fontSize: 18)),
                          color: _currentTheme.buttonColor,
                          disabledColor: _currentTheme.buttonDisabledColor,
                          textColor: _currentTheme.buttonTextColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          onPressed: state is Loading
                              ? null
                              : () {
                                  if (!_form.currentState.validate()) return;
                                  _form.currentState.save();
                                  context.bloc<ForgotPasswordBloc>().add(RequestCode(_email.text));
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
