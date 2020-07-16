import 'package:synepistrading/features/account/domain/entities/user.dart';

class UserModel extends User {
  UserModel(String name, String email, String password, String token, String refreshToken)
      : super(name, email, password, token, refreshToken);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(json["name"], json["email"], json["password"], json["token"], json["refreshToken"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "token": token,
      "refreshToken": refreshToken,
    };
  }
}
