import 'dart:convert';

import 'package:matcher/matcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:synepistrading/core/app_config.dart';
import 'package:synepistrading/core/error/exceptions.dart';
import 'package:synepistrading/features/account/data/datasources/user_remote_data_source.dart';
import 'package:synepistrading/features/account/data/models/user_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements Dio {}

class MockAppConfig extends Mock implements AppConfig {}

void main() {
  MockHttpClient mockHttpClient;
  MockAppConfig mockAppConfig;
  UserRemoteDataSource dataSource;
  UserModel userModel;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockAppConfig = MockAppConfig();
    dataSource = UserRemoteDataSource(mockHttpClient, mockAppConfig);
    userModel = UserModel.fromJson(json.decode(fixture("user.json")));
  });

  void setUpAppConfig() {
    when(mockAppConfig.apiAccount).thenAnswer((_) => "http://localhost:8080");
  }

  void setUpMockHttpClientLoginSucess200() {
    when(mockHttpClient.post(any, data: anyNamed("data")))
        .thenAnswer((_) async => Response(data: jsonDecode(fixture("login.json")), statusCode: 200));
    setUpAppConfig();
  }

  void setUpMockHttpClientRegisterSucess200() {
    when(mockHttpClient.post(any, data: anyNamed("data")))
        .thenAnswer((_) async => Response(data: true, statusCode: 200));
    setUpAppConfig();
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.post(any, data: anyNamed("data"))).thenThrow(ServerException());
    setUpAppConfig();
  }

  group("login", () {
    test(
      "should perform a POST request on a URL with pair being the endpoint and wiht application/json header",
      () async {
        // arrange
        setUpMockHttpClientLoginSucess200();
        // act
        dataSource.login("user", "password");
        //assert
        verify(mockHttpClient.post(any, data: {"email": "user", "password": "password"}));
      },
    );

    test(
      "should return User when the response code is 200 (sucess)",
      () async {
        // arrange
        setUpMockHttpClientLoginSucess200();
        // act
        final result = await dataSource.login("user", "password");
        //assert
        expect(result, equals(userModel));
      },
    );

    test(
      "should throw a ServerException when the response cpde is 404 or other",
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.login;
        //assert
        expect(() => call("user", "password"), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group("register", () {
    test(
      "should perform a POST request on a URL with pair being the endpoint and wiht application/json header",
      () async {
        // arrange
        setUpMockHttpClientRegisterSucess200();
        // act
        dataSource.register(userModel);
        //assert
        verify(mockHttpClient.post(any, data: userModel.toJson()));
      },
    );

    test(
      "should return true when the response code is 200 (sucess)",
      () async {
        // arrange
        setUpMockHttpClientRegisterSucess200();
        // act
        final result = await dataSource.register(userModel);
        //assert
        expect(result, true);
      },
    );

    test(
      "should throw a ServerException when the response cpde is 404 or other",
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.register;
        //assert
        expect(() => call(userModel), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
