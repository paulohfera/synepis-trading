import 'package:dartz/dartz.dart';
import 'package:synepistrading/core/error/failure.dart';
import 'package:synepistrading/features/account/data/models/user_model.dart';

abstract class IUserRepository {
  Future<Either<Failure, UserModel>> login(String email, String password);
  Future<Either<Failure, String>> register(UserModel user);
  Future<Either<Failure, String>> forgotPassword(String email);
  Future<Either<Failure, String>> confirmForgotPassword(String code, String email, String password);
}
