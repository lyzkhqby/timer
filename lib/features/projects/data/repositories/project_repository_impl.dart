import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_remote_data_source.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Project>>> getAllProjects() async {
    try {
      final projects = await remoteDataSource.getAllProjects();
      return Right(projects);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Project>> getProjectById(int id) async {
    try {
      final project = await remoteDataSource.getProjectById(id);
      return Right(project);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Project>> createProject({
    required String name,
    required DateTime startTime,
    DateTime? estimatedEndTime,
  }) async {
    try {
      final project = await remoteDataSource.createProject(
        name: name,
        startTime: startTime,
        estimatedEndTime: estimatedEndTime,
      );
      return Right(project);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Project>> updateProject({
    required int id,
    required String name,
    required DateTime startTime,
    DateTime? estimatedEndTime,
  }) async {
    try {
      final project = await remoteDataSource.updateProject(
        id: id,
        name: name,
        startTime: startTime,
        estimatedEndTime: estimatedEndTime,
      );
      return Right(project);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProject(int id) async {
    try {
      await remoteDataSource.deleteProject(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}