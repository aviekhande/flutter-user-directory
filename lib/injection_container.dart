import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_strings.dart';
import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'features/users/data/datasources/user_local_data_source.dart';
import 'features/users/data/datasources/user_remote_data_source.dart';
import 'features/users/data/repositories/user_repository_impl.dart';
import 'features/users/domain/repositories/user_repository.dart';
import 'features/users/domain/usecases/get_users_usecase.dart';
import 'features/users/domain/usecases/search_users_usecase.dart';
import 'features/users/presentation/bloc/user_bloc.dart';

/// Global Service Locator instance powered by [GetIt].
final sl = GetIt.instance;

/// Initializes dependency injection for the entire application.
/// Registers singletons for core infrastructure, datasources, and repositories,
/// and factories for use cases and BLoCs.
Future<void> init() async {
  // Hive Box Initialization
  if (!Hive.isBoxOpen(AppStrings.usersBoxKey)) {
    final userBox = await Hive.openBox(AppStrings.usersBoxKey);
    sl.registerLazySingleton<Box>(() => userBox);
  } else {
    sl.registerLazySingleton<Box>(() => Hive.box(AppStrings.usersBoxKey));
  }

  // External & Core Infrastructure Singletons
  sl.registerLazySingleton<Dio>(() => DioClient.createDio());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl<Connectivity>()));

  // Data Sources Singletons
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(userBox: sl<Box>()),
  );

  // Repository Singleton
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl<UserRemoteDataSource>(),
      localDataSource: sl<UserLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use Cases Factories
  sl.registerFactory<GetUsersUseCase>(() => GetUsersUseCase(sl<UserRepository>()));
  sl.registerFactory<SearchUsersUseCase>(() => SearchUsersUseCase(sl<UserRepository>()));

  // Feature BLoC Factory
  sl.registerFactory<UserBloc>(
    () => UserBloc(
      getUsersUseCase: sl<GetUsersUseCase>(),
      searchUsersUseCase: sl<SearchUsersUseCase>(),
    ),
  );
}
