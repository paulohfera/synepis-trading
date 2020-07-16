part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends RegisterState {}

class Loading extends RegisterState {}

class Success extends RegisterState {
  final String message;

  Success(this.message);

  @override
  List<Object> get props => [message];
}

class Error extends RegisterState {
  final String message;

  Error(this.message);

  @override
  List<Object> get props => [message];
}
