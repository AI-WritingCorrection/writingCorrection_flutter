import 'package:aiwriting_collection/screen/home_screen.dart';
import 'package:aiwriting_collection/screen/login_screen.dart';
import 'package:aiwriting_collection/screen/study_screen.dart';
import 'package:aiwriting_collection/widget/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/login_status.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LoginStatus(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
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
                      Center(child: Text('calendar')),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // 로그아웃 버튼 클릭 시 로그인 상태를 false로 변경
                            Provider.of<LoginStatus>(
                              context,
                              listen: false,
                            ).setLoggedIn(false);
                          },
                          child: Text(
                            "로그아웃",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
