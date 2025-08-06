import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/base_bloc.dart';
import '../../domain/usecases/get_tasks_by_project_id.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends BaseBloc<TaskEvent, TaskState> {
  final GetTasksByProjectId getTasksByProjectId;

  TaskBloc({
    required this.getTasksByProjectId,
  }) : super(const TaskInitial()) {
    on<GetTasksByProjectIdEvent>(_onGetTasksByProjectId);
  }

  Future<void> _onGetTasksByProjectId(GetTasksByProjectIdEvent event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());

    final result = await getTasksByProjectId(event.projectId);
    result.fold(
      (failure) => emit(TaskError(failure.message)),
      (tasks) => emit(TaskLoaded(tasks)),
    );
  }
}