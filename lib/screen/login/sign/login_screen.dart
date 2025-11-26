import 'package:aiwriting_collection/model/language_provider.dart';
import 'package:aiwriting_collection/model/typeEnum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/login_status.dart';
import 'package:flutter/foundation.dart'; // kDebugMode
import 'package:aiwriting_collection/screen/login/sign/sign_screen.dart';
import 'package:aiwriting_collection/generated/app_localizations.dart';

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

  void _updateLanguageBasedOnUserType() {
    final loginStatus = context.read<LoginStatus>();
    final languageProvider = context.read<LanguageProvider>();

    final userType = loginStatus.userType;
    if (userType == UserType.FOREIGN) {
      languageProvider.changeLanguage(const Locale('en'));
    } else {
      languageProvider.changeLanguage(const Locale('ko'));
    }
  }

  Future<void> _handleLoginResult(Map<String, dynamic>? result) async {
    if (!mounted || result == null) return;

    final nav = Navigator.of(context);

    if (result['success'] == true) {
      // This is where the user is successfully logged in.
      // I will update the language here.
      _updateLanguageBasedOnUserType();
      nav.pushReplacementNamed('/home');
    } else {
      nav.pushNamed(
        '/sign',
        arguments: {
          'provider': context.read<LoginStatus>().lastProvider,
          'email': result['email'],
        },
      );
    }
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
    final appLocalizations = AppLocalizations.of(context)!;

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
                        'assets/character/bearTeacher_noblank.png',
                        height: 220 * scale,
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: 10 * scale),

                    // 제목 & 보조 카피
                    Text(
                      "손글손글",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 60 * scale,
                        fontWeight: FontWeight.w800,
                        color: const Color.fromARGB(255, 113, 45, 45),
                        height: 0.6,
                      ),
                    ),
                    SizedBox(height: 20 * scale),
                    Text(
                      appLocalizations.loginSubtitle,
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
                      label: appLocalizations.loginWithApple,
                      icon: Icons.apple,
                      background: Colors.black,
                      foreground: Colors.white,
                      border: null,
                      onPressed: () async {
                        final result = await context
                            .read<LoginStatus>()
                            .loginWithProvider('APPLE');
                        await _handleLoginResult(result);
                      },
                    ),
                    SizedBox(height: 10 * scale),

                    _socialBtn(
                      context,
                      scale: scale,
                      label: appLocalizations.loginWithGoogle,
                      icon: Icons.g_mobiledata, // 필요시 G 로고 에셋으로 교체
                      background: Color(0xFF466437),
                      foreground: Colors.white,
                      border: const BorderSide(color: Colors.black12),
                      onPressed: () async {
                        final result = await context
                            .read<LoginStatus>()
                            .loginWithProvider('GOOGLE');
                        await _handleLoginResult(result);
                      },
                    ),
                    SizedBox(height: 10 * scale),

                    _socialBtn(
                      context,
                      scale: scale,
                      label: appLocalizations.loginWithKakao,
                      icon: Icons.chat, // 필요시 카카오 로고 에셋으로 교체
                      background: const Color(0xFFFFE600),
                      foreground: Colors.black,
                      border: null,
                      onPressed: () async {
                        final result = await context
                            .read<LoginStatus>()
                            .loginWithProvider('KAKAO');
                        await _handleLoginResult(result);
                      },
                    ),
                    SizedBox(height: 10 * scale),

                    // 게스트 모드 버튼 (세컨더리 스타일)
                    _socialBtn(
                      context,
                      scale: scale,
                      label: appLocalizations.loginAsGuest,
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
                      appLocalizations.termsAndConditions,
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
                            appLocalizations.termsOfService,
                            style: TextStyle(
                              fontSize: 12 * scale,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          ' · ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12 * scale,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            /* TODO: 개인정보처리방침 */
                          },
                          child: Text(
                            appLocalizations.privacyPolicy,
                            style: TextStyle(
                              fontSize: 12 * scale,
                              color: Colors.black87,
                            ),
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
    final appLocalizations = AppLocalizations.of(context)!;

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
                    SizedBox(height: 20 * scale),

                    // 마스코트
                    Center(
                      child: Image.asset(
                        'assets/character/bearTeacher_noblank.png',
                        height: 250 * scale,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // 제목 & 보조 카피
                    Text(
                      "손글손글",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 113, 45, 45),
                        fontSize: 70 * scale,
                        fontWeight: FontWeight.w800,
                        height: 0.6,
                      ),
                    ),
                    SizedBox(height: 30 * scale),
                    Text(
                      appLocalizations.loginSubtitle,
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
                      label: appLocalizations.loginWithApple,
                      icon: Icons.apple, // 필요시 브랜드 에셋으로 교체
                      background: Colors.black,
                      foreground: Colors.white,
                      border: null,
                      onPressed: () async {
                        final result = await context
                            .read<LoginStatus>()
                            .loginWithProvider('APPLE');
                        await _handleLoginResult(result);
                      },
                    ),
                    SizedBox(height: 10 * scale),

                    _socialBtn(
                      context,
                      scale: scale,
                      label: appLocalizations.loginWithGoogle,
                      icon: Icons.g_mobiledata, // 필요시 G 로고 에셋으로 교체
                      background: Color(0xFF466437),
                      foreground: Colors.white,
                      border: const BorderSide(color: Colors.black12),
                      onPressed: () async {
                        final result = await context
                            .read<LoginStatus>()
                            .loginWithProvider('GOOGLE');
                        await _handleLoginResult(result);
                      },
                    ),
                    SizedBox(height: 10 * scale),

                    _socialBtn(
                      context,
                      scale: scale,
                      label: appLocalizations.loginWithKakao,
                      icon: Icons.chat, // 필요시 카카오 로고 에셋으로 교체
                      background: const Color(0xFFFFE600),
                      foreground: Colors.black,
                      border: null,
                      onPressed: () async {
                        final result = await context
                            .read<LoginStatus>()
                            .loginWithProvider('KAKAO');
                        await _handleLoginResult(result);
                      },
                    ),
                    SizedBox(height: 10 * scale),

                    // 게스트 모드 버튼 (세컨더리 스타일)
                    _socialBtn(
                      context,
                      scale: scale,
                      label: appLocalizations.loginAsGuest,
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
                      appLocalizations.termsAndConditions,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11 * scale,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 6 * scale),

                    _buildDebugSignPreviewButton(context),

                    // 약관 링크
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            /* TODO: 약관 화면 */
                          },
                          child: Text(
                            appLocalizations.termsOfService,
                            style: TextStyle(
                              fontSize: 12 * scale,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          ' · ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12 * scale,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            /* TODO: 개인정보처리방침 */
                          },
                          child: Text(
                            appLocalizations.privacyPolicy,
                            style: TextStyle(
                              fontSize: 12 * scale,
                              color: Colors.black87,
                            ),
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

Widget _buildDebugSignPreviewButton(BuildContext context) {
  if (!kDebugMode) return const SizedBox.shrink(); // 릴리즈 빌드에서 숨김
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
    child: TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.build),
      label: const Text('회원가입 UI 프리뷰 (DEBUG)'),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (_) => const SignScreen(
                  debugEmail: 'preview_user@example.com',
                  debugProvider: 'google',
                  useMockApi: true, // 서버/파이어베이스 호출 생략
                ),
          ),
        );
      },
    ),
  );
}
