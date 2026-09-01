import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_directory_app/core/theme/app_theme.dart';
import 'package:user_directory_app/features/users/presentation/bloc/user_bloc.dart';
import 'package:user_directory_app/features/users/presentation/screens/user_list_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<UserBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'User Directory',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const UserListScreen(),
      ),
    );
  }
}
