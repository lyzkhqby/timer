# 产品功能集成示例

现在BLoC已经正确生成，以下是如何将产品功能集成到主应用的步骤：

## 1. 更新依赖注入 (lib/injection_container.dart)

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
  // Features - Counter
  _initCounter();
  
  // Features - Product (新添加)
  _initProduct();
  
  // Core
  _initCore();
  
  // External
  await _initExternal();
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

## 2. 更新路由名称 (lib/core/router/route_names.dart)

```dart
class RouteNames {
  static const String home = '/';
  static const String counter = '/counter';
  static const String products = '/products';  // 新添加
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String login = '/login';
  static const String register = '/register';
}
```

## 3. 更新路由配置 (lib/core/router/app_router.dart)

```dart
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/counter/presentation/pages/counter_page.dart';
import '../../features/product/presentation/pages/product_page.dart';  // 新添加
import 'route_names.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: RouteNames.home,
    routes: [
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.counter,
        name: RouteNames.counter,
        builder: (context, state) => const CounterPage(),
      ),
      GoRoute(  // 新添加
        path: RouteNames.products,
        name: RouteNames.products,
        builder: (context, state) => const ProductPage(),
      ),
    ],
    // ... 错误处理保持不变
  );
}
```

## 4. 更新主应用 (lib/main.dart)

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<CounterBloc>(),
        ),
        BlocProvider(  // 新添加
          create: (context) => di.sl<ProductBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Scaffold App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
```

## 5. 更新主页导航 (lib/features/home/presentation/pages/home_page.dart)

在现有的功能卡片后添加：

```dart
const SizedBox(height: 12),
_FeatureCard(
  icon: Icons.inventory,
  title: 'Product Management',
  description: 'Manage products with BLoC pattern',
  onTap: () => context.push(RouteNames.products),
),
```

## 6. 测试集成

运行应用并测试：

```bash
flutter run
```

你应该能够：
1. 从主页导航到产品页面
2. 看到产品列表（目前为空）
3. 点击添加按钮创建新产品
4. 使用下拉菜单编辑/删除产品

## 7. API集成（可选）

如果你有真实的API，可以更新 `ProductRemoteDataSourceImpl` 中的端点：

```dart
// 在 product_remote_data_source.dart 中
@override
Future<List<ProductModel>> getProducts() async {
  try {
    final response = await apiClient.get('/api/products');  // 更新为真实端点
    final List<dynamic> data = response.data;
    return data.map((json) => ProductModel.fromJson(json)).toList();
  } catch (e) {
    throw ServerException(e.toString());
  }
}
```

## 8. 运行测试

```bash
flutter test
```

现在你的应用已经成功集成了产品管理功能！🎉

## 下一步

1. 添加更多字段到Product实体（价格、描述等）
2. 实现更新和删除的完整用例
3. 添加搜索和过滤功能
4. 实现分页
5. 添加图片上传功能
