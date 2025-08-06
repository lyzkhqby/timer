import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/task.dart' as task_entity;
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  
  TaskRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<Either<Failure, List<task_entity.Task>>> getTasks() async {
    try {
      final models = await remoteDataSource.getTasks();
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<task_entity.Task>>> getTasksByProjectId(int projectId) async {
    try {
      final models = await remoteDataSource.getTasksByProjectId(projectId);
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}