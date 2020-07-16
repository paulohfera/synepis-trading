import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/datasources/iuser_remote_data_source.dart';
import '../../domain/exceptions.dart';
import '../../domain/repositories/iuser_repository.dart';
import '../../error/failure.dart';
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
  Future<Either<Failure, String>> register(UserModel user) async {
    if (!await networkInfo.isConnected) return Left(ConnectionFailure());

    try {
      final result = await remoteDataSource.register(user);
      if (!result.success) return Left(RegisterFailure(result.messages));

      return Right(result.messages[0]);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    if (!await networkInfo.isConnected) return Left(ConnectionFailure());

    try {
      final result = await remoteDataSource.forgotPassword(email);
      if (!result.success) return Left(ForgotPasswordFailure(result.messages));

      return Right(result.messages[0]);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> confirmForgotPassword(String code, String email, String password) async {
    if (!await networkInfo.isConnected) return Left(ConnectionFailure());

    try {
      final result = await remoteDataSource.confirmForgotPassword(code, email, password);
      if (!result.success) return Left(ForgotPasswordFailure(result.messages));

      return Right(result.messages[0]);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
