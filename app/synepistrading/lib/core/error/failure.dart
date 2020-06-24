import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  Failure({this.message});

  @override
  List<Object> get props => [message];
}

// General failures
class ServerFailure extends Failure {
  ServerFailure({String message})
      : super(
            message: message ??
                "Ocorreu um erro inesperado. Tente novamente em alguns instantes");
}

class ConnectionFailure extends Failure {
  ConnectionFailure({String message})
      : super(
            message: message ??
                "Não foi possível conectar com o servidor. Verifique se você está com acesso à internet e tente novamente");
}

class CacheFailure extends Failure {
  CacheFailure({String message}) : super(message: message);
}

class LoginFailure extends Failure {
  LoginFailure({String message}) : super(message: message);
}
