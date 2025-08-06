import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

// Core
import 'core/network/api_client.dart';

// Features - Task
import 'features/tasks/data/datasources/task_remote_data_source.dart';
import 'features/tasks/data/repositories/task_repository_impl.dart';
import 'features/tasks/domain/repositories/task_repository.dart';
import 'features/tasks/domain/usecases/get_tasks_by_project_id.dart';
import 'features/tasks/presentation/bloc/task_bloc.dart';



// Projects
import 'features/projects/data/datasources/project_remote_data_source.dart';
import 'features/projects/data/repositories/project_repository_impl.dart';
import 'features/projects/domain/repositories/project_repository.dart';
import 'features/projects/domain/usecases/get_all_projects.dart';
import 'features/projects/domain/usecases/get_project_by_id.dart';
import 'features/projects/presentation/bloc/projects_bloc.dart';
import 'features/projects/presentation/bloc/project_detail_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features
  _initProjects();

  // Features - Task
  _initTask();

  // Core
  _initCore();

  // External
  await _initExternal();
}

void _initProjects() {
  // BLoC
  sl.registerFactory(
    () => ProjectsBloc(
      getAllProjects: sl(),
    ),
  );
  
  sl.registerFactory(
    () => ProjectDetailBloc(
      getProjectById: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllProjects(sl()));
  sl.registerLazySingleton(() => GetProjectById(sl()));

  // Repository
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(
      dio: sl(),
    ),
  );
}

void _initTask() {
  // BLoC
  sl.registerFactory(
    () => TaskBloc(
      getTasksByProjectId: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTasksByProjectId(sl()));

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(apiClient: sl()),
  );
}

void _initCore() {
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => Dio());
}

Future<void> _initExternal() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
