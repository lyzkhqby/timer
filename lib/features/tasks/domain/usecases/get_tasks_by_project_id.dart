import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/task.dart' as task_entity;
import '../repositories/task_repository.dart';

class GetTasksByProjectId {
  final TaskRepository repository;

  GetTasksByProjectId(this.repository);

  Future<Either<Failure, List<task_entity.Task>>> call(int projectId) async {
    return await repository.getTasksByProjectId(projectId);
  }
}