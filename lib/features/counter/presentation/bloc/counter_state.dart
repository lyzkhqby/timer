import '../../../../core/bloc/base_state.dart';
import '../../domain/entities/counter.dart';

abstract class CounterState extends BaseState {
  const CounterState();
}

class CounterInitial extends CounterState {
  const CounterInitial();
}

class CounterLoading extends CounterState {
  const CounterLoading();
}

class CounterLoaded extends CounterState {
  final Counter counter;
  
  const CounterLoaded(this.counter);
  
  @override
  List<Object> get props => [counter];
}

class CounterError extends CounterState {
  final String message;
  
  const CounterError(this.message);
  
  @override
  List<Object> get props => [message];
}
