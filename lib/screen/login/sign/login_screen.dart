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

    return Scaffold(
      backgroundColor: const Color(0xFFCEEF91),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: ConstrainedBox(
                // 태블릿에서도 폭이 너무 넓어지지 않도록 제한
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 28 * scale),

                    // 마스코트
                    Center(
                      child: Image.asset(
                        'assets/character/bearTeacher.png',
                        height: 220 * scale,
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: 16 * scale),

                    // 제목 & 보조 카피
                    Text(
                      'AI 손글씨 교정을 시작해요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22 * scale,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 6 * scale),
                    Text(
                      '소셜 계정으로 간편하게 로그인',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14 * scale,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 20 * scale),

                    // 소셜 로그인 버튼들 (세로 스택)
                    _socialBtn(
                      context,
                      scale: scale,
                      label: 'Apple로 계속하기',
                      icon: Icons.apple,
                      background: Colors.black,
                      foreground: Colors.white,
                      border: null,
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
                        } on Exception {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 10 * scale),

                    _socialBtn(
                      context,
                      scale: scale,
                      label: 'Google로 계속하기',
                      icon: Icons.g_mobiledata, // 필요시 G 로고 에셋으로 교체
                      background: Color(0xFF466437),
                      foreground: Colors.white,
                      border: const BorderSide(color: Colors.black12),
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
                        } on Exception {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 10 * scale),

                    _socialBtn(
                      context,
                      scale: scale,
                      label: '카카오로 계속하기',
                      icon: Icons.chat, // 필요시 카카오 로고 에셋으로 교체
                      background: const Color(0xFFFFE600),
                      foreground: Colors.black,
                      border: null,
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
                        } on Exception {
                          // TODO
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 10 * scale),

                    // 게스트 모드 버튼 (세컨더리 스타일)
                    _socialBtn(
                      context,
                      scale: scale,
                      label: '게스트로 먼저 체험',
                      icon: Icons.person_outline, // 필요시 G 로고 에셋으로 교체
                      background: Colors.white,
                      foreground: Colors.black87,
                      border: const BorderSide(color: Colors.black12),
                      onPressed: () {
                        // 기존 기능 그대로
                        context.read<LoginStatus>().loginAsGuest('Sehwan');
                      },
                    ),

                    SizedBox(height: 18 * scale),

                    // 약관 문구 (작게)
                    Text(
                      '로그인 시 이용약관 및 개인정보처리방침에 동의합니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11 * scale,
                        color: Colors.black54,
                      ),
                    ),

                    // (옵션) 약관 링크 두 개
                    SizedBox(height: 6 * scale),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            /* TODO: 약관 화면 */
                          },
                          child: Text(
                            '이용약관',
                            style: TextStyle(fontSize: 12 * scale),
                          ),
                        ),
                        Text(
                          ' · ',
                          style: TextStyle(
                            color: Colors.black26,
                            fontSize: 12 * scale,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            /* TODO: 개인정보처리방침 */
                          },
                          child: Text(
                            '개인정보처리방침',
                            style: TextStyle(fontSize: 12 * scale),
                          ),
                        ),
                      ],
                    ),

                    // (선택) 게스트 체험 링크가 필요하면 아래 주석 해제
                    // SizedBox(height: 6 * scale),
                    // TextButton(
                    //   onPressed: () => context.read<LoginStatus>().setLoggedIn(true),
                    //   child: Text('게스트로 먼저 체험', style: TextStyle(fontSize: 13 * scale, fontWeight: FontWeight.w700)),
                    // ),
                    SizedBox(height: 24 * scale),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLandscape(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double baseLandscape = 844.0;
    final double scale = screenSize.height / baseLandscape; // 가로모드에서는 높이 기준
    final double horizontalPadding = 16 * scale;

    return Scaffold(
      backgroundColor: const Color(0xFFCEEF91),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: ConstrainedBox(
                // 가로폭이 넓어도 너무 퍼지지 않도록 제한
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 24 * scale),

                    // 마스코트
                    Center(
                      child: Image.asset(
                        'assets/character/bearTeacher.png',
                        height: 220 * scale,
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: 16 * scale),

                    // 제목 & 보조 카피
                    Text(
                      'AI 손글씨 교정을 시작해요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22 * scale,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 6 * scale),
                    Text(
                      '소셜 계정으로 간편하게 로그인',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14 * scale,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 20 * scale),

                    // 소셜 로그인 버튼들
                    _socialBtn(
                      context,
                      scale: scale,
                      label: 'Apple로 계속하기',
                      icon: Icons.apple, // 필요시 브랜드 에셋으로 교체
                      background: Colors.black,
                      foreground: Colors.white,
                      border: null,
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
                        } on Exception {
                          // TODO
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 10 * scale),

                    _socialBtn(
                      context,
                      scale: scale,
                      label: 'Google로 계속하기',
                      icon: Icons.g_mobiledata, // 필요시 G 로고 에셋으로 교체
                      background: Color(0xFF466437),
                      foreground: Colors.white,
                      border: const BorderSide(color: Colors.black12),
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
                                'email': context.read<LoginStatus>().email,
                              },
                            );
                          }
                        } on Exception {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 10 * scale),

                    _socialBtn(
                      context,
                      scale: scale,
                      label: '카카오로 계속하기',
                      icon: Icons.chat, // 필요시 카카오 로고 에셋으로 교체
                      background: const Color(0xFFFFE600),
                      foreground: Colors.black,
                      border: null,
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
                    ),
                    SizedBox(height: 10 * scale),

                    // 게스트 모드 버튼 (세컨더리 스타일)
                    _socialBtn(
                      context,
                      scale: scale,
                      label: '게스트로 먼저 체험',
                      icon: Icons.person_outline, // 필요시 G 로고 에셋으로 교체
                      background: Colors.white,
                      foreground: Colors.black87,
                      border: const BorderSide(color: Colors.black12),
                      onPressed: () {
                        // 기존 기능 그대로
                        context.read<LoginStatus>().loginAsGuest('Sehwan');
                      },
                    ),

                    SizedBox(height: 16 * scale),

                    // 약관 문구
                    Text(
                      '로그인 시 이용약관 및 개인정보처리방침에 동의합니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11 * scale,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 6 * scale),

                    // 약관 링크
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            /* TODO: 약관 화면 */
                          },
                          child: Text(
                            '이용약관',
                            style: TextStyle(fontSize: 12 * scale),
                          ),
                        ),
                        Text(
                          ' · ',
                          style: TextStyle(
                            color: Colors.black26,
                            fontSize: 12 * scale,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            /* TODO: 개인정보처리방침 */
                          },
                          child: Text(
                            '개인정보처리방침',
                            style: TextStyle(fontSize: 12 * scale),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24 * scale),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _socialBtn(
  BuildContext context, {
  required double scale,
  required String label,
  required IconData icon,
  required VoidCallback onPressed,
  Color? background,
  Color? foreground,
  BorderSide? border,
}) {
  return SizedBox(
    height: 52 * scale,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 22 * scale),
      label: Text(
        label,
        style: TextStyle(fontSize: 16 * scale, fontWeight: FontWeight.w800),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: background ?? Theme.of(context).colorScheme.primary,
        foregroundColor: foreground ?? Theme.of(context).colorScheme.onPrimary,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14 * scale),
          side: border ?? BorderSide.none,
        ),
      ),
    ),
  );
}
