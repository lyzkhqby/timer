import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(int id);
  Future<ProductModel> createProduct(ProductModel model);
  Future<ProductModel> updateProduct(ProductModel model);
  Future<void> deleteProduct(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;
  
  ProductRemoteDataSourceImpl({required this.apiClient});
  
  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await apiClient.get('/products');
      final List<dynamic> data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await apiClient.get('/products/$id');
      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<ProductModel> createProduct(ProductModel model) async {
    try {
      final response = await apiClient.post('/products', data: model.toJson());
      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<ProductModel> updateProduct(ProductModel model) async {
    try {
      final response = await apiClient.put('/products/${model.id}', data: model.toJson());
      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<void> deleteProduct(int id) async {
    try {
      await apiClient.delete('/products/$id');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}