import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_project_by_id.dart';
import 'project_detail_event.dart';
import 'project_detail_state.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final GetProjectById getProjectById;

  ProjectDetailBloc({
    required this.getProjectById,
  }) : super(ProjectDetailInitial()) {
    on<GetProjectDetailEvent>(_onGetProjectDetail);
    on<RefreshProjectDetailEvent>(_onRefreshProjectDetail);
  }

  Future<void> _onGetProjectDetail(
    GetProjectDetailEvent event,
    Emitter<ProjectDetailState> emit,
  ) async {
    emit(ProjectDetailLoading());
    
    final failureOrProject = await getProjectById(event.projectId);
    
    failureOrProject.fold(
      (failure) => emit(ProjectDetailError(_mapFailureToMessage(failure))),
      (project) => emit(ProjectDetailLoaded(project)),
    );
  }

  Future<void> _onRefreshProjectDetail(
    RefreshProjectDetailEvent event,
    Emitter<ProjectDetailState> emit,
  ) async {
    final failureOrProject = await getProjectById(event.projectId);
    
    failureOrProject.fold(
      (failure) => emit(ProjectDetailError(_mapFailureToMessage(failure))),
      (project) => emit(ProjectDetailLoaded(project)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return '服务器错误，请稍后重试';
    } else if (failure is NetworkFailure) {
      return '网络连接失败，请检查网络';
    } else if (failure is NotFoundFailure) {
      return '项目不存在';
    } else {
      return '未知错误，请重试';
    }
  }
}