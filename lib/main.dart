import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/counter/presentation/bloc/counter_bloc.dart';
import 'injection_container.dart' as di;
import 'features/user/presentation/bloc/user_bloc.dart';

import 'features/product/presentation/bloc/product_bloc.dart';




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
          create: (context) => di.sl<CounterBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<ProductBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<UserBloc>(),
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


