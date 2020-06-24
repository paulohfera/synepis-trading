import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/datasources/iquote_local_data_source.dart';
import '../../domain/datasources/iquote_remote_data_source.dart';
import '../../domain/entities/quote.dart';
import '../../domain/repositories/iquote_repository.dart';

class QuoteRepository implements IQuoteRepository {
  final IQuoteRemoteDataSource remoteDataSource;
  final IQuoteLocalDataSource localDataSource;
  final INetworkInfo networkInfo;

  QuoteRepository(
      this.remoteDataSource, this.localDataSource, this.networkInfo);

  @override
  Future<Either<Failure, Quote>> getQuote(String pair) async {
    if (await networkInfo.isConnected) {
      try {
        final quote = await remoteDataSource.getQuote(pair);
        localDataSource.cacheQuote(quote);
        return Right(quote);
      } on ServerException {
        return Left(ServerFailure());
      }
    }

    try {
      return Right(await localDataSource.getLastQuote(pair));
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
