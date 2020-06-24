import 'dart:convert';

import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:synepistrading/core/datasources/local_data_source.dart';
import 'package:synepistrading/core/error/exceptions.dart';
import 'package:synepistrading/features/forex/data/datasources/quote_local_data_source.dart';
import 'package:synepistrading/features/forex/data/models/quote_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockLocalDataSource extends Mock implements LocalDataSource {}

void main() {
  QuoteLocalDataSource dataSource;
  MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    dataSource = QuoteLocalDataSource(mockLocalDataSource);
  });

  group("getLastQuote", () {
    final String data = fixture("quote.json");
    final String pair = "EURUSD";
    final quoteModel = QuoteModel.fromJson(json.decode(data));

    test(
      "should return quote from SharedPreferences where there's one in the cache",
      () async {
        // arrange
        when(mockLocalDataSource.getString(any)).thenReturn(data);
        // act
        final result = await dataSource.getLastQuote(pair);
        //assert
        verify(mockLocalDataSource.getString(CACHED_QUOTE_ + pair));
        expect(result, equals(quoteModel));
      },
    );

    test(
      "should throw a CacheException where there's not a cached value",
      () async {
        // arrange
        when(mockLocalDataSource.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastQuote;
        //assert
        expect(() => call(pair), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group("cacheQuote", () {
    final pair = "EURUSD";
    final quoteModel = QuoteModel(pair, 1.234234, DateTime.now());
    test(
      "should call SharedPreferences to cache data",
      () async {
        // arrange
        // act
        dataSource.cacheQuote(quoteModel);
        //assert
        final expectedJson = json.encode(quoteModel.toJson());
        verify(mockLocalDataSource.set(CACHED_QUOTE_ + pair, expectedJson));
      },
    );
  });
}
