import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/navigation_helper.dart';
import 'core/app_config.dart';
import 'core/datasources/local_data_source.dart';
import 'core/model/logged_user.dart';
import 'core/network/network_info.dart';
import 'features/account/data/datasources/user_local_data_source.dart';
import 'features/account/data/datasources/user_remote_data_source.dart';
import 'features/account/data/repositories/user_repository.dart';
import 'features/account/domain/datasources/iuser_local_data_source.dart';
import 'features/account/domain/datasources/iuser_remote_data_source.dart';
import 'features/account/domain/repositories/iuser_repository.dart';
import 'features/account/domain/usecases/login.dart';
import 'features/forex/data/datasources/quote_local_data_source.dart';
import 'features/forex/data/datasources/quote_remote_data_source.dart';
import 'features/forex/data/repositories/quote_repository.dart';
import 'features/forex/domain/datasources/iquote_local_data_source.dart';
import 'features/forex/domain/datasources/iquote_remote_data_source.dart';
import 'features/forex/domain/repositories/iquote_repository.dart';

final sl = GetIt.instance;

Future<void> initContainer() async {
  // Repository
  sl.registerLazySingleton<IUserRepository>(() => UserRepository(sl(), sl()));
  sl.registerLazySingleton<IQuoteRepository>(() => QuoteRepository(sl(), sl(), sl()));

  // Datasources
  sl.registerLazySingleton<IQuoteLocalDataSource>(() => QuoteLocalDataSource(sl()));
  sl.registerLazySingleton<IQuoteRemoteDataSource>(() => QuoteRemoteDataSource(sl(), sl()));
  sl.registerLazySingleton<IUserLocalDataSource>(() => UserLocalDataSource(sl()));
  sl.registerLazySingleton<IUserRemoteDataSource>(() => UserRemoteDataSource(sl(), sl()));

  // Core
  sl.registerLazySingleton<INetworkInfo>(() => NetworkInfo(sl()));
  sl.registerLazySingleton<LoggedUser>(() => LoggedUser());
  final config = await AppConfig.getConfig();
  sl.registerLazySingleton<AppConfig>(() => config);

  // Util
  sl.registerLazySingleton(() => NavigationHelper());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => LocalDataSource(sl()));
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());

  // UseCases
  sl.registerLazySingleton(() => Login(sl(), sl()));
}
