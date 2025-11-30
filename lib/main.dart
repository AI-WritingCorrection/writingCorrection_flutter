import 'package:aiwriting_collection/api.dart';
import 'package:aiwriting_collection/model/provider/data_provider.dart';
import 'package:aiwriting_collection/model/provider/language_provider.dart';
import 'package:aiwriting_collection/model/common/type_enum.dart';
import 'package:aiwriting_collection/screen/home/home_screen.dart';
import 'package:aiwriting_collection/screen/auth/login_screen.dart';
import 'package:aiwriting_collection/screen/auth/sign_screen.dart';
import 'package:aiwriting_collection/screen/record_screen.dart';
import 'package:aiwriting_collection/screen/free_study/study_screen.dart';
import 'package:aiwriting_collection/screen/mypage_screen.dart';
import 'package:aiwriting_collection/widget/common/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'model/provider/login_status.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // kDebugMode
import 'package:aiwriting_collection/generated/app_localizations.dart';

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
  UserType? initialUserType;

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
        if (body.containsKey('user_type')) {
          initialUserType = UserType.values.byName(body['user_type'] as String);
        }
      }
    } catch (e) {
      // network or parsing error
      initialLoggedIn = false;
      debugPrint('Auto-login error: $e');
    }
  }

  Locale? initialLocale;
  if (initialUserType != null) {
    if (initialUserType == UserType.FOREIGN) {
      initialLocale = const Locale('en');
    } else {
      initialLocale = const Locale('ko');
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
                userType: initialUserType,
              );
            }
            return loginStatus;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(initialLocale: initialLocale),
        ),
        ChangeNotifierProxyProvider<LoginStatus, DataProvider>(
          create: (_) => DataProvider()..loadInitialData(),
          update: (_, loginStatus, dataProvider) {
            if (loginStatus.isLoggedIn && loginStatus.userId != null) {
              dataProvider!.loadMissionRecords(loginStatus.userId!);
            } else {
              // User is logged out, clear their specific data
              dataProvider!.clearUserRecords();
            }
            return dataProvider;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          locale: languageProvider.appLocale,
          title: 'MyPen',
          theme: ThemeData(
            fontFamily: 'Cafe24Ssurround',
            brightness: Brightness.light,
            primaryColor: Color(0xFFCEEF91),
            canvasColor: Color(0xFFFFFBF3),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFCEEF91),
              secondary: Color(0xFFFFE5F2),
              tertiary: Color(0xFFFFCEEF),
            ),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
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
            if (kDebugMode)
              '/sign_preview':
                  (context) => const SignScreen(
                    debugEmail: 'preview_user@example.com',
                    debugProvider: 'google',
                    useMockApi: true, // 서버호출 생략
                  ),
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
          builder: (context, child) {
            return Consumer<LoginStatus>(
              builder: (context, loginStatus, _) {
                return Stack(
                  children: [
                    child!,
                    if (loginStatus.isLoggingOut)
                      const Scaffold(
                        backgroundColor: Colors.black45,
                        body: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
