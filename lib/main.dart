import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'injection_container.dart' as di;
import 'features/tasks/presentation/bloc/task_bloc.dart';

import 'features/projects/presentation/bloc/projects_bloc.dart';

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
        BlocProvider<ProjectsBloc>(
          create: (context) => di.sl<ProjectsBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<TaskBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Scaffold App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


