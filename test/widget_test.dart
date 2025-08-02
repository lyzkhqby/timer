import 'package:flutter_test/flutter_test.dart';
import 'package:timer/main.dart';
import 'package:timer/injection_container.dart' as di;

void main() {
  setUpAll(() async {
    await di.init();
  });

  testWidgets('App should start and show home page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that we're on the home page
    expect(find.text('Welcome to Flutter Scaffold'), findsOneWidget);
    expect(find.text('Features'), findsOneWidget);
    expect(find.text('BLoC Pattern'), findsOneWidget);
  });

  testWidgets('Should navigate to counter page when BLoC feature is tapped', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Find and tap the BLoC Pattern feature card
    await tester.tap(find.text('BLoC Pattern'));
    await tester.pumpAndSettle();

    // Verify that we're now on the counter page
    expect(find.text('Counter'), findsOneWidget);
    expect(find.text('Current Count'), findsOneWidget);
  });
}
