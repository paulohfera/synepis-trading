import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:synepistrading/core/error/exceptions.dart';
import 'package:synepistrading/core/error/failure.dart';
import 'package:synepistrading/core/network/network_info.dart';
import 'package:synepistrading/features/forex/data/models/quote_model.dart';
import 'package:synepistrading/features/forex/data/repositories/quote_repository.dart';
import 'package:synepistrading/features/forex/domain/datasources/iquote_local_data_source.dart';
import 'package:synepistrading/features/forex/domain/datasources/iquote_remote_data_source.dart';
import 'package:synepistrading/features/forex/domain/entities/quote.dart';

class MockRemoteDataSource extends Mock implements IQuoteRemoteDataSource {}

class MockLocalDataSource extends Mock implements IQuoteLocalDataSource {}

class MockNetworkInfo extends Mock implements INetworkInfo {}

void main() {
  QuoteRepository repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = QuoteRepository(
        mockRemoteDataSource, mockLocalDataSource, mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group("getQuote", () {
    final pair = "EURUSD";
    final DateTime time = DateTime(2020, 6, 11, 1, 33);
    final quoteModel = QuoteModel(pair, 1.13826, time);
    final Quote quote = quoteModel;

    test(
      "should check if the device is online",
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getQuote(pair);
        //assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        "should return remote data when the call to remote data source is sucess",
        () async {
          // arrange
          when(mockRemoteDataSource.getQuote(any))
              .thenAnswer((_) async => quoteModel);
          // act
          final result = await repository.getQuote(pair);
          //assert
          verify(mockRemoteDataSource.getQuote(pair));
          expect(result, equals(Right(quote)));
        },
      );

      test(
        "should cache the data locally when the call to remote data source is sucess",
        () async {
          // arrange
          when(mockRemoteDataSource.getQuote(any))
              .thenAnswer((_) async => quoteModel);
          // act
          await repository.getQuote(pair);
          //assert
          verify(mockRemoteDataSource.getQuote(pair));
          verify(mockLocalDataSource.cacheQuote(quoteModel));
        },
      );

      test(
        "should return server fail when the call to remote data source is unsuccesfull",
        () async {
          // arrange
          when(mockRemoteDataSource.getQuote(any)).thenThrow(ServerException());
          // act
          final result = await repository.getQuote(pair);
          //assert
          verify(mockRemoteDataSource.getQuote(pair));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        "should return last loccaly cached data when the cached data is present",
        () async {
          // arrange
          when(mockLocalDataSource.getLastQuote(pair))
              .thenAnswer((_) async => quoteModel);
          // act
          final result = await repository.getQuote(pair);
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastQuote(pair));
          expect(result, equals(Right(quote)));
        },
      );

      test(
        "should return CacheFailure when there's no cached data present",
        () async {
          // arrange
          when(mockLocalDataSource.getLastQuote(pair))
              .thenThrow(CacheException());
          // act
          final result = await repository.getQuote(pair);
          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastQuote(pair));
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
