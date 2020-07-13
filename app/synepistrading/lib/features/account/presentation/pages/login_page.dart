import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synepistrading/components/alert.dart';

import '../../../../containers.dart';
import '../../../../core/datasources/local_data_source.dart';
import '../../../../router.dart';
import '../../presentation/bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _currentTheme = sl.get<LocalDataSource>().theme.getTheme();
    var _email = TextEditingController(text: "paulofera@gmail.com");
    var _password = TextEditingController(text: "abcabcabc");
    final _form = GlobalKey<FormState>();

    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (_) => sl.get<LoginBloc>(),
        child: Container(
          padding: EdgeInsets.only(top: 60, left: 40, right: 40),
          child: Form(
            key: _form,
            child: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is Error) Alert.alert(context, "Erro", state.message);
                if (state is Success) Navigator.pushNamed(context, tabsRoute);
              },
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return ListView(
                    children: [
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
                        controller: _email,
                        validator: context.bloc<LoginBloc>().emailValidation,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Senha"),
                        controller: _password,
                        validator: context.bloc<LoginBloc>().passwordValidation,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text("Esqueci minha senha"),
                          onPressed: () {
                            Navigator.pushNamed(context, forgotPasswordRoute);
                          },
                        ),
                      ),
                      Container(
                        height: 50,
                        child: FlatButton(
                          child: state is Loading
                              ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white))
                              : Text("Acessar", style: TextStyle(fontSize: 18)),
                          color: Theme.of(context).buttonColor,
                          disabledColor: Theme.of(context).buttonColor,
                          textColor: Theme.of(context).textTheme.button.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // onPressed: state is Loading
                          //     ? null
                          //     : () {
                          //         if (!_form.currentState.validate()) return;
                          //         _form.currentState.save();
                          //         bc.bloc<LoginBloc>().add(GetLogin(_email.text, _password.text));
                          //       },
                          onPressed: () {
                            if (!_form.currentState.validate()) return;
                            _form.currentState.save();
                            context.bloc<LoginBloc>().add(GetLogin(_email.text, _password.text));
                          },
                        ),
                      ),
                      Container(
                        height: 60,
                        child: FlatButton(
                          child: Text("Cadastrar"),
                          onPressed: () {
                            Navigator.pushNamed(context, registerRoute);
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
