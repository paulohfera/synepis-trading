import '../../data/models/quote_model.dart';

abstract class IQuoteLocalDataSource {
  Future<bool> cacheQuote(QuoteModel quote);
  Future<QuoteModel> getLastQuote(String pair);
}
