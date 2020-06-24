import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synepistrading/core/model/logged_user.dart';

import '../../../../core/constants.dart';
import '../../../../core/error/failure.dart';
import '../entities/user.dart';
import '../repositories/iuser_repository.dart';

class Login {
  final IUserRepository repository;
  final SharedPreferences sharedPreferences;

  Login(this.repository, this.sharedPreferences);

  Future<Either<Failure, User>> call(String login, String password) async {
    var result = await repository.login(login, password);
    if (result.isLeft()) return result;

    var user = result.getOrElse(null);
    if (user == null) return Left(LoginFailure(message: "Usuário ou senha inválidos."));

    var loggedUser = LoggedUser.fromJson(user.toJson());
    loggedUser.token = "sdfasdfasdfasdfasdfas";

    var cache = json.encode(loggedUser.toJson());
    await sharedPreferences.setString(CACHED_USER, cache);
    return result;
  }
}
