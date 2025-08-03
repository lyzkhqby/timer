import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getAllProjects();
  Future<ProjectModel> getProjectById(int id);
  Future<ProjectModel> createProject({
    required String name,
    required DateTime startTime,
    DateTime? estimatedEndTime,
  });
  Future<ProjectModel> updateProject({
    required int id,
    required String name,
    required DateTime startTime,
    DateTime? estimatedEndTime,
  });
  Future<void> deleteProject(int id);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'http://123.56.226.169:8083/api';

  ProjectRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProjectModel>> getAllProjects() async {
    try {
      final response = await dio.get('$baseUrl/projects');
      
      if (response.statusCode == 200) {
        final List<dynamic> projectsList = response.data;
        return projectsList
            .map((json) => ProjectModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw const ServerException('Failed to fetch projects');
      }
    } on DioException catch (e) {
      throw ServerException('Network error: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<ProjectModel> getProjectById(int id) async {
    try {
      final response = await dio.get('$baseUrl/projects/$id');
      
      if (response.statusCode == 200) {
        return ProjectModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw NotFoundException('Project with ID $id not found');
      } else {
        throw const ServerException('Failed to fetch project');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException('Project with ID $id not found');
      }
      throw ServerException('Network error: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<ProjectModel> createProject({
    required String name,
    required DateTime startTime,
    DateTime? estimatedEndTime,
  }) async {
    try {
      final data = {
        'name': name,
        'startTime': startTime.toIso8601String(),
        if (estimatedEndTime != null) 
          'estimatedEndTime': estimatedEndTime.toIso8601String(),
      };

      final response = await dio.post(
        '$baseUrl/projects',
        data: data,
      );
      
      if (response.statusCode == 201) {
        return ProjectModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw const ServerException('Failed to create project');
      }
    } on DioException catch (e) {
      throw ServerException('Network error: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<ProjectModel> updateProject({
    required int id,
    required String name,
    required DateTime startTime,
    DateTime? estimatedEndTime,
  }) async {
    try {
      final data = {
        'name': name,
        'startTime': startTime.toIso8601String(),
        if (estimatedEndTime != null) 
          'estimatedEndTime': estimatedEndTime.toIso8601String(),
      };

      final response = await dio.put(
        '$baseUrl/projects/$id',
        data: data,
      );
      
      if (response.statusCode == 200) {
        return ProjectModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw NotFoundException('Project with ID $id not found');
      } else {
        throw const ServerException('Failed to update project');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException('Project with ID $id not found');
      }
      throw ServerException('Network error: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteProject(int id) async {
    try {
      final response = await dio.delete('$baseUrl/projects/$id');
      
      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 404) {
        throw NotFoundException('Project with ID $id not found');
      } else {
        throw const ServerException('Failed to delete project');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException('Project with ID $id not found');
      }
      throw ServerException('Network error: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}