import '../../domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.startTime,
    super.estimatedEndTime,
    required super.taskCount,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as int,
      name: json['name'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      estimatedEndTime: json['estimatedEndTime'] != null
          ? DateTime.parse(json['estimatedEndTime'] as String)
          : null,
      taskCount: json['taskCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime.toIso8601String(),
      'estimatedEndTime': estimatedEndTime?.toIso8601String(),
      'taskCount': taskCount,
    };
  }

  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      id: project.id,
      name: project.name,
      startTime: project.startTime,
      estimatedEndTime: project.estimatedEndTime,
      taskCount: project.taskCount,
    );
  }
}