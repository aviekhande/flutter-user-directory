import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers({int page = 1, int perPage = 6});
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query);
}

