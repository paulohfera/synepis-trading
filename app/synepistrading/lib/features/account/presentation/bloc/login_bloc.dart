import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/valueObjects/email_value_object.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';

part 'login_event.dart';
part 'login_state.dart';

const String LOGIN_FAILURE_MESSAGE = "Usuário ou senha inválidos";
const String SERVER_FAILURE_MESSAGE = "Ocorreu um erro inesperado. Tente novamente em alguns instantes.";
const String CONNECTION_FAILURE_MESSAGE =
    "Não foi possível conectar com o servidor. Verifique se você está com acesso à internet e tente novamente.";

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;

  LoginBloc(this.login)
      : assert(login != null),
        super(Empty());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is GetLogin) {
      yield Loading();
      final failureOrUser = await login(event.email, event.password);
      yield failureOrUser.fold((failure) => Error(_mapFailureToMessage(failure)), (user) => Success(user));
    }
  }

  String emailValidation(String value) {
    if (value.isEmpty) return "Informe o e-mail.";
    if (!EmailValueObject(value).isValid()) return "E-mail inválido.";

    return null;
  }

  String passwordValidation(String value) {
    if (value.isEmpty) return "Informe a senha.";

    return null;
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case LoginFailure:
      return LOGIN_FAILURE_MESSAGE;
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case ConnectionFailure:
      return CONNECTION_FAILURE_MESSAGE;
    default:
      return "Erro inexperado";
  }
}
