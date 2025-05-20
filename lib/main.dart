import 'package:aiwriting_collection/repository/practice_repository.dart';
import 'package:aiwriting_collection/repository/practice_repository_impl.dart';
import 'package:aiwriting_collection/screen/home_screen.dart';
import 'package:aiwriting_collection/screen/login_screen.dart';
import 'package:aiwriting_collection/screen/record_screen.dart';
import 'package:aiwriting_collection/screen/study_screen.dart';
import 'package:aiwriting_collection/screen/mypage_screen.dart';
import 'package:aiwriting_collection/widget/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'model/login_status.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Determine logical screen size in dp
  final physicalSize =
      WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
  final devicePixelRatio =
      WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
  final logicalSize = physicalSize / devicePixelRatio;
  final bool isTablet = logicalSize.shortestSide >= 600;
  //태블릿이면 가로모드로 고정
  if (isTablet) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginStatus()),
        Provider<PracticeRepository>(create: (_) => DummyPracticeRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPen',
      theme: ThemeData(
        fontFamily: 'Bazzi',
        brightness: Brightness.light,
        primaryColor: Color(0xFFCEEF91),
        canvasColor: Color(0xFFFFFBF3),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFCEEF91),
          secondary: Color(0xFFFFE5F2),
          tertiary: Color(0xFFFFCEEF),
        ),
      ),

      home: Consumer<LoginStatus>(
        builder: (context, loginStatus, child) {
          return loginStatus.isLoggedIn
              ? DefaultTabController(
                length: 4,
                child: Scaffold(
                  body: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      HomeScreen(),
                      StudyScreen(),
                      RecordScreen(),
                      MypageScreen(),
                    ],
                  ),
                  bottomNavigationBar: Bottom(),
                ),
              )
              : LoginScreen();
        },
      ),
    );
  }
}
