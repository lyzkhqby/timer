import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timer/core/error/exceptions.dart';
import 'package:timer/core/error/failures.dart';
import 'package:timer/features/counter/data/datasources/counter_local_data_source.dart';
import 'package:timer/features/counter/data/models/counter_model.dart';
import 'package:timer/features/counter/data/repositories/counter_repository_impl.dart';

class MockCounterLocalDataSource extends Mock implements CounterLocalDataSource {}

void main() {
  late CounterRepositoryImpl repository;
  late MockCounterLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockCounterLocalDataSource();
    repository = CounterRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  final tCounterModel = CounterModel(
    value: 42,
    lastUpdated: DateTime(2023, 1, 1),
  );

  group('getCounter', () {
    test('should return counter when the call to local data source is successful', () async {
      // arrange
      when(() => mockLocalDataSource.getCounter())
          .thenAnswer((_) async => tCounterModel);

      // act
      final result = await repository.getCounter();

      // assert
      verify(() => mockLocalDataSource.getCounter());
      expect(result, equals(Right(tCounterModel)));
    });

    test('should return CacheFailure when the call to local data source throws CacheException', () async {
      // arrange
      when(() => mockLocalDataSource.getCounter())
          .thenThrow(const CacheException('Cache error'));

      // act
      final result = await repository.getCounter();

      // assert
      verify(() => mockLocalDataSource.getCounter());
      expect(result, equals(const Left(CacheFailure('Cache error'))));
    });
  });

  group('incrementCounter', () {
    test('should return incremented counter when successful', () async {
      // arrange
      when(() => mockLocalDataSource.getCounter())
          .thenAnswer((_) async => tCounterModel);
      when(() => mockLocalDataSource.cacheCounter(any()))
          .thenAnswer((_) async {});

      // act
      final result = await repository.incrementCounter();

      // assert
      verify(() => mockLocalDataSource.getCounter());
      verify(() => mockLocalDataSource.cacheCounter(any()));
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (counter) => expect(counter.value, equals(43)),
      );
    });

    test('should return CacheFailure when caching fails', () async {
      // arrange
      when(() => mockLocalDataSource.getCounter())
          .thenAnswer((_) async => tCounterModel);
      when(() => mockLocalDataSource.cacheCounter(any()))
          .thenThrow(const CacheException('Cache error'));

      // act
      final result = await repository.incrementCounter();

      // assert
      expect(result, equals(const Left(CacheFailure('Cache error'))));
    });
  });

  group('decrementCounter', () {
    test('should return decremented counter when successful', () async {
      // arrange
      when(() => mockLocalDataSource.getCounter())
          .thenAnswer((_) async => tCounterModel);
      when(() => mockLocalDataSource.cacheCounter(any()))
          .thenAnswer((_) async {});

      // act
      final result = await repository.decrementCounter();

      // assert
      verify(() => mockLocalDataSource.getCounter());
      verify(() => mockLocalDataSource.cacheCounter(any()));
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (counter) => expect(counter.value, equals(41)),
      );
    });
  });

  group('resetCounter', () {
    test('should return success when reset is successful', () async {
      // arrange
      when(() => mockLocalDataSource.cacheCounter(any()))
          .thenAnswer((_) async {});

      // act
      final result = await repository.resetCounter();

      // assert
      verify(() => mockLocalDataSource.cacheCounter(any()));
      expect(result, equals(const Right(null)));
    });
  });
}
