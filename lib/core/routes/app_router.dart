import 'package:go_router/go_router.dart';

import '../../features/users/domain/entities/user_entity.dart';
import '../../features/users/presentation/screens/user_detail_screen.dart';
import '../../features/users/presentation/screens/user_list_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.userList,
    routes: [
      GoRoute(
        path: AppRoutes.userList,
        name: 'userList',
        builder: (context, state) => const UserListScreen(),
      ),
      GoRoute(
        path: AppRoutes.userDetail,
        name: 'userDetail',
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return UserDetailScreen(user: user);
        },
      ),
    ],
  );
}
