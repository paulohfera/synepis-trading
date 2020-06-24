import '../../data/models/user_model.dart';

abstract class IUserLocalDataSource {
  Future<void> setLoggedUser(UserModel user);
}
