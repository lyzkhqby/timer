import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scaffold App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.flutter_dash,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome to Flutter Scaffold',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A clean architecture Flutter app with BLoC pattern',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Features',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _FeatureCard(
              icon: Icons.architecture,
              title: 'Clean Architecture',
              description: 'Organized code structure with separation of concerns',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Clean Architecture implemented!')),
                );
              },
            ),
            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.widgets,
              title: 'BLoC Pattern',
              description: 'State management with flutter_bloc',
              onTap: () => context.push(RouteNames.counter),
            ),
            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.palette,
              title: 'Material Design 3',
              description: 'Modern UI with Material 3 theming',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Material 3 theme applied!')),
                );
              },
            ),
            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.task,
              title: 'Task Management',
              description: 'Manage tasks with BLoC pattern',
              onTap: () => context.push(RouteNames.tasks),
            ),
            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.navigation,
              title: 'Go Router',
              description: 'Declarative routing with go_router',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Go Router navigation!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.inventory,
              title: 'Product Management',
              description: 'Manage products with BLoC pattern',
              onTap: () => context.push(RouteNames.products),
            ),            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.task,
              title: 'Task Management',
              description: 'Manage tasks with BLoC pattern',
              onTap: () => context.push(RouteNames.tasks),
            ),            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.inventory,
              title: 'Product Management',
              description: 'Manage products with BLoC pattern',
              onTap: () => context.push(RouteNames.products),
            ),            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.person,
              title: 'User Management',
              description: 'Manage users with BLoC pattern',
              onTap: () => context.push(RouteNames.users),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
