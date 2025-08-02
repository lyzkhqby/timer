import '../../domain/entities/counter.dart';

class CounterModel extends Counter {
  const CounterModel({
    required super.value,
    required super.lastUpdated,
  });
  
  factory CounterModel.fromJson(Map<String, dynamic> json) {
    return CounterModel(
      value: json['value'] as int,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
  
  factory CounterModel.fromEntity(Counter counter) {
    return CounterModel(
      value: counter.value,
      lastUpdated: counter.lastUpdated,
    );
  }
}
