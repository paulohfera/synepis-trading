import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants.dart';
import '../../../../../core/extensions/list_to_string.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/valueObjects/email_value_object.dart';
import '../../../domain/usecases/register.dart';
import '../../../error/failure.dart';

part 'register_event.dart';
part 'register_state.dart';

const WATING_FOR_CONFIRMATION =
    "Cadastro realizado com suceeso. Você receberá um e-mail para ativação do seu cadastro.";
const USER_ALREADY_EXISTIS = "O e-mail informado já está cadastrado.";

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final Register register;

  RegisterBloc(this.register)
      : assert(register != null),
        super(Empty());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is SendRegister) {
      yield Loading();
      final failureOrUser = await register(event.name, event.email, event.password);
      yield failureOrUser.fold(
        (failure) => Error(_mapFailureToMessage(failure)),
        (message) => Success(_getMessage(message)),
      );
    }
  }

  String nameValidation(String value) {
    if (value.isEmpty) return "Informe o nome.";
    return null;
  }

  String emailValidation(String value) {
    if (value.isEmpty) return "Informe o e-mail.";
    if (!EmailValueObject(value).isValid()) return "E-mail inválido.";
    return null;
  }

  String passwordValidation(String value) {
    if (value.isEmpty) return "Informe a senha.";
    if (value.length < 8) return "A senha deve ter ao menos 8 caracteres.";
    return null;
  }

  String confirmPasswordValidation(String confirmPassword, String password) {
    if (confirmPassword.isEmpty) return "Informe a senha.";
    if (confirmPassword != password) return "As senhas não são iguais.";
    return null;
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case RegisterFailure:
      var list = (failure as ForgotPasswordFailure).message;
      return list.map((x) => _getMessage(x)).toList().joinString("\n");
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case ConnectionFailure:
      return CONNECTION_FAILURE_MESSAGE;
    default:
      return "Erro inexperado";
  }
}

String _getMessage(String messageCode) {
  switch (messageCode) {
    case "WATING_FOR_CONFIRMATION":
      return WATING_FOR_CONFIRMATION;
    case "USER_ALREADY_EXISTIS":
      return USER_ALREADY_EXISTIS;
    default:
      return "";
  }
}
