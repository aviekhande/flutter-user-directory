import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// Abstract Domain Repository contract for user data management.
abstract class UserRepository {
  /// Fetches a paginated list of users.
  Future<Either<Failure, List<UserEntity>>> getUsers({
    int page = 1,
    int perPage = 10,
    bool forceRefresh = false,
  });

  /// Searches users matching the provided query term.
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query);
}
