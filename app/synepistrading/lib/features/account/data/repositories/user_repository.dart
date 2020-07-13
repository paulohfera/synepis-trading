import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/datasources/iuser_remote_data_source.dart';
import '../../domain/entities/user.dart';
import '../../domain/exceptions.dart';
import '../../domain/repositories/iuser_repository.dart';
import '../models/user_model.dart';

class UserRepository implements IUserRepository {
  final IUserRemoteDataSource remoteDataSource;
  final INetworkInfo networkInfo;

  UserRepository(this.remoteDataSource, this.networkInfo);

  @override
  Future<Either<Failure, UserModel>> login(String email, String password) async {
    if (!await networkInfo.isConnected) return Left(ConnectionFailure());

    try {
      final user = await remoteDataSource.login(email, password);
      return Right(user);
    } on UserOrPasswordException catch (_) {
      return Left(LoginFailure());
    } on ServerException catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserModel>> register(User user) async {
    if (!await networkInfo.isConnected) return Left(ConnectionFailure());

    try {
      await remoteDataSource.register(user);
      return Right(user);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
