import '../../../../core/model/result_api.dart';
import '../../data/models/user_model.dart';

abstract class IUserRemoteDataSource {
  Future<UserModel> login(String email, String passeord);
  Future<ResultApi> register(UserModel user);
  Future<ResultApi> forgotPassword(String email);
  Future<ResultApi> confirmForgotPassword(String code, String email, String password);
}
