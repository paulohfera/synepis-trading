import 'package:dartz/dartz.dart';
import 'package:synepistrading/core/error/failure.dart';
import 'package:synepistrading/features/account/data/models/user_model.dart';
import 'package:synepistrading/features/account/domain/entities/user.dart';

abstract class IUserRepository {
  Future<Either<Failure, UserModel>> login(String email, String password);
  Future<Either<Failure, UserModel>> register(User usser);
}
