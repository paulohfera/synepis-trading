import 'package:synepistrading/features/forex/data/models/quote_model.dart';

abstract class IQuoteRemoteDataSource {
  Future<QuoteModel> getQuote(String pair);
}
