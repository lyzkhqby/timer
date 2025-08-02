import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/logger.dart';
import 'base_event.dart';
import 'base_state.dart';

abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<Event, State> {
  BaseBloc(super.initialState);
  
  
  @override
  void onTransition(Transition<Event, State> transition) {
    super.onTransition(transition);
    Logger.debug(
      'Transition: ${transition.currentState.runtimeType} -> ${transition.nextState.runtimeType}',
    );
  }
  
  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    Logger.error(
      'BLoC Error in $runtimeType',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
