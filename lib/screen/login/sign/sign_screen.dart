import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../model/login_status.dart';
import '../../../api.dart';
import 'package:flutter/foundation.dart';

class SignScreen extends StatefulWidget {
  // ✅ 디버그 프리뷰용(선택): 릴리즈 빌드에는 영향 없음
  final String? debugEmail;
  final String? debugProvider;
  final bool useMockApi;

  const SignScreen({
    super.key,
    this.debugEmail,
    this.debugProvider,
    this.useMockApi = false,
  });
  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  bool _isLoading = false;
  final api = Api();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  DateTime? _birthdate;
  File? _profileImage;
  String _provider = '';
  InputDecoration _deco(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white, // 흰 배경
    labelStyle: const TextStyle(color: Color(0xFF757575)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFFB6E388),
        width: 2,
      ), // 파스텔 초록 포커스
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ 디버그 프리뷰: 라우트/Firebase 대신 미리 주입한 값 사용
    if (kDebugMode &&
        (widget.debugEmail != null || widget.debugProvider != null)) {
      _provider = widget.debugProvider ?? _provider;
      final overrideEmail = widget.debugEmail ?? '';
      if (_emailController.text != overrideEmail) {
        _emailController.text = overrideEmail;
      }
      print(
        "[SignScreen][DEBUG PREVIEW] provider=$_provider, email=${_emailController.text}",
      );
      return; // 아래 실제 라우트/Firebase 분기 생략
    }

    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    String? routeProvider;
    String? routeEmail;
    if (routeArgs is Map<String, dynamic>) {
      routeProvider = routeArgs['provider'] as String?;
      routeEmail = routeArgs['email'] as String?;
    } else if (routeArgs is String) {
      routeProvider = routeArgs;
    } else {
      routeProvider = context.read<LoginStatus>().lastProvider;
    }
    _provider = routeProvider ?? '';

    // 이메일은: 라우트에서 온 값 우선, 없으면 FirebaseAuth의 현재 사용자 이메일로 채움
    final firebaseEmail = FirebaseAuth.instance.currentUser?.email;
    final effectiveEmail =
        (routeEmail != null && routeEmail.trim().isNotEmpty)
            ? routeEmail
            : (firebaseEmail ?? '');
    if (_emailController.text != effectiveEmail) {
      _emailController.text = effectiveEmail;
    }

    print(
      "[SignScreen] didChangeDependencies, provider: '$_provider', email: '${_emailController.text}'",
    );
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
    final double baseWidth = 390.0;
    final double scale = screenSize.width / baseWidth;
    final double horizontalPadding = 16 * scale;
    final double verticalSpacingLarge = 24 * scale;
    final double verticalSpacing = 16 * scale;

