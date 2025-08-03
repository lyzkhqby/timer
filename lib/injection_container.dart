import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

// Core
import 'core/network/api_client.dart';

// Projects
import 'features/projects/data/datasources/project_remote_data_source.dart';
import 'features/projects/data/repositories/project_repository_impl.dart';
import 'features/projects/domain/repositories/project_repository.dart';
import 'features/projects/domain/usecases/get_all_projects.dart';
import 'features/projects/presentation/bloc/projects_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features
  _initProjects();

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

  // Use cases
  sl.registerLazySingleton(() => GetAllProjects(sl()));

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

void _initCore() {
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => Dio());
}

Future<void> _initExternal() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
