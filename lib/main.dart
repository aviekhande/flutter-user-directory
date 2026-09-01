import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:user_directory_app/core/theme/app_theme.dart';
import 'package:user_directory_app/features/users/domain/entities/user_entity.dart';
import 'package:user_directory_app/features/users/presentation/bloc/user_bloc.dart';
import 'package:user_directory_app/features/users/presentation/screens/user_detail_screen.dart';
import 'package:user_directory_app/features/users/presentation/screens/user_list_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (_) => di.sl<UserBloc>(),
      child: MaterialApp(
        title: 'User Directory',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        initialRoute: '/',
        routes: {
          '/': (context) => const UserListScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/detail') {
            final args = settings.arguments;
            if (args is UserEntity) {
              return MaterialPageRoute(
                builder: (_) => UserDetailScreen(user: args),
                settings: settings,
              );
            }
          }
          return null;
        },
      ),
    );
  }
}

