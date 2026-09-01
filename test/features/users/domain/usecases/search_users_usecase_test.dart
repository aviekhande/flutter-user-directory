import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_directory_app/features/users/domain/entities/user_entity.dart';
import 'package:user_directory_app/features/users/domain/repositories/user_repository.dart';
import 'package:user_directory_app/features/users/domain/usecases/search_users_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late SearchUsersUseCase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = SearchUsersUseCase(mockUserRepository);
  });

  const tQuery = 'George';
  const tUsers = [
    UserEntity(
      id: 1,
      email: 'george.bluth@reqres.in',
      firstName: 'George',
      lastName: 'Bluth',
      avatar: 'https://reqres.in/img/faces/1-image.jpg',
    ),
  ];

  test('should search users matching query string from repository', () async {
    when(() => mockUserRepository.searchUsers(tQuery))
        .thenAnswer((_) async => const Right(tUsers));

    final result = await usecase(tQuery);

    expect(result, const Right(tUsers));
    verify(() => mockUserRepository.searchUsers(tQuery)).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
