import 'package:dartz/dartz.dart';
import 'package:synepistrading/core/error/failure.dart';
import 'package:synepistrading/features/forex/domain/entities/quote.dart';

abstract class IQuoteRepository {
  Future<Either<Failure, Quote>> getQuote(String pair);
}
