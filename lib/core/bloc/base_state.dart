import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  const BaseState();
  
  @override
  List<Object?> get props => [];
}

class InitialState extends BaseState {
  const InitialState();
}
