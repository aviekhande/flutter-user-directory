import 'package:hive/hive.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> cacheUsers(List<UserModel> usersToCache);
  Future<List<UserModel>> getCachedUsers();
  Future<void> clearCache();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box userBox;

  static const String cachedUsersKey = AppStrings.cachedUsersKey;

  UserLocalDataSourceImpl({required this.userBox});

  @override
  Future<void> cacheUsers(List<UserModel> usersToCache) async {
    final userListJson = usersToCache.map((user) => user.toJson()).toList();
    await userBox.put(cachedUsersKey, userListJson);
  }

  @override
  Future<List<UserModel>> getCachedUsers() async {
    final rawData = userBox.get(cachedUsersKey);
    if (rawData != null && rawData is List) {
      return rawData.map((e) {
        final jsonMap = Map<String, dynamic>.from(e as Map);
        return UserModel.fromJson(jsonMap);
      }).toList();
    }
    return [];
  }

  @override
  Future<void> clearCache() async {
    await userBox.delete(cachedUsersKey);
  }
}

