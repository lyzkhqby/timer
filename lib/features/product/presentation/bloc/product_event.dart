import '../../../../core/bloc/base_event.dart';

abstract class ProductEvent extends BaseEvent {
  const ProductEvent();
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class LoadProductById extends ProductEvent {
  final int id;

  const LoadProductById(this.id);

  @override
  List<Object> get props => [id];
}

class CreateProductEvent extends ProductEvent {
  final String name;

  const CreateProductEvent(this.name);

  @override
  List<Object> get props => [name];
}

class UpdateProductEvent extends ProductEvent {
  final int id;
  final String name;

  const UpdateProductEvent(this.id, this.name);

  @override
  List<Object> get props => [id, name];
}

class DeleteProductEvent extends ProductEvent {
  final int id;

  const DeleteProductEvent(this.id);

  @override
  List<Object> get props => [id];
}