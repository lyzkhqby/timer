import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/project.dart';
import '../repositories/project_repository.dart';

class GetAllProjects {
  final ProjectRepository repository;

  GetAllProjects(this.repository);

  Future<Either<Failure, List<Project>>> call() async {
    return await repository.getAllProjects();
  }
}