import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/app_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/datasources/iquote_remote_data_source.dart';
import '../models/quote_model.dart';

class QuoteRemoteDataSource implements IQuoteRemoteDataSource {
  final Dio client;
  final AppConfig config;

  QuoteRemoteDataSource(this.client, this.config);

  @override
  Future<QuoteModel> getQuote(String pair) async {
    final response = await client.get(config.apiForex + pair);

    if (response.statusCode == 200)
      return QuoteModel.fromJson(jsonDecode(response.data));
    else
      throw ServerException();
  }
}
