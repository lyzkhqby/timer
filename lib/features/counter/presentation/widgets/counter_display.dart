import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/counter.dart';

class CounterDisplay extends StatelessWidget {
  final Counter counter;
  
  const CounterDisplay({
    super.key,
    required this.counter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm:ss');
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Current Count',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              '${counter.value}',
              style: theme.textTheme.displayLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Last updated: ${dateFormat.format(counter.lastUpdated)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
