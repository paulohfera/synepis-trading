import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:synepistrading/core/error/exceptions.dart';
import 'package:synepistrading/core/error/failure.dart';
import 'package:synepistrading/core/model/result_api.dart';
import 'package:synepistrading/core/network/network_info.dart';
import 'package:synepistrading/features/account/data/models/user_model.dart';
import 'package:synepistrading/features/account/data/repositories/user_repository.dart';
import 'package:synepistrading/features/account/domain/datasources/iuser_remote_data_source.dart';
import 'package:synepistrading/features/account/domain/entities/user.dart';

class MockRemoteDataSource extends Mock implements IUserRemoteDataSource {}

class MockNetworkInfo extends Mock implements INetworkInfo {}

void main() {
  UserRepository repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UserRepository(mockRemoteDataSource, mockNetworkInfo);
  });

  void setUpNetworkIsConnected() {
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
  }

  group("login", () {
    final name = "user name";
    final email = "user email";
    final token = "token";
    final refreshToken = "refreshToken";

    UserModel userModel;
    User user;

    setUp(() {
      userModel = UserModel(name, email, null, token, refreshToken);
      user = userModel;
    });

    test(
      "should check if the device is online",
      () async {
        // arrange
        setUpNetworkIsConnected();
        // act
        repository.login(email, token);
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    test(
      "should return remote data when the call to remote data source is sucess",
      () async {
        // arrange
        setUpNetworkIsConnected();
        when(mockRemoteDataSource.login(any, any)).thenAnswer((_) async => userModel);
        // act
        final result = await repository.login(email, token);
        //assert
        verify(mockRemoteDataSource.login(email, token));
        expect(result, equals(Right(user)));
      },
    );

    test(
      "should return server fail when the call to remote data source is unsuccesfull",
      () async {
        // arrange
        setUpNetworkIsConnected();
        when(mockRemoteDataSource.login(any, any)).thenThrow(ServerException());
        // act
        final result = await repository.login(email, token);
        //assert
        verify(mockRemoteDataSource.login(email, token));
        expect(result, equals(Left(ServerFailure())));
      },
    );
  });

  group("register", () {
    final name = "user name";
    final email = "user email";
    final userModel = UserModel(name, email, null, null, null);
    final resultApi = ResultApi(true, [""], null);

    test(
      "should check if the device is online",
      () async {
        // arrange
        setUpNetworkIsConnected();
        when(mockRemoteDataSource.register(any)).thenAnswer((_) async => resultApi);
        // act
        repository.register(userModel);
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    test(
      "should return remote data when the call to remote data source is sucess",
      () async {
        // arrange
        setUpNetworkIsConnected();
        when(mockRemoteDataSource.register(any)).thenAnswer((_) async => resultApi);
        // act
        final result = await repository.register(userModel);
        //assert
        verify(mockRemoteDataSource.register(userModel));
        expect(result, equals(Right("")));
      },
    );

    test(
      "should return server fail when the call to remote data source is unsuccesfull",
      () async {
        // arrange
        setUpNetworkIsConnected();
        when(mockRemoteDataSource.register(any)).thenThrow(ServerException());
        // act
        final result = await repository.register(userModel);
        //assert
        verify(mockRemoteDataSource.register(userModel));
        expect(result, equals(Left(ServerFailure())));
      },
    );
  });

  group("forgot password", () {
    final email = "email@email.com";
    final resultApi = ResultApi(true, [""], null);

    test(
      "should check if the device is online",
      () async {
        // arrange
        setUpNetworkIsConnected();
        when(mockRemoteDataSource.forgotPassword(any)).thenAnswer((_) async => resultApi);
        // act
        repository.forgotPassword(email);
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    test(
      "should return remote data when the call to remote data source is sucess",
      () async {
        // arrange
        setUpNetworkIsConnected();
        when(mockRemoteDataSource.forgotPassword(any)).thenAnswer((_) async => resultApi);
        // act
        final result = await repository.forgotPassword(email);
        //assert
        verify(mockRemoteDataSource.forgotPassword(email));
        expect(result, equals(Right("")));
      },
    );

    test(
      "should return server fail when the call to remote data source is unsuccesfull",
      () async {
        // arrange
        setUpNetworkIsConnected();
        when(mockRemoteDataSource.forgotPassword(any)).thenThrow(ServerException());
        // act
        final result = await repository.forgotPassword(email);
        //assert
        verify(mockRemoteDataSource.forgotPassword(email));
        expect(result, equals(Left(ServerFailure())));
      },
    );
  });

  group("confirm reset password", () {
    final code = "00000";
    final email = "email@email.com";
    final password = "xxx";
    final resultApi = ResultApi(true, [""], null);

    test(
      "should check if the device is online",
      () async {
        // arrange
        setUpNetworkIsConnected();
        when(mockRemoteDataSource.confirmForgotPassword(any, any, any)).thenAnswer((_) async => resultApi);
        // act
        repository.confirmForgotPassword(code, email, password);
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    test(
      "should return remote data when the call to remote data source is sucess",
      () async {
        // arrange
        setUpNetworkIsConnected();
        when(mockRemoteDataSource.confirmForgotPassword(any, any, any)).thenAnswer((_) async => resultApi);
        // act
        final result = await repository.confirmForgotPassword(code, email, password);
        //assert
        verify(mockRemoteDataSource.confirmForgotPassword(code, email, password));
        expect(result, equals(Right("")));
      },
    );

    test(
      "should return server fail when the call to remote data source is unsuccesfull",
      () async {
        // arrange
        setUpNetworkIsConnected();
        when(mockRemoteDataSource.confirmForgotPassword(any, any, any)).thenThrow(ServerException());
        // act
        final result = await repository.confirmForgotPassword(code, email, password);
        //assert
        verify(mockRemoteDataSource.confirmForgotPassword(code, email, password));
        expect(result, equals(Left(ServerFailure())));
      },
    );
  });
}
