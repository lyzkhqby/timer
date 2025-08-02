import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/counter_model.dart';

abstract class CounterLocalDataSource {
  Future<CounterModel> getCounter();
  Future<void> cacheCounter(CounterModel counter);
}

class CounterLocalDataSourceImpl implements CounterLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedCounterKey = 'CACHED_COUNTER';
  
  CounterLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<CounterModel> getCounter() async {
    final jsonString = sharedPreferences.getString(cachedCounterKey);
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return CounterModel.fromJson(jsonMap);
    } else {
      // Return default counter if none cached
      return CounterModel(
        value: 0,
        lastUpdated: DateTime.now(),
      );
    }
  }
  
  @override
  Future<void> cacheCounter(CounterModel counter) async {
    final jsonString = json.encode(counter.toJson());
    final success = await sharedPreferences.setString(cachedCounterKey, jsonString);
    if (!success) {
      throw const CacheException('Failed to cache counter');
    }
  }
}
