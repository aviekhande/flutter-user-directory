import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_directory_app/features/users/domain/entities/user_entity.dart';
import 'package:user_directory_app/features/users/domain/repositories/user_repository.dart';
import 'package:user_directory_app/features/users/domain/usecases/get_users_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUsersUseCase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetUsersUseCase(mockUserRepository);
  });

  const tUsers = [
    UserEntity(
      id: 1,
      email: 'george.bluth@reqres.in',
      firstName: 'George',
      lastName: 'Bluth',
      avatar: 'https://reqres.in/img/faces/1-image.jpg',
    ),
  ];

  test('should get user list from the repository', () async {
    when(() => mockUserRepository.getUsers(page: 1, perPage: 10, forceRefresh: false))
        .thenAnswer((_) async => const Right(tUsers));

    final result = await usecase(page: 1, perPage: 10);

    expect(result, const Right(tUsers));
    verify(() => mockUserRepository.getUsers(page: 1, perPage: 10, forceRefresh: false)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