    final TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 14 * scale,
    );
    final TextStyle buttonTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 16 * scale,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF3),
      appBar: AppBar(
        title: Text(
          '회원가입',
          style: TextStyle(color: Colors.black, fontSize: 20 * scale),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _buildBody(
        context,
        scale,
        textStyle,
        buttonTextStyle,
        horizontalPadding,
        verticalSpacing,
        verticalSpacingLarge,
      ),
    );
  }

  Widget _buildLandscape(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double baseHeight = 390.0;
    final double scale = screenSize.height / baseHeight;
    final double horizontalPadding = 16 * scale;
    final double verticalSpacingLarge = 24 * scale;
    final double verticalSpacing = 16 * scale;

    final TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16 * scale,
    );
    final TextStyle buttonTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 18 * scale,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '회원가입',
          style: TextStyle(color: Colors.black, fontSize: 20 * scale),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _buildBody(
        context,
        scale,
        textStyle,
        buttonTextStyle,
        horizontalPadding,
        verticalSpacing,
        verticalSpacingLarge,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    double scale,
    TextStyle textStyle,
    TextStyle buttonTextStyle,
    double horizontalPadding,
    double verticalSpacing,
    double verticalSpacingLarge,
  ) {
    final bool hasEmail = _emailController.text.isNotEmpty;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: verticalSpacingLarge),
            // Profile image picker
            _buildProfilePicker(),
            SizedBox(height: verticalSpacingLarge),
            // Email field (read-only)
            Padding(
              padding: EdgeInsets.only(bottom: verticalSpacing),
              child: TextFormField(
                controller: _emailController,
                style: textStyle,
                decoration: _deco('Email'),
                readOnly: hasEmail,
                enabled: !hasEmail,
              ),
            ),
            // Nickname field
            Padding(
              padding: EdgeInsets.only(bottom: verticalSpacing),
              child: TextFormField(
                controller: _nicknameController,
                style: textStyle,
                decoration: _deco('Nickname'),
                validator: (v) => v == null || v.isEmpty ? '닉네임을 입력하세요' : null,
              ),
            ),
            // Birthdate picker
            Padding(
              padding: EdgeInsets.only(bottom: verticalSpacingLarge),
              child: _buildBirthdateBox(),
            ),
            _buildPrimaryButton(
              onPressed:
                  _isLoading
                      ? null
                      : () async {
                        setState(() => _isLoading = true);
                        try {
                          // ✅ 여기엔 네가 쓰던 기존 onPressed 로직(모의 성공 분기 + 실제 signup)이 그대로 들어감
                          // (우리가 바꾼 건 '버튼 모양'뿐이야)
                          if (kDebugMode && widget.useMockApi) {
                            await Future.delayed(
                              const Duration(milliseconds: 300),
                            );
                            debugPrint(
                              '[DEBUG PREVIEW] signup payload (mock) -> '
                              'email=${_emailController.text}, provider=$_provider',
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('디버그 프리뷰: 회원가입 성공(모의)'),
                                ),
                              );
                              Navigator.pushReplacementNamed(context, '/home');
                            }
                            return;
                          }

                          if (!_formKey.currentState!.validate() ||
                              _birthdate == null) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('입력값을 확인해주세요.')),
                              );
                            }
                            return;
                          }

                          await FirebaseAuth.instance.currentUser!.getIdToken(
                            true,
                          );
                          final idToken =
                              context.read<LoginStatus>().firebaseIdToken;
                          _provider =
                              context.read<LoginStatus>().lastProvider ?? '';
                          if (idToken == null || idToken.isEmpty)
                            throw Exception('No ID token');

                          final payload = {
                            'id_token': idToken,
                            'provider': _provider,
                            'email': _emailController.text,
                            'nickname': _nicknameController.text,
                            'birthdate': _birthdate!.toIso8601String(),
                            'filePath': _profileImage?.path,
                          };

                          await api.signup(payload);
                          debugPrint('회원 가입 성공: $payload');
                          if (mounted)
                            Navigator.pushReplacementNamed(context, '/home');
                        } catch (e) {
                          await FirebaseAuth.instance.signOut();
                          context.read<LoginStatus>().logout();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('회원가입에 실패했습니다: $e')),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      },
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicker() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          final XFile? file = await ImagePicker().pickImage(
            source: ImageSource.gallery,
          );
          if (file != null) setState(() => _profileImage = File(file.path));
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 본체: 파스텔 원형 + 보더 + 그림자
            Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEAF7DB), // 연초록 배경
                border: Border.all(color: Color(0xFFE5E5E5)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
                image:
                    _profileImage != null
                        ? DecorationImage(
                          image: FileImage(_profileImage!),
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
              child:
                  _profileImage == null
                      ? const Icon(
                        Icons.camera_alt,
                        size: 32,
                        color: Color(0xFF4A4A4A),
                      )
                      : null,
            ),

            // 우하단 작은 편집 배지 (카메라 아이콘)
            Positioned(
              right: -4,
              bottom: -4,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFFE5E5E5)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit,
                  size: 18,
                  color: Color(0xFF7BB661),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBirthdateBox() {
    final label =
        _birthdate == null
            ? '생년월일을 선택해주세요'
            : '생년월일: ${_birthdate!.toLocal().toString().split(' ').first}';

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime(2000, 1, 1),
          firstDate: DateTime(1900, 1, 1),
          lastDate: DateTime.now(),
        );
        if (date != null) setState(() => _birthdate = date);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E5E5), width: 1.2),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, color: Color(0xFF7BB661)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFFBDBDBD),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required VoidCallback? onPressed,
    required bool isLoading,
    String label = '회원가입 완료',
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFCEEF91), // 파스텔 그린
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 1,
      ),
      child:
          isLoading
              ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
              : const Text(
                '회원가입 완료',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
    );
  }
}
