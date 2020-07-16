import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/iuser_repository.dart';

class ForgotPassword {
  final IUserRepository repository;

  ForgotPassword(this.repository);

  Future<Either<Failure, String>> call(String email) async {
    return await repository.forgotPassword(email);
  }
}
