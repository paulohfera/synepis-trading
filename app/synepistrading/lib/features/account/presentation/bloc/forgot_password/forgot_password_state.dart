part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends ForgotPasswordState {}

class Loading extends ForgotPasswordState {}

class Success extends ForgotPasswordState {
  final String message;

  Success(this.message);

  @override
  List<Object> get props => [message];
}

class Error extends ForgotPasswordState {
  final String message;

  Error(this.message);

  @override
  List<Object> get props => [message];
}
