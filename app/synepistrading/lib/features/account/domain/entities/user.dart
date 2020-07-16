import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final String email;
  final String password;
  final String token;
  final String refreshToken;

  User(this.name, this.email, this.password, this.token, this.refreshToken);

  @override
  List<Object> get props => [name, email, password, token, refreshToken];
}
