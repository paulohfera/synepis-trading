import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final String email;
  final String token;
  final String refreshToken;

  User(this.name, this.email, this.token, this.refreshToken);

  @override
  List<Object> get props => [name, email, token, refreshToken];
}
