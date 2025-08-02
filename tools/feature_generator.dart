import 'dart:io';
import 'feature_generator_templates.dart';

class FeatureGenerator {
  final String featureName;
  final String entityName;
  final String basePath;
  
  FeatureGenerator({
    required this.featureName,
    required this.entityName,
    this.basePath = 'lib/features',
  });
  
  String get _featureNameLower => featureName.toLowerCase();
  String get _featureNameCamel => _toCamelCase(featureName);
  String get _featureNamePascal => _toPascalCase(featureName);
  String get _entityNameLower => entityName.toLowerCase();
  String get _entityNameCamel => _toCamelCase(entityName);
  String get _entityNamePascal => _toPascalCase(entityName);
  
  Future<void> generate() async {
    print('Generating feature: $featureName with entity: $entityName');
    
    await _createDirectoryStructure();
    await _generateDomainLayer();
    await _generateDataLayer();
    await _generatePresentationLayer();
    await _generateTests();
    await _updateDependencyInjection();
    await _updateRouter();
    
    print('Feature generation completed!');
    
  }
  
  Future<void> _createDirectoryStructure() async {
    final directories = [
      '$basePath/$_featureNameLower/domain/entities',
      '$basePath/$_featureNameLower/domain/repositories',
      '$basePath/$_featureNameLower/domain/usecases',
      '$basePath/$_featureNameLower/data/models',
      '$basePath/$_featureNameLower/data/datasources',
      '$basePath/$_featureNameLower/data/repositories',
      '$basePath/$_featureNameLower/presentation/bloc',
      '$basePath/$_featureNameLower/presentation/pages',
      '$basePath/$_featureNameLower/presentation/widgets',
      'test/features/$_featureNameLower/domain/usecases',
      'test/features/$_featureNameLower/data/repositories',
      'test/features/$_featureNameLower/presentation/bloc',
    ];
    
    for (final dir in directories) {
      await Directory(dir).create(recursive: true);
      print('Created directory: $dir');
    }
  }
  
  Future<void> _generateDomainLayer() async {
    await _generateEntity();
    await _generateRepository();
    await _generateUseCases();
  }
  
  Future<void> _generateDataLayer() async {
    await _generateModel();
    await _generateDataSource();
    await _generateRepositoryImpl();
  }
  
  Future<void> _generatePresentationLayer() async {
    await _generateBlocEvent();
    await _generateBlocState();
    await _generateBloc();
    await _generatePage();
    await _generateWidgets();
  }
  
  Future<void> _generateTests() async {
    await _generateUseCaseTests();
    await _generateRepositoryTests();
    await _generateBlocTests();
  }
  
  /// 将下划线分隔的字符串转换为驼峰命名法
  /// 例如: "user_name" -> "userName"
  String _toCamelCase(String input) {
    if (input.isEmpty) return input;
    final words = input.split('_');
    return words.first.toLowerCase() + 
           // 跳过第一个单词，从第二个单词开始处理
           words.skip(1).map((word) => _capitalize(word)).join('');
  }
  
  /// 将下划线分隔的字符串转换为帕斯卡命名法
  /// 例如: "user_name" -> "UserName"
  String _toPascalCase(String input) {
    if (input.isEmpty) return input;
    return input.split('_').map((word) => _capitalize(word)).join('');
  }
  
  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  Future<void> _generateEntity() async {
    final content = FeatureTemplates.generateEntity(_entityNamePascal, _entityNameLower);
    await _writeFile('$basePath/$_featureNameLower/domain/entities/$_entityNameLower.dart', content);
  }

  Future<void> _generateRepository() async {
    final content = FeatureTemplates.generateRepository(_entityNamePascal, _entityNameLower);

    await _writeFile('$basePath/$_featureNameLower/domain/repositories/${_entityNameLower}_repository.dart', content);
  }

