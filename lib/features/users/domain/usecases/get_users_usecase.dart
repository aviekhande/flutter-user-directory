import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Single-responsibility use case for fetching paginated user lists.
class GetUsersUseCase {
  final UserRepository repository;

  const GetUsersUseCase(this.repository);

  Future<Either<Failure, List<UserEntity>>> call({
    int page = 1,
    int perPage = 10,
    bool forceRefresh = false,
  }) async {
    return await repository.getUsers(
      page: page,
      perPage: perPage,
      forceRefresh: forceRefresh,
    );
  }
}
