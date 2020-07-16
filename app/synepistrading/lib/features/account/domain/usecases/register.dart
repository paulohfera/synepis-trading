import 'package:dartz/dartz.dart';
import 'package:synepistrading/features/account/data/models/user_model.dart';

import '../../../../core/error/failure.dart';
import '../repositories/iuser_repository.dart';

class Register {
  final IUserRepository repository;

  Register(this.repository);

  Future<Either<Failure, String>> call(String name, String email, String password) async {
    var user = UserModel(name, email, password, null, null);
    return await repository.register(user);
  }
}
