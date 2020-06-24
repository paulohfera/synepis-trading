import 'package:synepistrading/features/account/domain/entities/user.dart';

class UserModel extends User {
  UserModel(String name, String email, String password)
      : super(name, email, password);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(json["name"], json["email"], json["password"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
    };
  }
}
