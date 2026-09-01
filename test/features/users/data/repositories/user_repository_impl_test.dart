import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_directory_app/core/network/network_info.dart';
import 'package:user_directory_app/features/users/data/datasources/user_local_data_source.dart';
import 'package:user_directory_app/features/users/data/datasources/user_remote_data_source.dart';
import 'package:user_directory_app/features/users/data/models/user_model.dart';
import 'package:user_directory_app/features/users/data/repositories/user_repository_impl.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}
class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late UserRepositoryImpl repository;
  late MockUserRemoteDataSource mockRemoteDataSource;
  late MockUserLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    mockLocalDataSource = MockUserLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UserRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tModels = [
    UserModel(
      id: 1,
      email: 'george.bluth@reqres.in',
      firstName: 'George',
      lastName: 'Bluth',
      avatar: 'https://reqres.in/img/faces/1-image.jpg',
    ),
  ];

  group('getUsers Repository Tests', () {
    test('should fetch from remote data source and cache to Hive when online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getUsers(1)).thenAnswer(
        (_) async => const UserPaginatedResponse(users: tModels, totalPages: 1),
      );
      when(() => mockLocalDataSource.cacheUsers(any())).thenAnswer((_) async => {});

      final result = await repository.getUsers(page: 1);

      expect(result.isRight(), true);
      verify(() => mockRemoteDataSource.getUsers(1)).called(1);
      verify(() => mockLocalDataSource.cacheUsers(tModels)).called(1);
    });

    test('should fetch from local cache when device is offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getCachedUsers()).thenAnswer((_) async => tModels);

      final result = await repository.getUsers(page: 1);

      expect(result.isRight(), true);
      verify(() => mockLocalDataSource.getCachedUsers()).called(1);
      verifyZeroInteractions(mockRemoteDataSource);
    });
  });
}
