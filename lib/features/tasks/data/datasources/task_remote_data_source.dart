import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<List<TaskModel>> getTasksByProjectId(int projectId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final ApiClient apiClient;
  
  TaskRemoteDataSourceImpl({required this.apiClient});
  
  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await apiClient.get('/tasks');
      final List<dynamic> data = response.data;
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<TaskModel>> getTasksByProjectId(int projectId) async {
    try {
      final response = await apiClient.get('/projects/$projectId/tasks');
      final List<dynamic> data = response.data;
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}