import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../model/login_status.dart';
import '../../../api.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

    final bool hasEmail = _emailController.text.isNotEmpty;

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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: verticalSpacingLarge),
              // Profile image picker
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final XFile? file = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (file != null)
                      setState(() => _profileImage = File(file.path));
                  },
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage:
                        _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                    child:
                        _profileImage == null
                            ? const Icon(Icons.camera_alt, size: 48)
                            : null,
                  ),
                ),
              ),
              SizedBox(height: verticalSpacingLarge),
              // Email field (read-only)
              Padding(
                padding: EdgeInsets.only(bottom: verticalSpacing),
                child: TextFormField(
                  controller: _emailController,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: const OutlineInputBorder(),
                    labelStyle: textStyle,
                  ),
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
                  decoration: InputDecoration(
                    labelText: 'Nickname',
                    border: const OutlineInputBorder(),
                    labelStyle: textStyle,
                  ),
                  validator:
                      (v) => v == null || v.isEmpty ? '닉네임을 입력하세요' : null,
                ),
              ),
              // Birthdate picker
              Padding(
                padding: EdgeInsets.only(bottom: verticalSpacingLarge),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _birthdate == null
                            ? '생년월일 선택'
                            : '생년월일: ${_birthdate!.toLocal().toString().split(' ')[0]}',
                        style: textStyle,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) setState(() => _birthdate = date);
                      },
                      child: Text('선택', style: textStyle),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48 * scale),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    _isLoading
                        ? null
                        : () async {
                          setState(() => _isLoading = true);
                          try {
                            if (!_formKey.currentState!.validate() ||
                                _birthdate == null)
                              return;

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
                              // 선택적: 프로필 이미지가 있으면 multipart로 함께 전송 (api.signup에서 처리)
                              'filePath': _profileImage?.path,
                            };

                            final res = await api.signup(payload);
                            if (res.statusCode == 200 || res.statusCode == 201) {
                              final body = jsonDecode(res.body);
                              final jwt = body['jwt'];
                              final userId = body['user_id'];
                              final uid = context.read<LoginStatus>().uid;
                              api.setJwt(jwt);
                              context.read<LoginStatus>().setUser(
                                    userId: userId,
                                    uid: uid!,
                                    jwt: jwt,
                                    email: _emailController.text,
                                  );
                              print('회원 가입 성공: $payload');
                              Navigator.pushReplacementNamed(context, '/home');
                            } else {
                              throw Exception('Server error: ${res.statusCode} ${res.body}');
                            }
                          } catch (e) {
                            await FirebaseAuth.instance.signOut();
                            context.read<LoginStatus>().logout();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('회원가입에 실패했습니다: $e')),
                            );
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        },
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Text('회원 가입', style: buttonTextStyle),
              ),
            ],
          ),
        ),
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

    final bool hasEmail = _emailController.text.isNotEmpty;

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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: verticalSpacingLarge),
              // Profile image picker
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final XFile? file = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (file != null)
                      setState(() => _profileImage = File(file.path));
                  },
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage:
                        _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                    child:
                        _profileImage == null
                            ? const Icon(Icons.camera_alt, size: 48)
                            : null,
                  ),
                ),
              ),
              SizedBox(height: verticalSpacingLarge),
              // Email field (read-only)
              Padding(
                padding: EdgeInsets.only(bottom: verticalSpacing),
                child: TextFormField(
                  controller: _emailController,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: const OutlineInputBorder(),
                    labelStyle: textStyle,
                  ),
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
                  decoration: InputDecoration(
                    labelText: 'Nickname',
                    border: const OutlineInputBorder(),
                    labelStyle: textStyle,
                  ),
                  validator:
                      (v) => v == null || v.isEmpty ? '닉네임을 입력하세요' : null,
                ),
              ),
              // Birthdate picker
              Padding(
                padding: EdgeInsets.only(bottom: verticalSpacingLarge),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _birthdate == null
                            ? '생년월일 선택'
                            : '생년월일: ${_birthdate!.toLocal().toString().split(' ')[0]}',
                        style: textStyle,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) setState(() => _birthdate = date);
                      },
                      child: Text('선택', style: textStyle),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48 * scale),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    _isLoading
                        ? null
                        : () async {
                          setState(() => _isLoading = true);
                          try {
                            if (!_formKey.currentState!.validate() ||
                                _birthdate == null)
                              return;

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
                              // 선택적: 프로필 이미지가 있으면 multipart로 함께 전송 (api.signup에서 처리)
                              'filePath': _profileImage?.path,
                            };

                            final res = await api.signup(payload);
                            if (res.statusCode == 200 || res.statusCode == 201) {
                              final body = jsonDecode(res.body);
                              final jwt = body['jwt'];
                              final userId = body['user_id'];
                              final uid = context.read<LoginStatus>().uid;
                              api.setJwt(jwt);
                              context.read<LoginStatus>().setUser(
                                    userId: userId,
                                    uid: uid!,
                                    jwt: jwt,
                                    email: _emailController.text,
                                  );
                              print('회원 가입 성공: $payload');
                              Navigator.pushReplacementNamed(context, '/home');
                            } else {
                              throw Exception('Server error: ${res.statusCode} ${res.body}');
                            }
                          } catch (e) {
                            await FirebaseAuth.instance.signOut();
                            context.read<LoginStatus>().logout();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('회원가입에 실패했습니다: $e')),
                            );
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        },
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Text('회원 가입', style: buttonTextStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
