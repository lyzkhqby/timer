import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/base_bloc.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/get_user_by_id.dart';
import '../../domain/usecases/create_user.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends BaseBloc<UserEvent, UserState> {
  final GetUsers getUsers;
  final GetUserById getUserById;
  final CreateUser createUser;

  UserBloc({
    required this.getUsers,
    required this.getUserById,
    required this.createUser,
  }) : super(const UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadUserById>(_onLoadUserById);
    on<CreateUserEvent>(_onCreateUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(const UserLoading());

    final result = await getUsers();
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (users) => emit(UsersLoaded(users)),
    );
  }

  Future<void> _onLoadUserById(LoadUserById event, Emitter<UserState> emit) async {
    emit(const UserLoading());

    final result = await getUserById(event.id);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> _onCreateUser(CreateUserEvent event, Emitter<UserState> emit) async {
    emit(const UserLoading());

    final newUser = User(
      id: 0, // Will be set by the server
      name: event.name,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await createUser(newUser);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(const UserOperationSuccess('User created successfully')),
    );
  }

  Future<void> _onUpdateUser(UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(const UserLoading());

    // TODO: Implement update user use case
    // For now, just emit success
    emit(const UserOperationSuccess('User updated successfully'));
  }

  Future<void> _onDeleteUser(DeleteUserEvent event, Emitter<UserState> emit) async {
    emit(const UserLoading());

    // TODO: Implement delete user use case
    // For now, just emit success
    emit(const UserOperationSuccess('User deleted successfully'));
  }
}