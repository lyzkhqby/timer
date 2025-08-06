import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/task.dart' as task_entity;
import '../repositories/task_repository.dart';

class GetTasks {
  final TaskRepository _repository;

  GetTasks(this._repository);

  Future<Either<Failure, List<task_entity.Task>>> call() async {
    return await _repository.getTasks();
  }
}