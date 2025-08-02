import 'dart:io';
import 'feature_generator.dart';

void main(List<String> args) async {
  if (args.length < 2) {
    print('Usage: dart tools/generate_feature.dart <feature_name> <entity_name>');
    print('Example: dart tools/generate_feature.dart user_management user');
    exit(1);
  }
  
  final featureName = args[0];
  final entityName = args[1];
  
  try {
    final generator = FeatureGenerator(
      featureName: featureName,
      entityName: entityName,
    );
    
    await generator.generate();
    
  } catch (e) {
    print('❌ Error generating feature: $e');
    exit(1);
  }
}
