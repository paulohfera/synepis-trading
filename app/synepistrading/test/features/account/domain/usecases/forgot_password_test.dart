import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:synepistrading/features/account/domain/repositories/iuser_repository.dart';
import 'package:synepistrading/features/account/domain/usecases/forgot_password.dart';

class MockUserRespository extends Mock implements IUserRepository {}

void main() {
  ForgotPassword usecase;
  MockUserRespository mockUserRespository;

  setUp(() {
    mockUserRespository = MockUserRespository();
    usecase = ForgotPassword(mockUserRespository);
  });

  final email = "teste@teste.com";

  test(
    "request forgot password code",
    () async {
      // arrange
      when(mockUserRespository.forgotPassword(any)).thenAnswer((_) async => Right(""));
      // act
      final result = await usecase(email);
      //assert
      expect(result, Right(""));
      verify(mockUserRespository.forgotPassword(email));
      verifyNoMoreInteractions(mockUserRespository);
    },
  );
}
