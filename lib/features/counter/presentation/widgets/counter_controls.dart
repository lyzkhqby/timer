import 'package:flutter/material.dart';

class CounterControls extends StatelessWidget {
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  
  const CounterControls({
    super.key,
    required this.onIncrement,
    required this.onDecrement,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: onDecrement,
              heroTag: 'decrement',
              child: const Icon(Icons.remove),
            ),
            FloatingActionButton(
              onPressed: onIncrement,
              heroTag: 'increment',
              child: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset'),
          ),
        ),
      ],
    );
  }
}
