import 'package:aiwriting_collection/main.dart';
import 'package:aiwriting_collection/model/login_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App starts with LoginScreen when not logged in', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => LoginStatus(),
        child: const MyApp(),
      ),
    );

    // Verify that LoginScreen is shown by checking for a unique text.
    expect(find.text('AI 손글씨 교정을 시작해요'), findsOneWidget);
  });
}
