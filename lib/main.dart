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
import 'package:responsive_framework/responsive_framework.dart';

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
    ChangeNotifierProvider(create: (_) => LoginStatus(), child: const MyApp()),
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
        brightness: Brightness.light,
        primaryColor: const Color(0xFFFFFBF3),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFFFBF3),
          secondary: Color(0xFFCEEF91),
        ),
      ),
      builder:
          (context, widget) => ResponsiveBreakpoints.builder(
            child: widget!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 1200, name: TABLET),
              const Breakpoint(
                start: 1201,
                end: double.infinity,
                name: DESKTOP,
              ),
            ],
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
