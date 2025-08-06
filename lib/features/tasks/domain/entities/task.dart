import 'package:equatable/equatable.dart';

enum TaskStatus { inProgress, completed }

class Task extends Equatable {
  final int id;
  final String name;
  final TaskStatus status;
  final int projectId;

  const Task({
    required this.id,
    required this.name,
    required this.status,
    required this.projectId,
  });

  Task copyWith({
    int? id,
    String? name,
    TaskStatus? status,
    int? projectId,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      projectId: projectId ?? this.projectId,
    );
  }

  @override
  List<Object> get props => [id, name, status, projectId];
}