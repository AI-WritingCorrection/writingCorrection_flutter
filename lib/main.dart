import 'package:aiwriting_collection/api.dart';
import 'package:aiwriting_collection/screen/home/home_screen.dart';
import 'package:aiwriting_collection/screen/login/sign/login_screen.dart';
import 'package:aiwriting_collection/screen/login/sign/sign_screen.dart';
import 'package:aiwriting_collection/screen/record_screen.dart';
import 'package:aiwriting_collection/screen/free_study/study_screen.dart';
import 'package:aiwriting_collection/screen/mypage_screen.dart';
import 'package:aiwriting_collection/widget/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'model/login_status.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load environment variables
  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '',
    javaScriptAppKey: dotenv.env['KAKAO_JAVASCRIPT_APP_KEY'] ?? '',
  ); // 카카오 SDK 초기화
  await Firebase.initializeApp();
  final api = Api();
  // Check existing FirebaseAuth session
  final firebaseUser = FirebaseAuth.instance.currentUser;
  bool initialLoggedIn = false;
  int initialId = 0;
  String? initialUid;
  String? initialJwt;

  if (firebaseUser != null) {
    try {
      final idToken = await firebaseUser.getIdToken();
      final res = await api.login(idToken!);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        initialLoggedIn = true;
        initialId = body['user_id'];
        initialUid = firebaseUser.uid;
        initialJwt = body['jwt'];
      }
    } catch (e) {
      // network or parsing error
      initialLoggedIn = false;
      debugPrint('Auto-login error: $e');
    }
  }

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
        ChangeNotifierProvider(
          create: (_) {
            final loginStatus = LoginStatus();
            if (initialLoggedIn && initialUid != null && initialJwt != null) {
              loginStatus.setUser(
                userId: initialId,
                uid: initialUid,
                jwt: initialJwt,
              );
            }
            return loginStatus;
          },
        ),
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
      //initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home':
            (context) => DefaultTabController(
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
            ),
        '/study': (context) => StudyScreen(),
        '/record': (context) => RecordScreen(),
        '/mypage': (context) => MypageScreen(),
        '/sign': (context) => SignScreen(),
      },
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
