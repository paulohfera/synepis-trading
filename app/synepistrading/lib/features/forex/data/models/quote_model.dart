import 'package:intl/intl.dart';
import 'package:synepistrading/features/forex/domain/entities/quote.dart';

class QuoteModel extends Quote {
  QuoteModel(String pair, double value, DateTime time)
      : super(pair, value, time);

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
        json["pair"], json["value"], DateTime.parse(json["time"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "pair": pair,
      "value": value,
      "time": DateFormat('yyyy-MM-dd HH:mm:ss').format(time),
    };
  }
}
