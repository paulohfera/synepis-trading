import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:synepistrading/core/constants.dart';
import 'package:synepistrading/core/error/failure.dart';
import 'package:synepistrading/features/account/domain/usecases/register.dart';
import 'package:synepistrading/features/account/presentation/bloc/register/register_bloc.dart';

class MockRegister extends Mock implements Register {}

void main() {
  RegisterBloc bloc;
  MockRegister mockRegister;

  setUp(() {
    mockRegister = MockRegister();
    bloc = RegisterBloc(mockRegister);
  });

  test(
    "initialState should be empty",
    () async {
      //assert
      expect(bloc.state, Empty());
    },
  );

  group(
    "register",
    () {
      final name = "Synepis";
      final email = "email@email.com";
      final password = "password";

      test(
        "should get data from the concrete use case",
        () async {
          // arrange
          when(mockRegister(any, any, any)).thenAnswer((_) async => Right(""));
          // act
          bloc.add(SendRegister(name, email, password));
          await untilCalled(mockRegister(any, any, any));
          // assert
          verify(mockRegister(name, email, password));
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
          when(mockRegister(any, any, any)).thenAnswer((_) async => Right(""));
          // assert later
          final expected = [Empty(), Loading(), Success("")];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(SendRegister(name, email, password));
        },
      );

      test(
        "should emit [Loading, Error] when data is gotten sucessfully",
        () async {
          // arrange
          when(mockRegister(any, any, any)).thenAnswer((_) async => Left(ServerFailure()));
          // assert later
          final expected = [Empty(), Loading(), Error(SERVER_FAILURE_MESSAGE)];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(SendRegister(name, email, password));
        },
      );

      test(
        "should emit [Loading, Error] with a proper message for the error when getting data fails",
        () async {
          // arrange
          when(mockRegister(any, any, any)).thenAnswer((_) async => Left(ConnectionFailure()));
          // assert later
          final expected = [Empty(), Loading(), Error(CONNECTION_FAILURE_MESSAGE)];
          expectLater(bloc, emitsInOrder(expected));
          // act
          bloc.add(SendRegister(name, email, password));
        },
      );
    },
  );
}
