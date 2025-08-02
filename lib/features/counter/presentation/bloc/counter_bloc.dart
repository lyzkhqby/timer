import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/base_bloc.dart';
import '../../domain/entities/counter.dart';
import '../../domain/usecases/get_counter.dart';
import '../../domain/usecases/increment_counter.dart';
import '../../domain/usecases/decrement_counter.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends BaseBloc<CounterEvent, CounterState> {
  final GetCounter getCounter;
  final IncrementCounter incrementCounter;
  final DecrementCounter decrementCounter;
  
  CounterBloc({
    required this.getCounter,
    required this.incrementCounter,
    required this.decrementCounter,
  }) : super(const CounterInitial()) {
    on<LoadCounter>(_onLoadCounter);
    on<IncrementCounterEvent>(_onIncrementCounter);
    on<DecrementCounterEvent>(_onDecrementCounter);
    on<ResetCounterEvent>(_onResetCounter);
  }
  
  Future<void> _onLoadCounter(LoadCounter event, Emitter<CounterState> emit) async {
    emit(const CounterLoading());
    
    final result = await getCounter();
    result.fold(
      (failure) => emit(CounterError(failure.message)),
      (counter) => emit(CounterLoaded(counter)),
    );
  }
  
  Future<void> _onIncrementCounter(IncrementCounterEvent event, Emitter<CounterState> emit) async {
    if (state is CounterLoaded) {
      emit(const CounterLoading());
      
      final result = await incrementCounter();
      result.fold(
        (failure) => emit(CounterError(failure.message)),
        (counter) => emit(CounterLoaded(counter)),
      );
    }
  }
  
  Future<void> _onDecrementCounter(DecrementCounterEvent event, Emitter<CounterState> emit) async {
    if (state is CounterLoaded) {
      emit(const CounterLoading());
      
      final result = await decrementCounter();
      result.fold(
        (failure) => emit(CounterError(failure.message)),
        (counter) => emit(CounterLoaded(counter)),
      );
    }
  }
  
  Future<void> _onResetCounter(ResetCounterEvent event, Emitter<CounterState> emit) async {
    if (state is CounterLoaded) {
      emit(const CounterLoading());
      
      // For reset, we'll just load the counter again after resetting
      final result = await getCounter();
      result.fold(
        (failure) => emit(CounterError(failure.message)),
        (counter) => emit(CounterLoaded(Counter(value: 0, lastUpdated: DateTime.now()))),
      );
    }
  }
}
