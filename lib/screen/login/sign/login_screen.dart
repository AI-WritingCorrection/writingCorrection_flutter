import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/login_status.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//scale*4 = 1% of screenWidth
//scale*9.3 = 1% of screenHeight
class _LoginScreenState extends State<LoginScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final login = context.read<LoginStatus>();
    // print("✅ [LoginScreen 진입]");
    // print("JWT: ${login.jwt}");
    // print("UID: ${login.uid}");
    // print("isLoggedIn: ${login.isLoggedIn}");
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return _buildPortrait(context);
    } else {
      return _buildLandscape(context);
    }
  }

  Widget _buildPortrait(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double basePortrait = 390.0;
    final double scale = screenSize.width / basePortrait;
    final double horizontalPadding = 16 * scale;
    final double verticalSpacingLarge = 24 * scale;

    return Scaffold(
      backgroundColor: const Color(0xFFCEEF91),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/character/bearTeacher.png',
                    height: 300 * scale,
                    fit: BoxFit.contain,
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
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
                                style: TextStyle(
                                  fontSize: parentH * 0.12 * 0.9,
                                ),
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
                                style: TextStyle(
                                  fontSize: parentH * 0.12 * 0.9,
                                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: scale * 64, // 16% of screen width
                      height: scale * 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBF3),
                        borderRadius: BorderRadius.circular(8.0 * scale),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          try {
                            final nav = Navigator.of(context);
                            bool existed = await context
                                .read<LoginStatus>()
                                .loginWithProvider('APPLE');
                            if (!mounted) return;
                            if (existed) {
                              // 200 → 홈 화면으로
                              nav.pushReplacementNamed('/home');
                            } else {
                              // 404 → 가입 페이지로
                              nav.pushNamed('/sign', arguments: 'APPLE');
                            }
                          } on Exception catch (e) {
                            // TODO
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
                            );
                          }
                        },
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
                        borderRadius: BorderRadius.circular(8.0 * scale),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          try {
                            final nav = Navigator.of(context);
                            bool existed = await context
                                .read<LoginStatus>()
                                .loginWithProvider('GOOGLE');
                            if (existed) {
                              // 200 → 홈 화면으로
                              nav.pushReplacementNamed('/home');
                            } else {
                              // 404 → 가입 페이지로
                              nav.pushNamed('/sign', arguments: 'GOOGLE');
                            }
                          } on Exception catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
                            );
                          }
                        },
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
                        borderRadius: BorderRadius.circular(8.0 * scale),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          try {
                            final nav = Navigator.of(context);
                            bool existed = await context
                                .read<LoginStatus>()
                                .loginWithProvider('KAKAO');
                            if (existed) {
                              // 200 → 홈 화면으로
                              nav.pushReplacementNamed('/home');
                            } else {
                              // 404 → 가입 페이지로
                              nav.pushNamed('/sign', arguments: 'KAKAO');
                            }
                          } on Exception catch (e) {
                            // TODO
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
                            );
                          }
                        },
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
                        borderRadius: BorderRadius.circular(8.0 * scale),
                      ),
                      child: TextButton(
                        onPressed: () {
                          context.read<LoginStatus>().loginAsGuest('Sehwan');
                        },
                        child: Text(
                          '게스트',
                          style: TextStyle(
                            fontSize: scale * 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalSpacingLarge * 0.3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
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
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Widget _buildLandscape(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double baseLandscape = 844.0;
    final double scale = screenSize.height / baseLandscape;
    final double horizontalPadding = 16 * scale;
    final double verticalSpacingLarge = 24 * scale;

    return Scaffold(
      backgroundColor: const Color(0xFFCEEF91),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/character/bearTeacher.png',
                    height: 300 * scale,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 20 * scale),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: screenSize.width * 0.6,
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
                                  style: TextStyle(
                                    fontSize: parentH * 0.12 * 0.9,
                                  ),
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
                                  style: TextStyle(
                                    fontSize: parentH * 0.12 * 0.9,
                                  ),
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
                ),
                SizedBox(height: verticalSpacingLarge),
                // Align social buttons under the login box
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                          screenSize.width * 0.6, // same width as login box
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: scale * 80, // 16% of screen width
                          height: scale * 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBF3),
                            borderRadius: BorderRadius.circular(8.0 * scale),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              try {
                                final nav = Navigator.of(context);
                                bool existed = await context
                                    .read<LoginStatus>()
                                    .loginWithProvider('APPLE');
                                if (existed) {
                                  // 200 → 홈 화면으로
                                  nav.pushReplacementNamed('/home');
                                } else {
                                  // 404 → 가입 페이지로
                                  nav.pushNamed('/sign', arguments: 'APPLE');
                                }
                              } on Exception catch (e) {
                                // TODO
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
                                );
                              }
                            },
                            icon: const Icon(Icons.apple),
                            tooltip: 'Apple 로그인',
                            iconSize: scale * 50,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: scale * 80,
                          height: scale * 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBF3),
                            borderRadius: BorderRadius.circular(8.0 * scale),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              try {
                                final nav = Navigator.of(context);
                                bool existed = await context
                                    .read<LoginStatus>()
                                    .loginWithProvider('GOOGLE');
                                if (existed) {
                                  // 200 → 홈 화면으로
                                  nav.pushReplacementNamed('/home');
                                } else {
                                  // 404 → 가입 페이지로
                                  nav.pushNamed(
                                    '/sign',
                                    arguments: {
                                      'provider': 'GOOGLE',
                                      'email':
                                          context.read<LoginStatus>().email,
                                    },
                                  );
                                }
                              } on Exception catch (e) {
                                // TODO
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
                                );
                              }
                            },
                            icon: const Icon(Icons.g_mobiledata),
                            tooltip: 'Google 로그인',
                            iconSize: scale * 50,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: scale * 80,
                          height: scale * 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBF3),
                            borderRadius: BorderRadius.circular(8.0 * scale),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              try {
                                final nav = Navigator.of(context);
                                bool existed = await context
                                    .read<LoginStatus>()
                                    .loginWithProvider('KAKAO');
                                if (existed) {
                                  // 200 → 홈 화면으로
                                  nav.pushReplacementNamed('/home');
                                } else {
                                  // 404 → 가입 페이지로
                                  nav.pushNamed('/sign', arguments: 'KAKAO');
                                }
                              } catch (e) {
                                // 로그인 취소 또는 실패 → 아무 것도 안 함
                                print('로그인 취소 또는 실패');
                              }
                            },
                            icon: const Icon(Icons.chat),
                            tooltip: 'Kakao 로그인',
                            iconSize: scale * 50,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: scale * 80, // 16% of screen width
                          height: scale * 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBF3),
                            borderRadius: BorderRadius.circular(8.0 * scale),
                          ),
                          child: TextButton(
                            onPressed: () {
                              context.read<LoginStatus>().loginAsGuest(
                                'Sehwan',
                              );
                            },
                            child: Text(
                              '게스트',
                              style: TextStyle(
                                fontSize: scale * 19,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: verticalSpacingLarge * 0.3),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.1,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          // 회원가입 페이지로 이동
                          Navigator.of(context).pushNamed(
                            '/sign',
                            arguments: {
                              'provider': 'KAKAO',
                              'email': 'tlrpv12@naver.com',
                            },
                          );
                        },
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: scale * 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '아이디/비밀번호 찾기',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: scale * 20,
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
      ),
    );
  }
}
