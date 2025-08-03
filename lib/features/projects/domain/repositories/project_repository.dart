import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/project.dart';

abstract class ProjectRepository {
  Future<Either<Failure, List<Project>>> getAllProjects();
  Future<Either<Failure, Project>> getProjectById(int id);
  Future<Either<Failure, Project>> createProject({
    required String name,
    required DateTime startTime,
    DateTime? estimatedEndTime,
  });
  Future<Either<Failure, Project>> updateProject({
    required int id,
    required String name,
    required DateTime startTime,
    DateTime? estimatedEndTime,
  });
  Future<Either<Failure, Unit>> deleteProject(int id);
}