import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/base_bloc.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_product_by_id.dart';
import '../../domain/usecases/create_product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends BaseBloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final GetProductById getProductById;
  final CreateProduct createProduct;

  ProductBloc({
    required this.getProducts,
    required this.getProductById,
    required this.createProduct,
  }) : super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductById>(_onLoadProductById);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());

    final result = await getProducts();
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductsLoaded(products)),
    );
  }

  Future<void> _onLoadProductById(LoadProductById event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());

    final result = await getProductById(event.id);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (product) => emit(ProductLoaded(product)),
    );
  }

  Future<void> _onCreateProduct(CreateProductEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());

    final newProduct = Product(
      id: 0, // Will be set by the server
      name: event.name,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await createProduct(newProduct);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (product) => emit(const ProductOperationSuccess('Product created successfully')),
    );
  }

  Future<void> _onUpdateProduct(UpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());

    // TODO: Implement update product use case
    // For now, just emit success
    emit(const ProductOperationSuccess('Product updated successfully'));
  }

  Future<void> _onDeleteProduct(DeleteProductEvent event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());

    // TODO: Implement delete product use case
    // For now, just emit success
    emit(const ProductOperationSuccess('Product deleted successfully'));
  }
}