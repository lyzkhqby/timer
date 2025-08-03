import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final int id;
  final String name;
  final DateTime startTime;
  final DateTime? estimatedEndTime;
  final int taskCount;

  const Project({
    required this.id,
    required this.name,
    required this.startTime,
    this.estimatedEndTime,
    required this.taskCount,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        startTime,
        estimatedEndTime,
        taskCount,
      ];
}