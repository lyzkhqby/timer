import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

// Core
import 'core/network/api_client.dart';

// Features - Counter
import 'features/counter/data/datasources/counter_local_data_source.dart';
import 'features/counter/data/repositories/counter_repository_impl.dart';
import 'features/counter/domain/repositories/counter_repository.dart';
import 'features/counter/domain/usecases/get_counter.dart';
import 'features/counter/domain/usecases/increment_counter.dart';
import 'features/counter/domain/usecases/decrement_counter.dart';
import 'features/counter/presentation/bloc/counter_bloc.dart';
// Features - Product
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/get_products.dart';
import 'features/product/domain/usecases/get_product_by_id.dart';
import 'features/product/domain/usecases/create_product.dart';
import 'features/product/presentation/bloc/product_bloc.dart';
// Features - User
import 'features/user/data/datasources/user_remote_data_source.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import 'features/user/domain/repositories/user_repository.dart';
import 'features/user/domain/usecases/get_users.dart';
import 'features/user/domain/usecases/get_user_by_id.dart';
import 'features/user/domain/usecases/create_user.dart';
import 'features/user/presentation/bloc/user_bloc.dart';




final sl = GetIt.instance;

Future<void> init() async {
  // Features - Counter
  _initCounter();
  _initUser();
  _initProduct();

  
  // Core
  _initCore();
  
  // External
  await _initExternal();
}

void _initCounter() {
  // BLoC
  sl.registerFactory(
    () => CounterBloc(
      getCounter: sl(),
      incrementCounter: sl(),
      decrementCounter: sl(),
    ),
  );
  
  // Use cases
  sl.registerLazySingleton(() => GetCounter(sl()));
  sl.registerLazySingleton(() => IncrementCounter(sl()));
  sl.registerLazySingleton(() => DecrementCounter(sl()));
  
  // Repository
  sl.registerLazySingleton<CounterRepository>(
    () => CounterRepositoryImpl(localDataSource: sl()),
  );
  
  // Data sources
  sl.registerLazySingleton<CounterLocalDataSource>(
    () => CounterLocalDataSourceImpl(sharedPreferences: sl()),
  );
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

void _initUser() {
  // BLoC
  sl.registerFactory(
    () => UserBloc(
      getUsers: sl(),
      getUserById: sl(),
      createUser: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => GetUserById(sl()));
  sl.registerLazySingleton(() => CreateUser(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(apiClient: sl()),
  );
}

void _initCore() {
  sl.registerLazySingleton(() => ApiClient());
}

Future<void> _initExternal() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
