import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:synepistrading/features/forex/data/models/quote_model.dart';
import 'package:synepistrading/features/forex/domain/entities/quote.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final date = "2020-06-11 01:33:00";
  final quoteModel = QuoteModel("EURUSD", 1.13826, DateTime.parse(date));

  test(
    "should be a subclass of User entity",
    () async {
      //assert
      expect(quoteModel, isA<Quote>());
    },
  );

  test(
    "should retunr a valid model",
    () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture("quote.json"));
      // act
      final result = QuoteModel.fromJson(jsonMap);
      //assert
      expect(result, quoteModel);
    },
  );

  test(
    "should return Json map containing the provider data",
    () async {
      // arrange
      final result = quoteModel.toJson();
      // act
      final expectedMap = {
        "pair": "EURUSD",
        "value": 1.13826,
        "time": date,
      };
      //assert
      expect(result, expectedMap);
    },
  );
}
