part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
}

class RequestCode extends ForgotPasswordEvent {
  final String email;

  RequestCode(this.email);

  @override
  List<Object> get props => [email];
}

class ResetPassword extends ForgotPasswordEvent {
  final String code;
  final String email;
  final String password;

  ResetPassword(this.code, this.email, this.password);

  @override
  List<Object> get props => [code, email, password];
}
