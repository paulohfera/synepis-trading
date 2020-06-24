import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:synepistrading/core/error/exceptions.dart';
import 'package:synepistrading/core/error/failure.dart';
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
    final password = "user password";

    UserModel userModel;
    User user;

    setUp(() {
      userModel = UserModel(name, email, password);
      user = userModel;
    });

    test(
      "should check if the device is online",
      () async {
        // arrange
        setUpNetworkIsConnected();
        // act
        repository.login(email, password);
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    test(
      "should return remote data when the call to remote data source is sucess",
      () async {
        // arrange
        setUpNetworkIsConnected();
        when(mockRemoteDataSource.login(any, any))
            .thenAnswer((_) async => userModel);
        // act
        final result = await repository.login(email, password);
        //assert
        verify(mockRemoteDataSource.login(email, password));
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
        final result = await repository.login(email, password);
        //assert
        verify(mockRemoteDataSource.login(email, password));
        expect(result, equals(Left(ServerFailure())));
      },
    );
  });

  group("register", () {
    final name = "user name";
    final email = "user email";
    final password = "user password";

    final userModel = UserModel(name, email, password);
    final User user = userModel;

    test(
      "should check if the device is online",
      () async {
        // arrange
        setUpNetworkIsConnected();
        // act
        repository.register(user);
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    test(
      "should return remote data when the call to remote data source is sucess",
      () async {
        // arrange
        setUpNetworkIsConnected();
        // act
        final result = await repository.register(user);
        //assert
        verify(mockRemoteDataSource.register(user));
        expect(result, equals(Right(user)));
      },
    );

    test(
      "should return server fail when the call to remote data source is unsuccesfull",
      () async {
        // arrange
        setUpNetworkIsConnected();
        when(mockRemoteDataSource.register(any)).thenThrow(ServerException());
        // act
        final result = await repository.register(user);
        //assert
        verify(mockRemoteDataSource.register(user));
        expect(result, equals(Left(ServerFailure())));
      },
    );
  });
}
