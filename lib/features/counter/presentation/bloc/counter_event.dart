import '../../../../core/bloc/base_event.dart';

abstract class CounterEvent extends BaseEvent {
  const CounterEvent();
}

class LoadCounter extends CounterEvent {
  const LoadCounter();
}

class IncrementCounterEvent extends CounterEvent {
  const IncrementCounterEvent();
}

class DecrementCounterEvent extends CounterEvent {
  const DecrementCounterEvent();
}

class ResetCounterEvent extends CounterEvent {
  const ResetCounterEvent();
}
