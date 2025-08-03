import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_projects.dart';
import 'projects_event.dart';
import 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final GetAllProjects getAllProjects;

  ProjectsBloc({
    required this.getAllProjects,
  }) : super(ProjectsInitial()) {
    on<GetAllProjectsEvent>(_onGetAllProjects);
    on<RefreshProjectsEvent>(_onRefreshProjects);
  }

  Future<void> _onGetAllProjects(
    GetAllProjectsEvent event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(ProjectsLoading());
    
    final result = await getAllProjects();
    
    result.fold(
      (failure) => emit(ProjectsError(failure.message)),
      (projects) {
        if (projects.isEmpty) {
          emit(ProjectsEmpty());
        } else {
          emit(ProjectsLoaded(projects));
        }
      },
    );
  }

  Future<void> _onRefreshProjects(
    RefreshProjectsEvent event,
    Emitter<ProjectsState> emit,
  ) async {
    final result = await getAllProjects();
    
    result.fold(
      (failure) => emit(ProjectsError(failure.message)),
      (projects) {
        if (projects.isEmpty) {
          emit(ProjectsEmpty());
        } else {
          emit(ProjectsLoaded(projects));
        }
      },
    );
  }
}