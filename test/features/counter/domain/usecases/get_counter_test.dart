import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scaffold_app/core/error/failures.dart';
import 'package:scaffold_app/features/counter/domain/entities/counter.dart';
import 'package:scaffold_app/features/counter/domain/repositories/counter_repository.dart';
import 'package:scaffold_app/features/counter/domain/usecases/get_counter.dart';

class MockCounterRepository extends Mock implements CounterRepository {}

void main() {
  late GetCounter usecase;
  late MockCounterRepository mockCounterRepository;

  setUp(() {
    mockCounterRepository = MockCounterRepository();
    usecase = GetCounter(mockCounterRepository);
  });

  final tCounter = Counter(
    value: 42,
    lastUpdated: DateTime(2023, 1, 1),
  );

  test('should get counter from the repository', () async {
    // arrange
    when(() => mockCounterRepository.getCounter())
        .thenAnswer((_) async => Right(tCounter));

    // act
    final result = await usecase();

    // assert
    expect(result, Right(tCounter));
    verify(() => mockCounterRepository.getCounter());
    verifyNoMoreInteractions(mockCounterRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    const tFailure = CacheFailure('Cache error');
    when(() => mockCounterRepository.getCounter())
        .thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await usecase();

    // assert
    expect(result, const Left(tFailure));
    verify(() => mockCounterRepository.getCounter());
    verifyNoMoreInteractions(mockCounterRepository);
  });
}
