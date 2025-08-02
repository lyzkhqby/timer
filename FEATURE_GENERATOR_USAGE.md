# Flutter Feature Generator 使用指南

## 快速开始

### 1. 生成新功能模块

```bash
# 生成产品管理功能
./generate_feature.sh product_management product

# 生成用户管理功能  
./generate_feature.sh user_management user

# 生成订单跟踪功能
./generate_feature.sh order_tracking order
```

### 2. 生成的文件结构

以 `product` 为例，生成的文件结构如下：

```
lib/features/product/
├── domain/
│   ├── entities/product.dart                    # 产品实体类
│   ├── repositories/product_repository.dart     # 产品仓库接口
│   └── usecases/
│       ├── get_products.dart                    # 获取产品列表用例
│       ├── get_product_by_id.dart              # 根据ID获取产品用例
│       └── create_product.dart                  # 创建产品用例
├── data/
│   ├── models/product_model.dart               # 产品数据模型
│   ├── datasources/product_remote_data_source.dart  # 远程数据源
│   └── repositories/product_repository_impl.dart    # 仓库实现
└── presentation/
    ├── bloc/
    │   ├── product_event.dart                  # BLoC事件
    │   ├── product_state.dart                  # BLoC状态
    │   └── product_bloc.dart                   # BLoC逻辑
    ├── pages/product_page.dart                 # 产品页面
    └── widgets/product_list_item.dart          # 产品列表项组件
```

### 3. 手动集成步骤

#### 3.1 更新依赖注入 (lib/injection_container.dart)

```dart
// 添加导入
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/get_products.dart';
import 'features/product/domain/usecases/get_product_by_id.dart';
import 'features/product/domain/usecases/create_product.dart';
import 'features/product/presentation/bloc/product_bloc.dart';

Future<void> init() async {
  // 现有代码...
  
  // 添加产品功能初始化
  _initProduct();
  
  // 现有代码...
}

void _initProduct() {
  // BLoC
  sl.registerFactory(
    () => ProductBloc(
      getProducts: sl(),
      getProductById: sl(),
      createProduct: sl(),
    ),
  );
  
  // Use cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductById(sl()));
  sl.registerLazySingleton(() => CreateProduct(sl()));
  
  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );
  
  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiClient: sl()),
  );
}
```

#### 3.2 更新路由 (lib/core/router/route_names.dart)

```dart
class RouteNames {
  // 现有路由...
  static const String products = '/products';
  static const String productDetail = '/products/:id';
}
```

#### 3.3 更新路由配置 (lib/core/router/app_router.dart)

```dart
import '../../features/product/presentation/pages/product_page.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: RouteNames.home,
    routes: [
      // 现有路由...
      
      GoRoute(
        path: RouteNames.products,
        name: RouteNames.products,
        builder: (context, state) => const ProductPage(),
      ),
    ],
    // 现有错误处理...
  );
}
```

#### 3.4 更新主应用 (lib/main.dart)

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 现有BLoC提供者...
        
        BlocProvider(
          create: (context) => di.sl<ProductBloc>(),
        ),
      ],
      child: MaterialApp.router(
        // 现有配置...
      ),
    );
  }
}
```

### 4. 使用生成的功能

#### 4.1 在页面中导航到新功能

```dart
// 在任何页面中添加导航
ElevatedButton(
  onPressed: () => context.push(RouteNames.products),
  child: Text('查看产品'),
),
```

#### 4.2 自定义生成的代码

生成的代码是基础模板，你可以根据需要进行自定义：

- 修改实体类属性
- 添加更多用例
- 自定义UI组件
- 添加验证逻辑

### 5. 测试

生成的代码包含完整的测试文件：

```bash
# 运行所有测试
flutter test

# 运行特定功能的测试
flutter test test/features/product/
```

### 6. 常见问题

#### Q: 生成后编译错误？
A: 确保运行 `flutter pub get` 并检查导入路径是否正确。

#### Q: 如何修改生成的模板？
A: 编辑 `tools/feature_generator_templates.dart` 文件中的模板。

#### Q: 可以生成其他类型的功能吗？
A: 可以，只需要修改模板文件来适应不同的需求。

### 7. 最佳实践

1. **命名约定**: 使用下划线分隔的小写名称 (如: `user_management`)
2. **实体设计**: 根据实际需求修改生成的实体类
3. **API集成**: 更新数据源以匹配你的API接口
4. **错误处理**: 根据需要添加更多的错误处理逻辑
5. **测试覆盖**: 为自定义的逻辑添加额外的测试

这个代码生成器可以大大加速你的Flutter开发，让你专注于业务逻辑而不是重复的架构代码！