  Future<void> _generateUseCases() async {
    // Get entities use case
    final getEntitiesContent = FeatureTemplates.generateGetEntitiesUseCase(_entityNamePascal, _entityNameLower);
    await _writeFile('$basePath/$_featureNameLower/domain/usecases/get_${_entityNameLower}s.dart', getEntitiesContent);
  }

  Future<void> _generateModel() async {
    final content = FeatureTemplates.generateModel(_entityNamePascal, _entityNameLower);
    await _writeFile('$basePath/$_featureNameLower/data/models/${_entityNameLower}_model.dart', content);
  }

  Future<void> _generateDataSource() async {
    final content = FeatureTemplates.generateDataSource(_entityNamePascal, _entityNameLower);
    await _writeFile('$basePath/$_featureNameLower/data/datasources/${_entityNameLower}_remote_data_source.dart', content);
  }

  Future<void> _generateRepositoryImpl() async {
    final content = FeatureTemplates.generateRepositoryImpl(_entityNamePascal, _entityNameLower);
    await _writeFile('$basePath/$_featureNameLower/data/repositories/${_entityNameLower}_repository_impl.dart', content);
  }

  Future<void> _generateBlocEvent() async {
    final content = FeatureTemplates.generateBlocEvent(_entityNamePascal, _entityNameLower);
    await _writeFile('$basePath/$_featureNameLower/presentation/bloc/${_entityNameLower}_event.dart', content);
  }

  Future<void> _generateBlocState() async {
    final content = FeatureTemplates.generateBlocState(_entityNamePascal, _entityNameLower);
    await _writeFile('$basePath/$_featureNameLower/presentation/bloc/${_entityNameLower}_state.dart', content);
  }

  Future<void> _generateBloc() async {
    final content = FeatureTemplates.generateBloc(_entityNamePascal, _entityNameLower);
    await _writeFile('$basePath/$_featureNameLower/presentation/bloc/${_entityNameLower}_bloc.dart', content);
  }

  Future<void> _generatePage() async {
    final content = FeatureTemplates.generatePage(_entityNamePascal, _entityNameLower);
    await _writeFile('$basePath/$_featureNameLower/presentation/pages/${_entityNameLower}_page.dart', content);
  }

  Future<void> _generateWidgets() async {
    final content = FeatureTemplates.generateWidget(_entityNamePascal, _entityNameLower);
    await _writeFile('$basePath/$_featureNameLower/presentation/widgets/${_entityNameLower}_list_item.dart', content);
  }

  Future<void> _generateUseCaseTests() async {
    // This will be implemented in the next chunk
  }

  Future<void> _generateRepositoryTests() async {
    // This will be implemented in the next chunk
  }

  Future<void> _generateBlocTests() async {
    // This will be implemented in the next chunk
  }

