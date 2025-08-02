class FeatureTemplates {
  static String generateModel(String entityNamePascal, String entityNameLower) {
    return '''import '../../domain/entities/$entityNameLower.dart';

class ${entityNamePascal}Model extends $entityNamePascal {
  const ${entityNamePascal}Model({
    required super.id,
  });
  
  factory ${entityNamePascal}Model.fromJson(Map<String, dynamic> json) {
    return ${entityNamePascal}Model(
      id: json['id'] as int,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
  
  factory ${entityNamePascal}Model.fromEntity($entityNamePascal entity) {
    return ${entityNamePascal}Model(
      id: entity.id,
    );
  }
}''';
  }
  
  static String generateDataSource(String entityNamePascal, String entityNameLower) {
    return '''import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/${entityNameLower}_model.dart';

abstract class ${entityNamePascal}RemoteDataSource {
  Future<List<${entityNamePascal}Model>> get${entityNamePascal}s();
}

class ${entityNamePascal}RemoteDataSourceImpl implements ${entityNamePascal}RemoteDataSource {
  final ApiClient apiClient;
  
  ${entityNamePascal}RemoteDataSourceImpl({required this.apiClient});
  
  @override
  Future<List<${entityNamePascal}Model>> get${entityNamePascal}s() async {
    try {
      final response = await apiClient.get('/${entityNameLower}s');
      final List<dynamic> data = response.data;
      return data.map((json) => ${entityNamePascal}Model.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}''';
  }
  
  static String generateRepositoryImpl(String entityNamePascal, String entityNameLower) {
    return '''import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/$entityNameLower.dart';
import '../../domain/repositories/${entityNameLower}_repository.dart';
import '../datasources/${entityNameLower}_remote_data_source.dart';
import '../models/${entityNameLower}_model.dart';

class ${entityNamePascal}RepositoryImpl implements ${entityNamePascal}Repository {
  final ${entityNamePascal}RemoteDataSource remoteDataSource;
  
  ${entityNamePascal}RepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<Either<Failure, List<$entityNamePascal>>> get${entityNamePascal}s() async {
    try {
      final models = await remoteDataSource.get${entityNamePascal}s();
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
  
}''';
  }

  static String generateBlocEvent(String entityNamePascal, String entityNameLower) {
    return '''import '../../../../core/bloc/base_event.dart';

abstract class ${entityNamePascal}Event extends BaseEvent {
  const ${entityNamePascal}Event();
}

''';
  }

  static String generateEntity(String entityNamePascal, String entityNameLower) {
    return '''import 'package:equatable/equatable.dart';

class $entityNamePascal extends Equatable {
  final int id;

  const $entityNamePascal({
    required this.id,
  });

  $entityNamePascal copyWith({
    int? id,
  }) {
    return $entityNamePascal(
      id: id ?? this.id,
    );
  }

  @override
  List<Object> get props => [id];
}''';
  }

  static String generateRepository(String entityNamePascal, String entityNameLower) {
    return '''import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/$entityNameLower.dart';

abstract class ${entityNamePascal}Repository {
  Future<Either<Failure, List<$entityNamePascal>>> get${entityNamePascal}s();
}''';
  }

  static String generateGetEntitiesUseCase(String entityNamePascal, String entityNameLower) {
    return '''import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/$entityNameLower.dart';
import '../repositories/${entityNameLower}_repository.dart';

class Get${entityNamePascal}s {
  final ${entityNamePascal}Repository _repository;

  Get${entityNamePascal}s(this._repository);

  Future<Either<Failure, List<$entityNamePascal>>> call() async {
    return await _repository.get${entityNamePascal}s();
  }
}''';
  }

  static String generateBlocState(String entityNamePascal, String entityNameLower) {
    return '''import '../../../../core/bloc/base_state.dart';
import '../../domain/entities/$entityNameLower.dart';

abstract class ${entityNamePascal}State extends BaseState {
  const ${entityNamePascal}State();
}

class ${entityNamePascal}Initial extends ${entityNamePascal}State {
  const ${entityNamePascal}Initial();
}

''';
  }

  static String generateBloc(String entityNamePascal, String entityNameLower) {
    return '''import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/base_bloc.dart';
import '../../domain/entities/$entityNameLower.dart';
import '../../domain/usecases/get_${entityNameLower}s.dart';
import '../../domain/usecases/get_${entityNameLower}_by_id.dart';
import '../../domain/usecases/create_$entityNameLower.dart';
import '${entityNameLower}_event.dart';
import '${entityNameLower}_state.dart';

class ${entityNamePascal}Bloc extends BaseBloc<${entityNamePascal}Event, ${entityNamePascal}State> {
  final Get${entityNamePascal}s get${entityNamePascal}s;
  final Get${entityNamePascal}ById get${entityNamePascal}ById;
  final Create$entityNamePascal create$entityNamePascal;

  ${entityNamePascal}Bloc({
    required this.get${entityNamePascal}s,
    required this.get${entityNamePascal}ById,
    required this.create$entityNamePascal,
  }) : super(const ${entityNamePascal}Initial()) {
    on<Load${entityNamePascal}s>(_onLoad${entityNamePascal}s);
    on<Load${entityNamePascal}ById>(_onLoad${entityNamePascal}ById);
    on<Create${entityNamePascal}Event>(_onCreate$entityNamePascal);
    on<Update${entityNamePascal}Event>(_onUpdate$entityNamePascal);
    on<Delete${entityNamePascal}Event>(_onDelete$entityNamePascal);
  }

  Future<void> _onLoad${entityNamePascal}s(Load${entityNamePascal}s event, Emitter<${entityNamePascal}State> emit) async {
    emit(const ${entityNamePascal}Loading());

    final result = await get${entityNamePascal}s();
    result.fold(
      (failure) => emit(${entityNamePascal}Error(failure.message)),
      (${entityNameLower}s) => emit(${entityNamePascal}sLoaded(${entityNameLower}s)),
    );
  }

  Future<void> _onLoad${entityNamePascal}ById(Load${entityNamePascal}ById event, Emitter<${entityNamePascal}State> emit) async {
    emit(const ${entityNamePascal}Loading());

    final result = await get${entityNamePascal}ById(event.id);
    result.fold(
      (failure) => emit(${entityNamePascal}Error(failure.message)),
      ($entityNameLower) => emit(${entityNamePascal}Loaded($entityNameLower)),
    );
  }

  Future<void> _onCreate$entityNamePascal(Create${entityNamePascal}Event event, Emitter<${entityNamePascal}State> emit) async {
    emit(const ${entityNamePascal}Loading());

    final new$entityNamePascal = $entityNamePascal(
      id: 0, // Will be set by the server
    );

    final result = await create$entityNamePascal(new$entityNamePascal);
    result.fold(
      (failure) => emit(${entityNamePascal}Error(failure.message)),
      ($entityNameLower) => emit(const ${entityNamePascal}OperationSuccess('$entityNamePascal created successfully')),
    );
  }

  Future<void> _onUpdate$entityNamePascal(Update${entityNamePascal}Event event, Emitter<${entityNamePascal}State> emit) async {
    emit(const ${entityNamePascal}Loading());

    // TODO: Implement update $entityNameLower use case
    // For now, just emit success
    emit(const ${entityNamePascal}OperationSuccess('$entityNamePascal updated successfully'));
  }

  Future<void> _onDelete$entityNamePascal(Delete${entityNamePascal}Event event, Emitter<${entityNamePascal}State> emit) async {
    emit(const ${entityNamePascal}Loading());

    // TODO: Implement delete $entityNameLower use case
    // For now, just emit success
    emit(const ${entityNamePascal}OperationSuccess('$entityNamePascal deleted successfully'));
  }
}''';
  }

  static String generatePage(String entityNamePascal, String entityNameLower) {
    return '''import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/$entityNameLower.dart';
import '../bloc/${entityNameLower}_bloc.dart';
import '../bloc/${entityNameLower}_event.dart';
import '../bloc/${entityNameLower}_state.dart';
import '../widgets/${entityNameLower}_list_item.dart';

class ${entityNamePascal}Page extends StatelessWidget {
  const ${entityNamePascal}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${entityNamePascal}s'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<${entityNamePascal}Bloc>().add(const Load${entityNamePascal}s());
            },
          ),
        ],
      ),
      body: BlocBuilder<${entityNamePascal}Bloc, ${entityNamePascal}State>(
        builder: (context, state) {
          if (state is ${entityNamePascal}Initial) {
            // Load ${entityNameLower}s when page is first opened
            context.read<${entityNamePascal}Bloc>().add(const Load${entityNamePascal}s());
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ${entityNamePascal}Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ${entityNamePascal}Error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<${entityNamePascal}Bloc>().add(const Load${entityNamePascal}s());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ${entityNamePascal}sLoaded) {
            if (state.${entityNameLower}s.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No ${entityNamePascal}s',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No ${entityNameLower}s found. Create some ${entityNameLower}s to get started.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<${entityNamePascal}Bloc>().add(const Load${entityNamePascal}s());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.${entityNameLower}s.length,
                itemBuilder: (context, index) {
                  final $entityNameLower = state.${entityNameLower}s[index];
                  return ${entityNamePascal}ListItem(
                    $entityNameLower: $entityNameLower,
                    onTap: () {
                      // Navigate to $entityNameLower detail or show details
                      _show${entityNamePascal}Details(context, $entityNameLower);
                    },
                    onEdit: () {
                      _showEdit${entityNamePascal}Dialog(context, $entityNameLower);
                    },
                    onDelete: () {
                      _showDeleteConfirmation(context, $entityNameLower);
                    },
                  );
                },
              ),
            );
          }

          if (state is ${entityNamePascal}OperationSuccess) {
            // Show success message and reload ${entityNameLower}s
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              context.read<${entityNamePascal}Bloc>().add(const Load${entityNamePascal}s());
            });
            return const Center(child: CircularProgressIndicator());
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreate${entityNamePascal}Dialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _show${entityNamePascal}Details(BuildContext context, $entityNamePascal $entityNameLower) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$entityNamePascal Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: \${$entityNameLower.id}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCreate${entityNamePascal}Dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create $entityNamePascal'),
        content: const Text('Are you sure you want to create a new $entityNameLower?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<${entityNamePascal}Bloc>().add(
                const Create${entityNamePascal}Event(),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEdit${entityNamePascal}Dialog(BuildContext context, $entityNamePascal $entityNameLower) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit $entityNamePascal'),
        content: Text('Are you sure you want to edit $entityNameLower with ID: \${$entityNameLower.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<${entityNamePascal}Bloc>().add(
                Update${entityNamePascal}Event($entityNameLower.id),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, $entityNamePascal $entityNameLower) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete $entityNamePascal'),
        content: Text('Are you sure you want to delete $entityNameLower with ID: \${$entityNameLower.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<${entityNamePascal}Bloc>().add(Delete${entityNamePascal}Event($entityNameLower.id));
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}''';
  }

  static String generateWidget(String entityNamePascal, String entityNameLower) {
    return '''import 'package:flutter/material.dart';
import '../../domain/entities/$entityNameLower.dart';

class ${entityNamePascal}ListItem extends StatelessWidget {
  final $entityNamePascal $entityNameLower;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ${entityNamePascal}ListItem({
    super.key,
    required this.$entityNameLower,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'ID: \${$entityNameLower.id}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit?.call();
                      break;
                    case 'delete':
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}''';
  }
}
