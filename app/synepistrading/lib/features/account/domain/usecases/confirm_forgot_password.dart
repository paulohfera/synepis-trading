import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/iuser_repository.dart';

class ConfirmForgotPassword {
  final IUserRepository repository;

  ConfirmForgotPassword(this.repository);

  Future<Either<Failure, String>> call(String code, String email, String password) async {
    return await repository.confirmForgotPassword(code, email, password);
  }
}
