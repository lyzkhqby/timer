import 'package:equatable/equatable.dart';

abstract class ProjectDetailEvent extends Equatable {
  const ProjectDetailEvent();

  @override
  List<Object> get props => [];
}

class GetProjectDetailEvent extends ProjectDetailEvent {
  final int projectId;

  const GetProjectDetailEvent(this.projectId);

  @override
  List<Object> get props => [projectId];
}

class RefreshProjectDetailEvent extends ProjectDetailEvent {
  final int projectId;

  const RefreshProjectDetailEvent(this.projectId);

  @override
  List<Object> get props => [projectId];
}