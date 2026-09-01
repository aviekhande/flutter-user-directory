import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'features/users/presentation/bloc/user_bloc.dart';
import 'features/users/presentation/screens/user_list_screen.dart';
import 'core/theme/app_theme.dart';

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
        home: const UserListScreen(),
      ),
    );
  }
}
