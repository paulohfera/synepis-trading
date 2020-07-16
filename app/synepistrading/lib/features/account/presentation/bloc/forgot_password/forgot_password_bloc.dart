import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/extensions/list_to_string.dart';
import '../../../../../core/valueObjects/email_value_object.dart';
import '../../../domain/usecases/confirm_forgot_password.dart';
import '../../../domain/usecases/forgot_password.dart';
import '../../../error/failure.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

const VERIFICATION_CODE_SENT = "VERIFICATION_CODE_SENT";
const USER_NOT_FOUND = "O e-mail informado não foi encontrado.";
const PASSWORD_CHANGED = "A sua senha foi alterada com sucesso.";
const CODE_EXPIRED = "O código informado expirou. Acesse novamente a opção esquecí minha senha.";

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPassword forgotPasswordUsecase;
  final ConfirmForgotPassword confirmForgotPasswordUsecase;

  ForgotPasswordBloc(this.forgotPasswordUsecase, this.confirmForgotPasswordUsecase)
      : assert(forgotPasswordUsecase != null),
        assert(confirmForgotPasswordUsecase != null),
        super(Empty());

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    if (event is RequestCode) {
      yield Loading();
      final failureOrUser = await forgotPasswordUsecase(event.email);
      yield failureOrUser.fold(
        (failure) => Error(_mapFailureToMessage(failure)),
        (message) => Success(_getMessage(message)),
      );
    }

    if (event is ResetPassword) {
      yield Loading();
      final failureOrUser = await confirmForgotPasswordUsecase(event.code, event.email, event.password);
      yield failureOrUser.fold(
        (failure) => Error(_mapFailureToMessage(failure)),
        (message) => Success(_getMessage(message)),
      );
    }
  }

  String emailValidation(String value) {
    if (value.isEmpty) return "Informe o e-mail.";
    if (!EmailValueObject(value).isValid()) return "E-mail inválido.";
    return null;
  }

  String codeValidation(String value) {
    if (value.isEmpty) return "Informe o e-mail.";
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
    case ForgotPasswordFailure:
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
    case "USER_NOT_FOUND":
      return USER_NOT_FOUND;
    case "PASSWORD_CHANGED":
      return PASSWORD_CHANGED;
    case "CODE_EXPIRED":
      return CODE_EXPIRED;
    default:
      return "";
  }
}
