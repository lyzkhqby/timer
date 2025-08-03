import 'package:flutter_test/flutter_test.dart';
import 'package:timer/injection_container.dart' as di;
import 'package:timer/main.dart';

void main() {
  setUpAll(() async {
    await di.init();
  });

  testWidgets('App should start and show home page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that we're on the home page
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Home Page'), findsOneWidget);
  });
}
