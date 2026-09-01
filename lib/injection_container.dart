import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'features/users/data/datasources/user_local_data_source.dart';
import 'features/users/data/datasources/user_remote_data_source.dart';
import 'features/users/data/repositories/user_repository_impl.dart';
import 'features/users/domain/repositories/user_repository.dart';
import 'features/users/domain/usecases/get_users_usecase.dart';
import 'features/users/domain/usecases/search_users_usecase.dart';
import 'features/users/presentation/bloc/user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Hive Box
  if (!Hive.isBoxOpen('users_box')) {
    final userBox = await Hive.openBox('users_box');
    sl.registerLazySingleton<Box>(() => userBox);
  } else {
    sl.registerLazySingleton<Box>(() => Hive.box('users_box'));
  }

  // External / Core Singletons
  sl.registerLazySingleton<DioClient>(() => DioClient(Dio()));
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Data sources Singletons
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(userBox: sl()),
  );

  // Repository Singleton
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases Factories
  sl.registerFactory(() => GetUsersUseCase(sl()));
  sl.registerFactory(() => SearchUsersUseCase(sl()));

  // Features - Users BLoC Factory
  sl.registerFactory(
    () => UserBloc(
      getUsersUseCase: sl(),
      searchUsersUseCase: sl(),
    ),
  );
}


