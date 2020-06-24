import 'dart:convert';

import '../../../../core/datasources/local_data_source.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/datasources/iquote_local_data_source.dart';
import '../models/quote_model.dart';

const CACHED_QUOTE_ = "CACHED_QUOTE_";

class QuoteLocalDataSource implements IQuoteLocalDataSource {
  final LocalDataSource localDataSource;

  QuoteLocalDataSource(this.localDataSource);

  @override
  Future<bool> cacheQuote(QuoteModel quote) {
    var data = json.encode(quote.toJson());
    return localDataSource.set(CACHED_QUOTE_ + quote.pair, data);
  }

  @override
  Future<QuoteModel> getLastQuote(String pair) {
    final data = localDataSource.getString(CACHED_QUOTE_ + pair);
    if (data != null)
      return Future.value(QuoteModel.fromJson(json.decode(data)));

    throw CacheException();
  }
}
