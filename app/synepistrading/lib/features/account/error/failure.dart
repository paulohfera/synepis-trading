import '../../../core/error/failure.dart';

class LoginFailure extends Failure {}

class RegisterFailure extends Failure {
  final List<String> message;

  RegisterFailure(this.message);

  @override
  List<Object> get props => [message];
}

class ForgotPasswordFailure extends Failure {
  final List<String> message;

  ForgotPasswordFailure(this.message);

  @override
  List<Object> get props => [message];
}
