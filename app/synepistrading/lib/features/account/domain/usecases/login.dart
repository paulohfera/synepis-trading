import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    var cache = json.encode(user.toJson());
    await sharedPreferences.setString(CACHED_USER, cache);
    return result;
  }
}
