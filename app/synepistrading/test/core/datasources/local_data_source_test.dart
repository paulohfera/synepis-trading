import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synepistrading/core/constants.dart';
import 'package:synepistrading/core/datasources/local_data_source.dart';
import 'package:synepistrading/core/model/logged_user.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  LocalDataSource localDataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = LocalDataSource(mockSharedPreferences);
  });

  test(
    "should set a bool value",
    () async {
      // act
      localDataSource.set("key", true);
      //assert
      verify(mockSharedPreferences.setBool("key", true));
    },
  );

  test(
    "should set a string value",
    () async {
      // act
      localDataSource.set("key", "key");
      //assert
      verify(mockSharedPreferences.setString("key", "key"));
    },
  );

  test(
    "should set a double value",
    () async {
      // act
      localDataSource.set("key", 1.5);
      //assert
      verify(mockSharedPreferences.setDouble("key", 1.5));
    },
  );

  test(
    "should set a int value",
    () async {
      // act
      localDataSource.set("key", 1);
      //assert
      verify(mockSharedPreferences.setInt("key", 1));
    },
  );

  group("get", () {
    test(
      "should get dynamic data when key is cached",
      () async {
        // arrange
        when(mockSharedPreferences.get("key")).thenReturn("expected");
        // act
        var result = localDataSource.get("key");
        //assert
        verify(mockSharedPreferences.get("key"));
        expect(result, "expected");
      },
    );

    test(
      "should get default dynamic data when key is not cached",
      () async {
        // arrange
        when(mockSharedPreferences.get("key")).thenReturn(null);
        // act
        var result = localDataSource.get("key", defaultValue: "error");
        //assert
        verify(mockSharedPreferences.get("key"));
        expect(result, "error");
      },
    );
  });

  group("logged user", () {
    var cacheUser =
        "{\"email\": \"email@mail.com\", \"name\": \"Synepis\", \"token\": \"asdasd\"}";

    var loggedUser =
        LoggedUser(email: "email@mail.com", name: "Synepis", token: "asdasd");

    test(
      "should get logged user when is logged",
      () async {
        // arrange
        when(mockSharedPreferences.get(CACHED_USER)).thenReturn(cacheUser);
        // act
        var result = localDataSource.user;
        //assert
        verify(mockSharedPreferences.get(CACHED_USER));
        expect(result.token, equals(loggedUser.token));
      },
    );

    test(
      "should get null user when user not logged",
      () async {
        // arrange
        when(mockSharedPreferences.get(CACHED_USER)).thenReturn(null);
        // act
        var result = localDataSource.user;
        //assert
        verify(mockSharedPreferences.get(CACHED_USER));
        expect(result, isNull);
      },
    );
  });
}
