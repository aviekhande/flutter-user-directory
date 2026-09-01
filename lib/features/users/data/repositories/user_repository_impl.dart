import 'package:dartz/dartz.dart';
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
  Future<Either<Failure, List<UserEntity>>> getUsers({int page = 1, int perPage = 6}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.getUsers(page);
        final remoteUsers = remoteResponse.users;
        await localDataSource.cacheUsers(remoteUsers);
        final entities = remoteUsers.map((model) => model.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        try {
          final cachedUsers = await localDataSource.getCachedUsers();
          if (cachedUsers.isNotEmpty) {
            final entities = cachedUsers.map((model) => model.toEntity()).toList();
            return Right(entities);
          }
        } catch (_) {}
        return Left(ServerFailure());
      }
    } else {
      try {
        final cachedUsers = await localDataSource.getCachedUsers();
        if (cachedUsers.isNotEmpty) {
          final entities = cachedUsers.map((model) => model.toEntity()).toList();
          return Right(entities);
        } else {
          return Left(CacheFailure());
        }
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query) async {
    try {
      final cachedUsers = await localDataSource.getCachedUsers();
      final lowercaseQuery = query.toLowerCase().trim();

      if (lowercaseQuery.isEmpty) {
        final entities = cachedUsers.map((model) => model.toEntity()).toList();
        return Right(entities);
      }

      final filtered = cachedUsers.where((user) {
        final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
        final email = user.email.toLowerCase();
        return fullName.contains(lowercaseQuery) || email.contains(lowercaseQuery);
      }).map((model) => model.toEntity()).toList();

      return Right(filtered);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}

