import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_directory_app/core/error/failures.dart';
import 'package:user_directory_app/features/users/domain/entities/user_entity.dart';
import 'package:user_directory_app/features/users/domain/repositories/user_repository.dart';
import 'package:user_directory_app/features/users/domain/usecases/get_users_usecase.dart';
import 'package:user_directory_app/features/users/domain/usecases/search_users_usecase.dart';
import 'package:user_directory_app/features/users/presentation/bloc/user_bloc.dart';
import 'package:user_directory_app/features/users/presentation/screens/user_list_screen.dart';

class MockUserRepository implements UserRepository {
  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({
    int page = 1,
    int perPage = 6,
    bool forceRefresh = false,
  }) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query) async {
    return const Right([]);
  }
}

void main() {
  testWidgets('Initial screen shows Users title', (WidgetTester tester) async {
    final repository = MockUserRepository();
    final getUsersUseCase = GetUsersUseCase(repository);
    final searchUsersUseCase = SearchUsersUseCase(repository);
    final bloc = UserBloc(
      getUsersUseCase: getUsersUseCase,
      searchUsersUseCase: searchUsersUseCase,
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: BlocProvider.value(
            value: bloc,
            child: const UserListScreen(),
          ),
        ),
      ),
    );

    expect(find.text('Users'), findsOneWidget);
  });
}


