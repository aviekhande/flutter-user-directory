import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<List<UserModel>> getLastUsers();
  Future<void> cacheUsers(List<UserModel> usersToCache);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  @override
  Future<void> cacheUsers(List<UserModel> usersToCache) {
    // TODO: implement cacheUsers
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> getLastUsers() {
    // TODO: implement getLastUsers
    throw UnimplementedError();
  }
}
