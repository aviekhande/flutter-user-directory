import 'package:hive/hive.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Contract for local persistence operations utilizing [Hive].
abstract class UserLocalDataSource {
  /// Caches a list of [UserModel]s in Hive storage.
  Future<void> cacheUsers(List<UserModel> usersToCache);

  /// Retrieves the cached list of [UserModel]s from Hive storage.
  Future<List<UserModel>> getCachedUsers();

  /// Clears the stored user cache from Hive.
  Future<void> clearCache();
}

/// Concrete implementation of [UserLocalDataSource] using [Box].
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box userBox;

  static const String cachedUsersKey = AppStrings.cachedUsersKey;

  UserLocalDataSourceImpl({required this.userBox});

  @override
  Future<void> cacheUsers(List<UserModel> usersToCache) async {
    try {
      final userListJson = usersToCache.map((user) => user.toJson()).toList();
      await userBox.put(cachedUsersKey, userListJson);
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  Future<List<UserModel>> getCachedUsers() async {
    try {
      final rawData = userBox.get(cachedUsersKey);
      if (rawData != null && rawData is List) {
        return rawData.map((e) {
          final jsonMap = Map<String, dynamic>.from(e as Map);
          return UserModel.fromJson(jsonMap);
        }).toList();
      }
      return [];
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await userBox.delete(cachedUsersKey);
    } catch (_) {
      throw const CacheException();
    }
  }
}
