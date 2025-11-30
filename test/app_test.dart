import 'package:aiwriting_collection/main.dart';
import 'package:aiwriting_collection/model/provider/data_provider.dart';
import 'package:aiwriting_collection/model/provider/language_provider.dart';
import 'package:aiwriting_collection/model/provider/login_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App starts with LoginScreen when not logged in',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LoginStatus()),
          ChangeNotifierProvider(create: (context) => LanguageProvider()),
          ChangeNotifierProxyProvider<LoginStatus, DataProvider>(
            create: (_) => DataProvider(),
            update: (_, loginStatus, dataProvider) {
              return dataProvider!;
            },
          ),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that LoginScreen is shown by checking for a unique text.
    expect(find.text('손글손글'), findsOneWidget);
  });
}
