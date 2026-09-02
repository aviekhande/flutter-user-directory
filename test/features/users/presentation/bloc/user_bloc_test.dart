import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_directory_app/core/error/failures.dart';
import 'package:user_directory_app/features/users/domain/entities/user_entity.dart';
import 'package:user_directory_app/features/users/domain/usecases/get_users_usecase.dart';
import 'package:user_directory_app/features/users/domain/usecases/search_users_usecase.dart';
import 'package:user_directory_app/features/users/presentation/bloc/user_bloc.dart';
import 'package:user_directory_app/features/users/presentation/bloc/user_event.dart';
import 'package:user_directory_app/features/users/presentation/bloc/user_state.dart';

class MockGetUsersUseCase extends Mock implements GetUsersUseCase {}
class MockSearchUsersUseCase extends Mock implements SearchUsersUseCase {}

void main() {
  late UserBloc userBloc;
  late MockGetUsersUseCase mockGetUsersUseCase;
  late MockSearchUsersUseCase mockSearchUsersUseCase;

  setUp(() {
    mockGetUsersUseCase = MockGetUsersUseCase();
    mockSearchUsersUseCase = MockSearchUsersUseCase();
    userBloc = UserBloc(
      getUsersUseCase: mockGetUsersUseCase,
      searchUsersUseCase: mockSearchUsersUseCase,
    );
  });

  tearDown(() {
    userBloc.close();
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

  test('initial state should be UserInitial', () {
    expect(userBloc.state, equals(UserInitial()));
  });

  group('FetchUsersEvent', () {
    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserLoaded] when FetchUsersEvent succeeds',
      build: () {
        when(() => mockGetUsersUseCase(page: 1))
            .thenAnswer((_) async => const Right(tUsers));
        return userBloc;
      },
      act: (bloc) => bloc.add(const FetchUsersEvent(page: 1)),
      expect: () => [
        UserLoading(),
        const UserLoaded(users: tUsers, hasMore: true, currentPage: 1),
      ],
    );

    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserError] when FetchUsersEvent fails with ServerFailure',
      build: () {
        when(() => mockGetUsersUseCase(page: 1))
            .thenAnswer((_) async => const Left(ServerFailure('Server error')));
        return userBloc;
      },
      act: (bloc) => bloc.add(const FetchUsersEvent(page: 1)),
      expect: () => [
        UserLoading(),
        const UserError(message: 'Server error'),
      ],
    );
  });

  group('RefreshUsersEvent', () {
    blocTest<UserBloc, UserState>(
      'emits [UserLoading, UserLoaded] when RefreshUsersEvent succeeds',
      build: () {
        when(() => mockGetUsersUseCase(page: 1, forceRefresh: true))
            .thenAnswer((_) async => const Right(tUsers));
        return userBloc;
      },
      act: (bloc) => bloc.add(RefreshUsersEvent()),
      expect: () => [
        UserLoading(),
        const UserLoaded(users: tUsers, hasMore: true, currentPage: 1),
      ],
    );
  });
}
