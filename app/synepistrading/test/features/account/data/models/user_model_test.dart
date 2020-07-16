import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:synepistrading/features/account/data/models/user_model.dart';
import 'package:synepistrading/features/account/domain/entities/user.dart';

void main() {
  UserModel userModel;
  String jsonText;

  setUp(() {
    userModel = UserModel("name1", "email1@teste.com", "asd", "token", "refreshToken");
    jsonText = json.encode(userModel.toJson());
  });

  test(
    "should be a subclass of User entity",
    () async {
      // assert
      expect(userModel, isA<User>());
    },
  );

  test(
    "should retunr a valid model",
    () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(jsonText);
      // act
      final result = UserModel.fromJson(jsonMap);
      // assert
      expect(result, userModel);
    },
  );

  test(
    "should return Json map containing the provider data",
    () async {
      // arrange
      final result = userModel.toJson();
      // act
      final expectedMap = {
        "name": "name1",
        "email": "email1@teste.com",
        "password": "asd",
        "token": "token",
        "refreshToken": "refreshToken"
      };
      // assert
      expect(result, expectedMap);
    },
  );
}
