import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/app_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/datasources/iuser_remote_data_source.dart';
import '../models/user_model.dart';

class UserRemoteDataSource implements IUserRemoteDataSource {
  final Dio client;
  final AppConfig config;

  UserRemoteDataSource(this.client, this.config);

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(config.apiAccount + "login", data: {"email": email, "password": password});

    if (response.statusCode == 200) return UserModel.fromJson(jsonDecode(response.data));

    throw ServerException();
  }

  @override
  Future<bool> register(UserModel user) async {
    final response = await client.post(config.apiAccount + "register", data: user.toJson());

    if (response.statusCode == 200) return true;

    return throw ServerException();
  }
}
