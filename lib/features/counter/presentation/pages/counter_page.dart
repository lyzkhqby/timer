import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/counter_bloc.dart';
import '../bloc/counter_event.dart';
import '../bloc/counter_state.dart';
import '../widgets/counter_display.dart';
import '../widgets/counter_controls.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CounterBloc>().add(const LoadCounter());
            },
          ),
        ],
      ),
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          if (state is CounterInitial) {
            // Load counter when page is first opened
            context.read<CounterBloc>().add(const LoadCounter());
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is CounterLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is CounterError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CounterBloc>().add(const LoadCounter());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is CounterLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CounterDisplay(counter: state.counter),
                  const SizedBox(height: 32),
                  CounterControls(
                    onIncrement: () {
                      context.read<CounterBloc>().add(const IncrementCounterEvent());
                    },
                    onDecrement: () {
                      context.read<CounterBloc>().add(const DecrementCounterEvent());
                    },
                    onReset: () {
                      context.read<CounterBloc>().add(const ResetCounterEvent());
                    },
                  ),
                ],
              ),
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
