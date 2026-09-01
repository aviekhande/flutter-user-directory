import '../../domain/entities/user_entity.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers();
}
