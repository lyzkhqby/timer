import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/task.dart' as task_entity;
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class TaskPage extends StatefulWidget {
  final int? projectId;
  
  const TaskPage({super.key, this.projectId});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
    if (widget.projectId != null) {
      context.read<TaskBloc>().add(GetTasksByProjectIdEvent(widget.projectId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (widget.projectId != null) {
                context.read<TaskBloc>().add(GetTasksByProjectIdEvent(widget.projectId!));
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is TaskError) {
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
                      if (widget.projectId != null) {
                        context.read<TaskBloc>().add(GetTasksByProjectIdEvent(widget.projectId!));
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Tasks',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No tasks found for this project.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                if (widget.projectId != null) {
                  context.read<TaskBloc>().add(GetTasksByProjectIdEvent(widget.projectId!));
                }
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return _buildTaskCard(context, task);
                },
              ),
            );
          }

          return const Center(
            child: Text('No project selected'),
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, task_entity.Task task) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  task.status == task_entity.TaskStatus.completed 
                    ? Icons.check_circle 
                    : Icons.radio_button_unchecked,
                  color: task.status == task_entity.TaskStatus.completed 
                    ? Colors.green 
                    : colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    task.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      decoration: task.status == task_entity.TaskStatus.completed 
                        ? TextDecoration.lineThrough 
                        : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: task.status == task_entity.TaskStatus.completed 
                      ? Colors.green.withOpacity(0.1)
                      : colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.status == task_entity.TaskStatus.completed ? 'Completed' : 'In Progress',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: task.status == task_entity.TaskStatus.completed 
                        ? Colors.green[700]
                        : colorScheme.primary,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'ID: ${task.id}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}