  Future<void> _updateDependencyInjection() async {
    final diFile = File('lib/injection_container.dart');
    if (!await diFile.exists()) {
      // ignore: avoid_print
      print('Warning: injection_container.dart not found, skipping DI update');
      return;
    }

    String content = await diFile.readAsString();

    // Check if this feature is already added
    if (content.contains('import \'features/$_featureNameLower/')) {
      // ignore: avoid_print
      print('Feature $_featureNameLower already exists in injection_container.dart, skipping');
      return;
    }

    // Add imports
    final imports = '''// Features - $_entityNamePascal
import 'features/$_featureNameLower/data/datasources/${_entityNameLower}_remote_data_source.dart';
import 'features/$_featureNameLower/data/repositories/${_entityNameLower}_repository_impl.dart';
import 'features/$_featureNameLower/domain/repositories/${_entityNameLower}_repository.dart';
import 'features/$_featureNameLower/domain/usecases/get_${_entityNameLower}s.dart';
import 'features/$_featureNameLower/presentation/bloc/${_entityNameLower}_bloc.dart';

''';

    // Find the best place to add imports (after the last feature import or after core imports)
    if (content.contains('// Features - ')) {
      // Find the last feature import block
      final lines = content.split('\n');
      int lastFeatureImportIndex = -1;

      for (int i = 0; i < lines.length; i++) {
        if (lines[i].contains('import \'features/') && lines[i].contains('/presentation/bloc/')) {
          lastFeatureImportIndex = i;
        }
      }

      if (lastFeatureImportIndex != -1) {
        lines.insert(lastFeatureImportIndex + 1, imports.trim());
        content = lines.join('\n');
      }
    } else {
      // Add after core imports
      content = content.replaceFirst(
        'import \'core/network/api_client.dart\';',
        'import \'core/network/api_client.dart\';\n\n$imports',
      );
    }

    // Add init call in the init() method
    final initCall = '  _init$_entityNamePascal();';

    // Find the best place to add the init call
    if (content.contains('_initCounter();')) {
      content = content.replaceFirst(
        '  _initCounter();',
        '  _initCounter();\n$initCall',
      );
    } else if (content.contains('// Core')) {
      content = content.replaceFirst(
        '  // Core',
        '  // Features - $_entityNamePascal\n$initCall\n\n  // Core',
      );
    } else {
      content = content.replaceFirst(
        '  _initCore();',
        '$initCall\n  _initCore();',
      );
    }

    // Add init method before _initCore()
    final initMethod = '''
void _init$_entityNamePascal() {
  // BLoC
  sl.registerFactory(
    () => ${_entityNamePascal}Bloc(
      get${_entityNamePascal}s: sl(),
      get${_entityNamePascal}ById: sl(),
      create$_entityNamePascal: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => Get${_entityNamePascal}s(sl()));
  sl.registerLazySingleton(() => Get${_entityNamePascal}ById(sl()));
  sl.registerLazySingleton(() => Create$_entityNamePascal(sl()));

  // Repository
  sl.registerLazySingleton<${_entityNamePascal}Repository>(
    () => ${_entityNamePascal}RepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<${_entityNamePascal}RemoteDataSource>(
    () => ${_entityNamePascal}RemoteDataSourceImpl(apiClient: sl()),
  );
}

''';

    // Add method before _initCore()
    content = content.replaceFirst(
      'void _initCore() {',
      '${initMethod}void _initCore() {',
    );

    await diFile.writeAsString(content);
    // ignore: avoid_print
    print('Updated: lib/injection_container.dart');
  }

  Future<void> _updateRouter() async {
    // Update route_names.dart
    await _updateRouteNames();

    // Update app_router.dart
    await _updateAppRouter();

    // Update main.dart
    await _updateMainApp();

    // Update home page with navigation
    await _updateHomePage();
  }

