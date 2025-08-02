import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scaffold_app/core/error/failures.dart';
import 'package:scaffold_app/features/counter/domain/entities/counter.dart';
import 'package:scaffold_app/features/counter/domain/usecases/get_counter.dart';
import 'package:scaffold_app/features/counter/domain/usecases/increment_counter.dart';
import 'package:scaffold_app/features/counter/domain/usecases/decrement_counter.dart';
import 'package:scaffold_app/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:scaffold_app/features/counter/presentation/bloc/counter_event.dart';
import 'package:scaffold_app/features/counter/presentation/bloc/counter_state.dart';

class MockGetCounter extends Mock implements GetCounter {}
class MockIncrementCounter extends Mock implements IncrementCounter {}
class MockDecrementCounter extends Mock implements DecrementCounter {}

void main() {
  late CounterBloc bloc;
  late MockGetCounter mockGetCounter;
  late MockIncrementCounter mockIncrementCounter;
  late MockDecrementCounter mockDecrementCounter;

  setUp(() {
    mockGetCounter = MockGetCounter();
    mockIncrementCounter = MockIncrementCounter();
    mockDecrementCounter = MockDecrementCounter();
    bloc = CounterBloc(
      getCounter: mockGetCounter,
      incrementCounter: mockIncrementCounter,
      decrementCounter: mockDecrementCounter,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be CounterInitial', () {
    expect(bloc.state, equals(const CounterInitial()));
  });

  final tCounter = Counter(
    value: 42,
    lastUpdated: DateTime(2023, 1, 1),
  );

  group('LoadCounter', () {
    blocTest<CounterBloc, CounterState>(
      'should emit [CounterLoading, CounterLoaded] when data is gotten successfully',
      build: () {
        when(() => mockGetCounter()).thenAnswer((_) async => Right(tCounter));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadCounter()),
      expect: () => [
        const CounterLoading(),
        CounterLoaded(tCounter),
      ],
      verify: (_) {
        verify(() => mockGetCounter());
      },
    );

    blocTest<CounterBloc, CounterState>(
      'should emit [CounterLoading, CounterError] when getting data fails',
      build: () {
        when(() => mockGetCounter())
            .thenAnswer((_) async => const Left(CacheFailure('Cache error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadCounter()),
      expect: () => [
        const CounterLoading(),
        const CounterError('Cache error'),
      ],
      verify: (_) {
        verify(() => mockGetCounter());
      },
    );
  });

  group('IncrementCounter', () {
    final tIncrementedCounter = Counter(
      value: 43,
      lastUpdated: DateTime(2023, 1, 1),
    );

    blocTest<CounterBloc, CounterState>(
      'should emit [CounterLoading, CounterLoaded] when increment is successful',
      build: () {
        when(() => mockIncrementCounter())
            .thenAnswer((_) async => Right(tIncrementedCounter));
        return bloc;
      },
      seed: () => CounterLoaded(tCounter),
      act: (bloc) => bloc.add(const IncrementCounterEvent()),
      expect: () => [
        const CounterLoading(),
        CounterLoaded(tIncrementedCounter),
      ],
      verify: (_) {
        verify(() => mockIncrementCounter());
      },
    );

    blocTest<CounterBloc, CounterState>(
      'should emit [CounterLoading, CounterError] when increment fails',
      build: () {
        when(() => mockIncrementCounter())
            .thenAnswer((_) async => const Left(CacheFailure('Cache error')));
        return bloc;
      },
      seed: () => CounterLoaded(tCounter),
      act: (bloc) => bloc.add(const IncrementCounterEvent()),
      expect: () => [
        const CounterLoading(),
        const CounterError('Cache error'),
      ],
      verify: (_) {
        verify(() => mockIncrementCounter());
      },
    );
  });

  group('DecrementCounter', () {
    final tDecrementedCounter = Counter(
      value: 41,
      lastUpdated: DateTime(2023, 1, 1),
    );

    blocTest<CounterBloc, CounterState>(
      'should emit [CounterLoading, CounterLoaded] when decrement is successful',
      build: () {
        when(() => mockDecrementCounter())
            .thenAnswer((_) async => Right(tDecrementedCounter));
        return bloc;
      },
      seed: () => CounterLoaded(tCounter),
      act: (bloc) => bloc.add(const DecrementCounterEvent()),
      expect: () => [
        const CounterLoading(),
        CounterLoaded(tDecrementedCounter),
      ],
      verify: (_) {
        verify(() => mockDecrementCounter());
      },
    );

    blocTest<CounterBloc, CounterState>(
      'should emit [CounterLoading, CounterError] when decrement fails',
      build: () {
        when(() => mockDecrementCounter())
            .thenAnswer((_) async => const Left(CacheFailure('Cache error')));
        return bloc;
      },
      seed: () => CounterLoaded(tCounter),
      act: (bloc) => bloc.add(const DecrementCounterEvent()),
      expect: () => [
        const CounterLoading(),
        const CounterError('Cache error'),
      ],
      verify: (_) {
        verify(() => mockDecrementCounter());
      },
    );
  });
}
