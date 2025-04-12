import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/login_status.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//scale*4 = 1% of screenWidth
//scale*9.3 = 1% of screenHeight
class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double baseWidth = 390.0;
    final double scale = screenSize.width / baseWidth;

    // 디자인 기준: 수치들은 baseWidth 기준의 값들을 scale로 곱하여 계산
    final double horizontalPadding = 16 * scale; // 원래 16pt
    final double verticalSpacingLarge = 24 * scale; // 예: 24pt

    return Scaffold(
      backgroundColor: const Color(0xFFCEEF91),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 화면 상단의 이미지 (기존과 동일하게 screenHeight의 비율로 처리)
              Center(
                child: Image.asset(
                  'assets/bearTeacher.png',
                  height: 300 * scale,
                  fit: BoxFit.contain,
                ),
              ),
              // 자체 로그인 블록: ConstrainedBox를 사용하여 높이를 base값에 scale을 곱한 수치로 적용
              ConstrainedBox(
                constraints: BoxConstraints(
                  // 예: 디자인 기준으로 최소 90pt, 최대 120pt (여기서 pt는 baseWidth 기준)
                  minHeight: 90 * scale,
                  maxHeight: 230 * scale, 
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: horizontalPadding,
                    bottom: horizontalPadding * 0.3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8.0 * scale),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4 * scale),
                        blurRadius: 8 * scale,
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double parentH = constraints.maxHeight;
                      double spacing = parentH * 0.1;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: spacing * 0.3),
                          // 아이디 TextField를 Container로 감싸서 높이 제한
                          Container(
                            height: parentH * 0.3,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: '아이디',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                floatingLabelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 3.0 * scale,
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 3.0 * scale,
                                    color: Colors.black,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 3.0 * scale,
                                    color: Colors.blue,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: parentH * 0.12 * 0.4,
                                  horizontal: horizontalPadding,
                                ),
                              ),
                              style: TextStyle(fontSize: parentH * 0.12 * 0.9),
                            ),
                          ),
                          SizedBox(height: spacing * 0.3),
                          // 비밀번호 TextField
                          Container(
                            height: parentH * 0.3,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: '비밀번호',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                floatingLabelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 3.0 * scale,
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 3.0 * scale,
                                    color: Colors.black,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 3.0 * scale,
                                    color: Colors.blue,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: parentH * 0.12 * 0.4,
                                  horizontal: horizontalPadding,
                                ),
                              ),
                              obscureText: true,
                              style: TextStyle(fontSize: parentH * 0.12 * 0.9),
                            ),
                          ),
                          SizedBox(height: spacing * 0.3),
                          ElevatedButton(
                            onPressed: () {
                              // 로그인 처리 (예: 상태 변경)
                              // context.read<LoginStatus>().setLoggedIn(true);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                double.infinity,
                                parentH * 0.25,
                              ),
                            ),
                            child: Text(
                              '로그인',
                              style: TextStyle(
                                fontSize: parentH * 0.10,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: verticalSpacingLarge),
              // 간편 로그인 블록: 아이콘 버튼들을 Row로 배치 (각 컨테이너 크기도 scale을 이용)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: scale * 64, // 16% of screen width
                    height: scale * 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBF3),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.5 * scale,
                      ),
                      borderRadius: BorderRadius.circular(8.0 * scale),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.apple),
                      tooltip: 'Apple 로그인',
                      iconSize: scale * 40,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: scale * 64,
                    height: scale * 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBF3),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.5 * scale,
                      ),
                      borderRadius: BorderRadius.circular(8.0 * scale),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.g_mobiledata),
                      tooltip: 'Google 로그인',
                      iconSize: scale * 40,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: scale * 64,
                    height: scale * 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBF3),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.5 * scale,
                      ),
                      borderRadius: BorderRadius.circular(8.0 * scale),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.chat),
                      tooltip: 'Kakao 로그인',
                      iconSize: scale * 40,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: scale * 64, // 16% of screen width
                    height: scale * 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBF3),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.5 * scale,
                      ),
                      borderRadius: BorderRadius.circular(8.0 * scale),
                    ),
                    child: TextButton(
                      onPressed: () {
                        context.read<LoginStatus>().setLoggedIn(true);
                      },
                      child: Text(
                        '게스트',
                        style: TextStyle(
                          fontSize: scale * 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: verticalSpacingLarge * 0.3),
              Flexible(
                fit: FlexFit.loose,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          fontSize: scale * 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        '아이디/비밀번호 찾기',
                        style: TextStyle(
                          fontSize: scale * 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
