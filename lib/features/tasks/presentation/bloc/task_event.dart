import '../../../../core/bloc/base_event.dart';

abstract class TaskEvent extends BaseEvent {
  const TaskEvent();
}

class GetTasksByProjectIdEvent extends TaskEvent {
  final int projectId;

  const GetTasksByProjectIdEvent(this.projectId);

  @override
  List<Object> get props => [projectId];
}
