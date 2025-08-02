import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/counter.dart';
import '../repositories/counter_repository.dart';

class IncrementCounter {
  final CounterRepository repository;
  
  IncrementCounter(this.repository);
  
  Future<Either<Failure, Counter>> call() async {
    return await repository.incrementCounter();
  }
}
