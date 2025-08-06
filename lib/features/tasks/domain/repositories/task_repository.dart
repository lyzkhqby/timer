import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/task.dart' as task_entity;

abstract class TaskRepository {
  Future<Either<Failure, List<task_entity.Task>>> getTasks();
  Future<Either<Failure, List<task_entity.Task>>> getTasksByProjectId(int projectId);
}