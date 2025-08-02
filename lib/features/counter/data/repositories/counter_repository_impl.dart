import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/counter.dart';
import '../../domain/repositories/counter_repository.dart';
import '../datasources/counter_local_data_source.dart';
import '../models/counter_model.dart';

class CounterRepositoryImpl implements CounterRepository {
  final CounterLocalDataSource localDataSource;
  
  CounterRepositoryImpl({required this.localDataSource});
  
  @override
  Future<Either<Failure, Counter>> getCounter() async {
    try {
      final counter = await localDataSource.getCounter();
      return Right(counter);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Counter>> incrementCounter() async {
    try {
      final currentCounter = await localDataSource.getCounter();
      final newCounter = CounterModel(
        value: currentCounter.value + 1,
        lastUpdated: DateTime.now(),
      );
      await localDataSource.cacheCounter(newCounter);
      return Right(newCounter);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Counter>> decrementCounter() async {
    try {
      final currentCounter = await localDataSource.getCounter();
      final newCounter = CounterModel(
        value: currentCounter.value - 1,
        lastUpdated: DateTime.now(),
      );
      await localDataSource.cacheCounter(newCounter);
      return Right(newCounter);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> resetCounter() async {
    try {
      final newCounter = CounterModel(
        value: 0,
        lastUpdated: DateTime.now(),
      );
      await localDataSource.cacheCounter(newCounter);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
