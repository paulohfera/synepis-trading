import '../../data/models/user_model.dart';

abstract class IUserRemoteDataSource {
  Future<UserModel> login(String email, String passeord);
  Future<bool> register(UserModel user);
}
