import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synepistrading/core/constants.dart';
import 'package:synepistrading/features/account/data/models/user_model.dart';
import 'package:synepistrading/features/account/domain/repositories/iuser_repository.dart';
import 'package:synepistrading/features/account/domain/usecases/login.dart';

class MockUserRespository extends Mock implements IUserRepository {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  Login usecase;
  MockUserRespository mockUserRespository;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockUserRespository = MockUserRespository();
    mockSharedPreferences = MockSharedPreferences();
    usecase = Login(mockUserRespository, mockSharedPreferences);
  });

  final login = "teste@teste.com";
  final password = "password";
  final userModel = UserModel("Synepis", "teste@teste.com", "password");

  test(
    "do user login",
    () async {
      // arrange
      when(mockUserRespository.login(any, any))
          .thenAnswer((_) async => Right(userModel));
      // act
      final result = await usecase(login, password);
      //assert
      expect(result, Right(userModel));
      verify(mockUserRespository.login(login, password));
      verifyNoMoreInteractions(mockUserRespository);
    },
  );

  test(
    "should cache the data locally when the call to remote data source is sucess",
    () async {
      // arrange
      when(mockUserRespository.login(any, any))
          .thenAnswer((_) async => Right(userModel));
      // act
      final result = await usecase(login, password);
      //assert
      expect(result, Right(userModel));
      verify(mockSharedPreferences.setString(CACHED_USER, any));
    },
  );
}
