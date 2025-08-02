import '../../../../core/bloc/base_state.dart';
import '../../domain/entities/user.dart';

abstract class UserState extends BaseState {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UsersLoaded extends UserState {
  final List<User> users;

  const UsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}

class UserOperationSuccess extends UserState {
  final String message;

  const UserOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}