import 'package:dio/dio.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

class UserPaginatedResponse {
  final List<UserModel> users;
  final int totalPages;

  const UserPaginatedResponse({
    required this.users,
    required this.totalPages,
  });
}

abstract class UserRemoteDataSource {
  Future<UserPaginatedResponse> getUsers(int page);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserPaginatedResponse> getUsers(int page) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}${AppConstants.usersPath}',
        queryParameters: {
          'per_page': 6,
          'page': page,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> usersJson = [];
        int totalPages = 1;

        if (response.data is List) {
          usersJson = response.data as List<dynamic>;
          totalPages = 1;
        } else if (response.data is Map) {
          final Map<String, dynamic> data = Map<String, dynamic>.from(response.data as Map);
          usersJson = data['data'] as List<dynamic>? ?? [];
          totalPages = data['total_pages'] as int? ?? 1;
        }

        final users = usersJson
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .toList();

        return UserPaginatedResponse(
          users: users,
          totalPages: totalPages,
        );
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw TimeoutException();
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException();
      } else {
        throw ServerException();
      }
    } catch (_) {
      throw ServerException();
    }
  }
}

