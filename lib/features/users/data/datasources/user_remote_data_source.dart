import 'package:dio/dio.dart';
import '../../../../core/constants/constants.dart';
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
    final response = await dio.get(
      '${AppConstants.baseUrl}${AppConstants.usersPath}',
      queryParameters: {
        'per_page': 6,
        'page': page,
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final Map<String, dynamic> data = response.data is Map<String, dynamic>
          ? response.data
          : Map<String, dynamic>.from(response.data as Map);

      final List<dynamic> usersJson = data['data'] as List<dynamic>? ?? [];
      final int totalPages = data['total_pages'] as int? ?? 1;

      final users = usersJson
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return UserPaginatedResponse(
        users: users,
        totalPages: totalPages,
      );
    } else {
      throw Exception(AppStrings.defaultServerError);
    }
  }
}

