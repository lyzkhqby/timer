# Flutter Feature Generator

这个工具可以自动生成遵循Clean Architecture和BLoC模式的Flutter功能模块。

## 功能特性

- 🏗️ **Clean Architecture**: 自动生成Domain、Data、Presentation三层架构
- 🔄 **BLoC Pattern**: 生成完整的BLoC状态管理代码
- 🧪 **测试代码**: 自动生成单元测试和BLoC测试
- 📁 **标准结构**: 遵循项目的文件夹结构约定
- ⚡ **快速开发**: 几秒钟内生成完整功能模块

## 使用方法

### 方法1: 使用Shell脚本（推荐）

```bash
./generate_feature.sh <feature_name> <entity_name>
```

示例：
```bash
./generate_feature.sh user_management user
./generate_feature.sh product_catalog product
./generate_feature.sh order_tracking order
```

### 方法2: 直接使用Dart

```bash
dart tools/generate_feature.dart <feature_name> <entity_name>
```

## 生成的文件结构

```
lib/features/<feature_name>/
├── domain/
│   ├── entities/
│   │   └── <entity_name>.dart
│   ├── repositories/
│   │   └── <entity_name>_repository.dart
│   └── usecases/
│       ├── get_<entity_name>s.dart
│       ├── get_<entity_name>_by_id.dart
│       └── create_<entity_name>.dart
├── data/
│   ├── models/
│   │   └── <entity_name>_model.dart
│   ├── datasources/
│   │   └── <entity_name>_remote_data_source.dart
│   └── repositories/
│       └── <entity_name>_repository_impl.dart
└── presentation/
    ├── bloc/
    │   ├── <entity_name>_event.dart
    │   ├── <entity_name>_state.dart
    │   └── <entity_name>_bloc.dart
    ├── pages/
    │   └── <entity_name>_page.dart
    └── widgets/
        └── <entity_name>_list_item.dart

test/features/<feature_name>/
├── domain/usecases/
├── data/repositories/
└── presentation/bloc/
```

## 生成后的手动步骤

1. **更新依赖注入** (`lib/injection_container.dart`):
   ```dart
   // 添加导入
   import 'features/<feature_name>/presentation/bloc/<entity_name>_bloc.dart';
   // ... 其他导入
   
   // 在init()方法中添加
   _init<EntityName>();
   
   // 添加初始化方法
   void _init<EntityName>() {
     // BLoC
     sl.registerFactory(() => <EntityName>Bloc(...));
     // Use cases
     sl.registerLazySingleton(() => Get<EntityName>s(sl()));
     // Repository
     sl.registerLazySingleton<EntityNameRepository>(() => <EntityName>RepositoryImpl(...));
     // Data sources
     sl.registerLazySingleton<EntityNameRemoteDataSource>(() => <EntityName>RemoteDataSourceImpl(...));
   }
   ```

2. **更新路由** (`lib/core/router/app_router.dart`):
   ```dart
   import '../../features/<feature_name>/presentation/pages/<entity_name>_page.dart';
   
   // 在routes中添加
   GoRoute(
     path: RouteNames.<entityName>,
     name: RouteNames.<entityName>,
     builder: (context, state) => const <EntityName>Page(),
   ),
   ```

3. **添加路由名称** (`lib/core/router/route_names.dart`):
   ```dart
   static const String <entityName> = '/<entity_name>';
   ```

4. **在主应用中添加BLoC Provider** (`lib/main.dart`):
   ```dart
   BlocProvider(
     create: (context) => di.sl<<EntityName>Bloc>(),
   ),
   ```

## 示例

生成用户管理功能：

```bash
./generate_feature.sh user_management user
```

这将生成：
- User实体类
- UserRepository接口和实现
- UserBloc状态管理
- UserPage页面
- 完整的测试代码

## 自定义模板

如果需要修改生成的代码模板，请编辑 `tools/feature_generator_templates.dart` 文件。

## 注意事项

- 确保在项目根目录运行脚本
- 生成后需要运行 `flutter pub get` 如果添加了新的依赖
- 建议在生成后运行测试：`flutter test`
- 生成的代码遵循项目的现有架构模式

## 故障排除

如果遇到问题：

1. 确保Dart SDK已安装
2. 检查文件权限
3. 确保在正确的目录运行脚本
4. 查看生成的文件是否有语法错误

## 贡献

如果需要添加新的模板或改进生成器，请修改相应的模板文件并测试。
