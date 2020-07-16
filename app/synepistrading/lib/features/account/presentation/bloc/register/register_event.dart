part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class SendRegister extends RegisterEvent {
  final String name;
  final String email;
  final String password;

  SendRegister(this.name, this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
