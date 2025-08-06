import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.name,
    required super.status,
    required super.projectId,
  });
  
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: TaskStatus.values[json['status'] as int],
      projectId: json['projectId'] as int,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status.index,
      'projectId': projectId,
    };
  }
  
  factory TaskModel.fromEntity(Task entity) {
    return TaskModel(
      id: entity.id,
      name: entity.name,
      status: entity.status,
      projectId: entity.projectId,
    );
  }
}