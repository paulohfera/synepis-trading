import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:synepistrading/core/constants.dart';
import 'package:synepistrading/core/datasources/local_data_source.dart';
import 'package:synepistrading/features/account/data/datasources/user_local_data_source.dart';
import 'package:synepistrading/features/account/data/models/user_model.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

void main() {
  UserLocalDataSource dataSource;
  MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    dataSource = UserLocalDataSource(mockLocalDataSource);
  });

  group("setLoggedUser", () {
    final userModel = UserModel("name", "email@email.com", null, "token", "refreshToken");
    test(
      "should call SharedPreferences to cache data",
      () async {
        // act
        dataSource.setLoggedUser(userModel);
        //assert
        final expectedJson = json.encode(userModel.toJson());
        verify(mockLocalDataSource.set(CACHED_USER, expectedJson));
      },
    );
  });
}
