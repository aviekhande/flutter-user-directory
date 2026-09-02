import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Single-responsibility use case for searching/filtering users by query.
class SearchUsersUseCase {
  final UserRepository repository;

  const SearchUsersUseCase(this.repository);

  Future<Either<Failure, List<UserEntity>>> call(String query) async {
    return await repository.searchUsers(query);
  }
}
