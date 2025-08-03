import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

// Core
import 'core/network/api_client.dart';




final sl = GetIt.instance;

Future<void> init() async {
  // Core
  _initCore();

  // External
  await _initExternal();
}


void _initCore() {
  sl.registerLazySingleton(() => ApiClient());
}

Future<void> _initExternal() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
