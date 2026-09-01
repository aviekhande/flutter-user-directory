import 'package:flutter_test/flutter_test.dart';
import 'package:user_directory_app/main.dart';

void main() {
  testWidgets('Initial screen shows User List title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app shows the initial screen title 'Users'.
    expect(find.text('Users'), findsOneWidget);
  });
}
