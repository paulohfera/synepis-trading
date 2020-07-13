part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends LoginState {}

class Loading extends LoginState {}

class Success extends LoginState {
  final User user;

  Success(this.user);

  @override
  List<Object> get props => [user];
}

class Error extends LoginState {
  final String message;

  Error(this.message);

  @override
  List<Object> get props => [message];
}
