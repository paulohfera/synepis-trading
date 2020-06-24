import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:synepistrading/features/forex/data/models/quote_model.dart';
import 'package:synepistrading/features/forex/domain/entities/quote.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final date = DateTime.now();
  final quoteModel = QuoteModel("EURUSD", 1.24234, date);

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
        "value": 1.24234,
        "time": DateFormat('yyyy-MM-dd HH:mm:ss').format(date),
      };
      //assert
      expect(result, expectedMap);
    },
  );
}
