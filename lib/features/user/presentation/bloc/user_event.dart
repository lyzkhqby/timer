import '../../../../core/bloc/base_event.dart';

abstract class UserEvent extends BaseEvent {
  const UserEvent();
}

class LoadUsers extends UserEvent {
  const LoadUsers();
}

class LoadUserById extends UserEvent {
  final int id;

  const LoadUserById(this.id);

  @override
  List<Object> get props => [id];
}

class CreateUserEvent extends UserEvent {
  final String name;

  const CreateUserEvent(this.name);

  @override
  List<Object> get props => [name];
}

class UpdateUserEvent extends UserEvent {
  final int id;
  final String name;

  const UpdateUserEvent(this.id, this.name);

  @override
  List<Object> get props => [id, name];
}

class DeleteUserEvent extends UserEvent {
  final int id;

  const DeleteUserEvent(this.id);

  @override
  List<Object> get props => [id];
}