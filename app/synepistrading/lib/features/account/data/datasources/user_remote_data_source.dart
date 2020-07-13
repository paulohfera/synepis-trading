import 'package:dio/dio.dart';

import '../../../../core/app_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/model/result_api.dart';
import '../../domain/datasources/iuser_remote_data_source.dart';
import '../../domain/exceptions.dart';
import '../models/user_model.dart';

class UserRemoteDataSource implements IUserRemoteDataSource {
  final Dio client;
  final AppConfig config;

  UserRemoteDataSource(this.client, this.config);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await client.post(config.apiAccount + "login", data: {"email": email, "password": password});
      final resultApi = ResultApi.fromJson(response.data);
      if (!resultApi.sucess) throw UserOrPasswordException();

      return UserModel.fromJson(resultApi.body);
    } on DioError catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<bool> register(UserModel user) async {
    try {
      await client.post(config.apiAccount + "register", data: user.toJson());
      return true;
    } catch (e) {
      throw ServerException();
    }
  }
}
