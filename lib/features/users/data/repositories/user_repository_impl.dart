import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({
    int page = 1,
    int perPage = 10,
    bool forceRefresh = false,
  }) async {
    final bool isOnline = await networkInfo.isConnected;

    if (isOnline) {
      try {
        if (forceRefresh && page == 1) {
          await localDataSource.clearCache();
        }
        final remoteResponse = await remoteDataSource.getUsers(page);
        final remoteUsers = remoteResponse.users;
        await localDataSource.cacheUsers(remoteUsers);
        final entities = remoteUsers.map((model) => model.toEntity()).toList();
        return Right(entities);
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          return await _getCachedFallback(fallbackFailure: const TimeoutFailure());
        }
        return await _getCachedFallback(fallbackFailure: const ServerFailure());
      } catch (e) {
        return await _getCachedFallback(fallbackFailure: const ServerFailure());
      }
    } else {
      return await _getCachedFallback(fallbackFailure: const NetworkFailure());
    }
  }

  Future<Either<Failure, List<UserEntity>>> _getCachedFallback({
    required Failure fallbackFailure,
  }) async {
    try {
      final cachedUsers = await localDataSource.getCachedUsers();
      if (cachedUsers.isNotEmpty) {
        final entities = cachedUsers.map((model) => model.toEntity()).toList();
        return Right(entities);
      }
    } catch (_) {}
    return Left(fallbackFailure);
  }

  @override
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query) async {
    try {
      final cachedUsers = await localDataSource.getCachedUsers();
      final trimmedQuery = query.trim();

      if (trimmedQuery.isEmpty) {
        final entities = cachedUsers.map((model) => model.toEntity()).toList();
        return Right(entities);
      }

      final escapedQuery = RegExp.escape(trimmedQuery);
      final regex = RegExp(escapedQuery, caseSensitive: false);

      final filtered = cachedUsers.where((user) {
        final fullName = '${user.firstName} ${user.lastName}';
        return regex.hasMatch(fullName) ||
            regex.hasMatch(user.firstName) ||
            regex.hasMatch(user.lastName) ||
            regex.hasMatch(user.email);
      }).map((model) => model.toEntity()).toList();

      return Right(filtered);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}


