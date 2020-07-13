import 'dart:convert';

import 'package:matcher/matcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:synepistrading/core/app_config.dart';
import 'package:synepistrading/core/error/exceptions.dart';
import 'package:synepistrading/features/forex/data/datasources/quote_remote_data_source.dart';
import 'package:synepistrading/features/forex/data/models/quote_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements Dio {}

class MockAppConfig extends Mock implements AppConfig {}

void main() {
  MockHttpClient mockHttpClient;
  MockAppConfig mockAppConfig;
  QuoteRemoteDataSource dataSource;
  dynamic jsonData;
  QuoteModel quoteModel;

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockAppConfig = MockAppConfig();
    dataSource = QuoteRemoteDataSource(mockHttpClient, mockAppConfig);
    jsonData = json.decode(fixture("quote.json"));
    quoteModel = QuoteModel.fromJson(jsonData);
  });

  void setUpAppConfig() {
    when(mockAppConfig.apiForex).thenAnswer((_) => "http://localhost:8080");
  }

  void setUpMockHttpClientSucess200() {
    when(mockHttpClient.get(any)).thenAnswer((_) async => Response(data: fixture("quote.json"), statusCode: 200));
    setUpAppConfig();
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any)).thenAnswer((_) async => Response(data: fixture("quote.json"), statusCode: 400));
    setUpAppConfig();
  }

  group("getQuote", () {
    final pair = "EURUSD";

    test(
      "should perform a GET request on a URL with pair being the endpoint and wiht application/json header",
      () async {
        // arrange
        setUpMockHttpClientSucess200();
        // act
        dataSource.getQuote(pair);
        //assert
        verify(mockHttpClient.get(any));
      },
    );

    test(
      "should return Quote when the response code is 200 (sucess)",
      () async {
        // arrange
        setUpMockHttpClientSucess200();
        // act
        final result = await dataSource.getQuote(pair);
        //assert
        expect(result, equals(quoteModel));
      },
    );

    test(
      "should throw a ServerException when the response cpde is 404 or other",
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getQuote;
        //assert
        expect(() => call(pair), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
