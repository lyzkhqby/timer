import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/project.dart';
import '../repositories/project_repository.dart';

class GetProjectById {
  final ProjectRepository repository;

  GetProjectById(this.repository);

  Future<Either<Failure, Project>> call(int projectId) async {
    return await repository.getProjectById(projectId);
  }
}