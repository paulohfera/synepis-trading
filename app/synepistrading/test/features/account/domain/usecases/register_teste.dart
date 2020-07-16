import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:synepistrading/features/account/data/models/user_model.dart';
import 'package:synepistrading/features/account/domain/repositories/iuser_repository.dart';
import 'package:synepistrading/features/account/domain/usecases/register.dart';

class MockUserRespository extends Mock implements IUserRepository {}

void main() {
  Register usecase;
  MockUserRespository mockUserRespository;

  setUp(() {
    mockUserRespository = MockUserRespository();
    usecase = Register(mockUserRespository);
  });

  final name = "Synepis";
  final login = "teste@teste.com";
  final password = "password";
  final userModel = UserModel(name, login, password, "token", "refreshToken");

  test(
    "do user register",
    () async {
      // arrange
      when(mockUserRespository.register(any)).thenAnswer((_) async => Right(""));
      // act
      final result = await usecase(name, login, password);
      //assert
      expect(result, Right(""));
      verify(mockUserRespository.register(userModel));
      verifyNoMoreInteractions(mockUserRespository);
    },
  );
}
