import 'package:equatable/equatable.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object> get props => [];
}

class GetAllProjectsEvent extends ProjectsEvent {}

class RefreshProjectsEvent extends ProjectsEvent {}

class GetProjectByIdEvent extends ProjectsEvent {
  final int id;

  const GetProjectByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}