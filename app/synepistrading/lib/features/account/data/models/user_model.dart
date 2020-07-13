import 'package:synepistrading/features/account/domain/entities/user.dart';

class UserModel extends User {
  UserModel(String name, String email, String token, String refreshToken) : super(name, email, token, refreshToken);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(json["name"], json["email"], json["token"], json["refreshToken"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "token": token,
      "refreshToken": refreshToken,
    };
  }
}
