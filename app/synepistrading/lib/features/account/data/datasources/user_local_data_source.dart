import 'dart:convert';

import '../../../../core/constants.dart';
import '../../../../core/datasources/local_data_source.dart';
import '../../domain/datasources/iuser_local_data_source.dart';
import '../models/user_model.dart';

class UserLocalDataSource implements IUserLocalDataSource {
  final LocalDataSource localDataSource;

  UserLocalDataSource(this.localDataSource);

  @override
  Future<void> setLoggedUser(UserModel user) {
    var data = json.encode(user.toJson());
    return localDataSource.set(CACHED_USER, data);
  }
}
