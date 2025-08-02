import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/counter/presentation/pages/counter_page.dart';
import 'route_names.dart';
import '../../features/user/presentation/pages/user_page.dart';

import '../../features/product/presentation/pages/product_page.dart';




class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: RouteNames.home,
    routes: [
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.counter,
        name: RouteNames.counter,
        builder: (context, state) => const CounterPage(),
      ),
      GoRoute(
        path: RouteNames.products,
        name: RouteNames.products,
        builder: (context, state) => const ProductPage(),
      ),
      GoRoute(
        path: RouteNames.users,
        name: RouteNames.users,
        builder: (context, state) => const UserPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
  
  static GoRouter get router => _router;
}
