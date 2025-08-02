import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUserById(int id);
  Future<UserModel> createUser(UserModel model);
  Future<UserModel> updateUser(UserModel model);
  Future<void> deleteUser(int id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient apiClient;
  
  UserRemoteDataSourceImpl({required this.apiClient});
  
  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await apiClient.get('/users');
      final List<dynamic> data = response.data;
      return data.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<UserModel> getUserById(int id) async {
    try {
      final response = await apiClient.get('/users/$id');
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<UserModel> createUser(UserModel model) async {
    try {
      final response = await apiClient.post('/users', data: model.toJson());
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<UserModel> updateUser(UserModel model) async {
    try {
      final response = await apiClient.put('/users/${model.id}', data: model.toJson());
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<void> deleteUser(int id) async {
    try {
      await apiClient.delete('/users/$id');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}