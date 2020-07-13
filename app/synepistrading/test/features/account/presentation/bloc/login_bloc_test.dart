import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:synepistrading/core/error/failure.dart';
import 'package:synepistrading/features/account/domain/entities/user.dart';
import 'package:synepistrading/features/account/domain/usecases/login.dart';
import 'package:synepistrading/features/account/presentation/bloc/login_bloc.dart';

class MockLogin extends Mock implements Login {}

void main() {
  LoginBloc bloc;
  MockLogin mockLogin;

  setUp(() {
    mockLogin = MockLogin();

    bloc = LoginBloc(mockLogin);
  });

  test(
    "initialState should be empty",
    () async {
      //assert
      expect(bloc.state, Empty());
    },
  );

  group(
    "login",
    () {
      final user = User("Synapis", "email@email.com", "token", "refreshToken");

      test(
        "should get data from the concrete use case",
        () async {
          // arrange
          when(mockLogin(any, any)).thenAnswer((_) async => Right(user));
          // act
          bloc.add(GetLogin("email@email.com", "password"));
          await untilCalled(mockLogin(any, any));
          // assert
          verify(mockLogin("email@email.com", "password"));
        },
      );

      test(
        "should not emit new states when close",
        () async {
          // assert later
          expectLater(
            bloc,
            emitsInOrder([Empty(), emitsDone]),
          );
          bloc.close();
          // act
        },
      );

      test(
        "should emit [Loading, Loaded] when data is gotten sucessfully",
        () async {
          // arrange
          when(mockLogin(any, any)).thenAnswer((_) async => Right(user));
          // assert later
          final expected = [Empty(), Loading(), Success(user)];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(GetLogin(user.email, user.token));
        },
      );

      test(
        "should emit [Loading, Error] when data is gotten sucessfully",
        () async {
          // arrange
          when(mockLogin(any, any)).thenAnswer((_) async => Left(ServerFailure()));
          // assert later
          final expected = [Empty(), Loading(), Error(SERVER_FAILURE_MESSAGE)];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(GetLogin(user.email, user.token));
        },
      );

      test(
        "should emit [Loading, Error] with a proper message for the error when getting data fails",
        () async {
          // arrange
          when(mockLogin(any, any)).thenAnswer((_) async => Left(ConnectionFailure()));
          // assert later
          final expected = [Empty(), Loading(), Error(CONNECTION_FAILURE_MESSAGE)];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(GetLogin(user.email, user.token));
        },
      );
    },
  );
}