  Future<void> _updateRouteNames() async {
    final routeNamesFile = File('lib/core/router/route_names.dart');
    if (!await routeNamesFile.exists()) {
      // ignore: avoid_print
      print('Warning: route_names.dart not found, skipping route names update');
      return;
    }

    String content = await routeNamesFile.readAsString();

    // Check if route already exists
    if (content.contains('${_entityNameLower}s = ')) {
      // ignore: avoid_print
      print('Route ${_entityNameLower}s already exists in route_names.dart, skipping');
      return;
    }

    // Add new route constant
    final newRoute = "  static const String ${_entityNameLower}s = '/${_entityNameLower}s';";

    // Find the best place to insert (before profile, settings, login, register or at the end)
    final lines = content.split('\n');
    int insertIndex = -1;

    // Look for a good insertion point
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains('static const String profile') ||
          lines[i].contains('static const String settings') ||
          lines[i].contains('static const String login')) {
        insertIndex = i;
        break;
      }
    }

    if (insertIndex != -1) {
      lines.insert(insertIndex, newRoute);
    } else {
      // Insert before the closing brace
      for (int i = lines.length - 1; i >= 0; i--) {
        if (lines[i].trim() == '}') {
          lines.insert(i, newRoute);
          break;
        }
      }
    }

    content = lines.join('\n');

    await routeNamesFile.writeAsString(content);
    // ignore: avoid_print
    print('Updated: lib/core/router/route_names.dart');
  }

  Future<void> _updateAppRouter() async {
    final appRouterFile = File('lib/core/router/app_router.dart');
    if (!await appRouterFile.exists()) {
      // ignore: avoid_print
      print('Warning: app_router.dart not found, skipping router update');
      return;
    }

    String content = await appRouterFile.readAsString();

    // Add import
    final import = "import '../../features/$_featureNameLower/presentation/pages/${_entityNameLower}_page.dart';\n";
    content = content.replaceFirst(
      "import 'route_names.dart';",
      "import 'route_names.dart';\n$import",
    );

    // Add route
    final newRoute = '''      GoRoute(
        path: RouteNames.${_entityNameLower}s,
        name: RouteNames.${_entityNameLower}s,
        builder: (context, state) => const ${_entityNamePascal}Page(),
      ),
''';

    // Insert after existing routes
    content = content.replaceFirst(
      '      ),\n    ],',
      '      ),\n$newRoute    ],',
    );

    await appRouterFile.writeAsString(content);
    // ignore: avoid_print
    print('Updated: lib/core/router/app_router.dart');
  }

  Future<void> _updateMainApp() async {
    final mainFile = File('lib/main.dart');
    if (!await mainFile.exists()) {
      // ignore: avoid_print
      print('Warning: main.dart not found, skipping main app update');
      return;
    }

    String content = await mainFile.readAsString();

    // Add import
    final import = "import 'features/$_featureNameLower/presentation/bloc/${_entityNameLower}_bloc.dart';\n";
    content = content.replaceFirst(
      "import 'injection_container.dart' as di;",
      "import 'injection_container.dart' as di;\n$import",
    );

    // Add BLoC provider
    final newProvider = '''        BlocProvider(
          create: (context) => di.sl<${_entityNamePascal}Bloc>(),
        ),
''';

    // Insert after existing providers
    content = content.replaceFirst(
      '        ),\n      ],',
      '        ),\n$newProvider      ],',
    );

    await mainFile.writeAsString(content);
    // ignore: avoid_print
    print('Updated: lib/main.dart');
  }

  Future<void> _updateHomePage() async {
    final homePageFile = File('lib/features/home/presentation/pages/home_page.dart');
    if (!await homePageFile.exists()) {
      // ignore: avoid_print
      print('Warning: home_page.dart not found, skipping home page update');
      return;
    }

    String content = await homePageFile.readAsString();

    // Add new feature card
    final newFeatureCard = '''            const SizedBox(height: 12),
            _FeatureCard(
              icon: Icons.${_getIconForEntity()},
              title: '$_entityNamePascal Management',
              description: 'Manage ${_entityNameLower}s with BLoC pattern',
              onTap: () => context.push(RouteNames.${_entityNameLower}s),
            ),''';

    // Insert before the last feature card's closing
    if (content.contains('_FeatureCard(')) {
      // Find the last _FeatureCard and add after it
      final lastFeatureCardIndex = content.lastIndexOf('            ),');
      if (lastFeatureCardIndex != -1) {
        content = content.substring(0, lastFeatureCardIndex + 14) +
                 newFeatureCard +
                 content.substring(lastFeatureCardIndex + 14);
      }
    }

    await homePageFile.writeAsString(content);
    // ignore: avoid_print
    print('Updated: lib/features/home/presentation/pages/home_page.dart');
  }


  String _getIconForEntity() {
    // Return appropriate icon based on entity name
    switch (_entityNameLower) {
      case 'user':
        return 'person';
      case 'product':
        return 'inventory';
      case 'order':
        return 'shopping_cart';
      case 'category':
        return 'category';
      case 'task':
        return 'task';
      case 'project':
        return 'work';
      case 'message':
        return 'message';
      case 'notification':
        return 'notifications';
      case 'setting':
        return 'settings';
      case 'report':
        return 'analytics';
      default:
        return 'folder';
    }
  }

  Future<void> _writeFile(String path, String content) async {
    final file = File(path);
    await file.writeAsString(content);
    // ignore: avoid_print
    print('Generated: $path');
  }
}
