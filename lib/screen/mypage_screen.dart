import 'package:aiwriting_collection/api.dart';
import 'package:aiwriting_collection/model/common/type_enum.dart';
import 'package:aiwriting_collection/model/content/user_profile.dart';
import 'package:aiwriting_collection/model/provider/login_status.dart';
import 'package:aiwriting_collection/widget/dialog/edit_profile_dialog.dart';
import 'package:aiwriting_collection/widget/practice/practice_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:aiwriting_collection/generated/app_localizations.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

// Helper function to run in a separate isolate
Uint8List _decodeResizeEncode(Uint8List data) {
  final image = img.decodeImage(data);
  if (image == null) {
    throw Exception("Failed to decode image");
  }
  final resized = img.copyResize(image, width: 512);
  return Uint8List.fromList(img.encodeJpg(resized, quality: 85));
}

class _MypageScreenState extends State<MypageScreen> {
  bool isDailyAlarmOn = false;
  final api = Api();
  UserProfile? _profile;
  bool _loadingProfile = true;

  // 로그인 상태 변경에 반응해 프로필을 재로딩하기 위한 상태
  int _lastLoadedUserId = 0;
  late final LoginStatus _loginStatus;

  final ImagePicker _imagePicker = ImagePicker();

  String _getUserTypeName(UserType type, AppLocalizations appLocalizations) {
    switch (type) {
      case UserType.CHILD:
        return appLocalizations.userTypeChild;
      case UserType.ADULT:
        return appLocalizations.userTypeAdult;
      case UserType.FOREIGN:
        return appLocalizations.userTypeForeign;
    }
  }

  Future<Uint8List> _resizeImage(Uint8List data) async {
    return await compute(_decodeResizeEncode, data);
  }

  Future<void> _pickProfileImage() async {
    final appLocalizations = AppLocalizations.of(context)!;

    // Set loading state immediately
    setState(() {
      _loadingProfile = true;
    });

    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      // If user cancels, turn off loading state
      if (picked == null) {
        setState(() {
          _loadingProfile = false;
        });
        return;
      }

      final uid = _lastLoadedUserId;

      final bytes = await picked.readAsBytes();
      final resizedBytes = await _resizeImage(bytes);

      await api.uploadProfileImage(resizedBytes, uid);

      // Reload profile on success
      await _loadUserProfile(force: true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.profileImageUpdateSuccess)),
      );
    } catch (e) {
      if (!mounted) return;
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${appLocalizations.profileImageUpdateFailed}${e.toString().replaceFirst("Exception: ", "")}',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loadingProfile = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Provider의 로그인 상태를 캐시하고 변경을 구독
    _loginStatus = context.read<LoginStatus>();
    _loginStatus.addListener(_onLoginStatusChanged);

    // 첫 프레임 이후 userId가 이미 세팅되어 있다면 즉시 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = _loginStatus.userId;
      if (uid != null) {
        _loadUserProfile();
      }
    });
  }

  void _onLoginStatusChanged() {
    final uid = _loginStatus.userId;
    if (!mounted) return;
    // userId가 생기거나 바뀌면 프로필 재로딩
    if (uid != null && uid != _lastLoadedUserId) {
      _loadUserProfile(force: true);
    }
  }

  Future<void> _loadUserProfile({bool force = false}) async {
    try {
      final userId = context.read<LoginStatus>().userId;
      // 아직 로그인 정보가 세팅되지 않았다면 기다렸다가 listener에서 재시도
      if (userId == null) {
        return;
      }
      // 이미 같은 유저로 로드되어 있고 강제 재로딩이 아니라면 스킵
      if (!force && _lastLoadedUserId == userId && _profile != null) {
        return;
      }
      if (mounted) {
        setState(() {
          _loadingProfile = true;
        });
      }
      final profile = await api.getUserProfile(userId);
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _lastLoadedUserId = userId;
        _loadingProfile = false;
      });
    } catch (e, st) {
      print('❌ _loadUserProfile error: $e');
      print(st);
      if (mounted) {
        setState(() {
          _loadingProfile = false;
        });
      }
    }
  }

  void _showEditProfileDialog() async {
    if (_profile == null) return;
    final appLocalizations = AppLocalizations.of(context)!;

    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) =>
              EditProfileDialog(profile: _profile!, userId: _lastLoadedUserId),
    );

    if (result == true) {
      await _loadUserProfile(force: true);
    } else if (result == false) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appLocalizations.profileUpdateCancelled)),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    final loginStatus = context.read<LoginStatus>();

    // Perform logout
    await loginStatus.logout();

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  void dispose() {
    // listener 해제
    _loginStatus.removeListener(_onLoginStatusChanged);
    super.dispose();
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

  //세로 화면(모바일 용)
  Widget _buildPortrait(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;
    // Use width-based scaling in portrait, height-based in landscape
    final double basePortrait = 390.0;
    final double baseLandscape = 844.0; // e.g. typical device height
    final double scale =
        isLandscape
            ? screenSize.height / baseLandscape
            : screenSize.width / basePortrait;
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // 상단 배경 이미지 (예: 노트 배경 등)
                Container(
                  width: screenSize.width,
                  height: 180 * scale, // 상단 높이를 적절히 조정
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/mypage2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // '손글씨 연습' 텍스트와 옆 이미지
                Positioned(
                  top: 80 * scale,
                  left: 20 * scale,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        appLocalizations.myPageTitle,
                        style: TextStyle(
                          fontSize: 23 * scale,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 8 * scale),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16 * scale),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16 * scale,
                vertical: 8 * scale,
              ),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        child:
                            _loadingProfile
                                ? CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  radius: 70 * scale,
                                  child: CircularProgressIndicator(),
                                )
                                : CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  radius: 70 * scale,
                                  backgroundImage:
                                      _profile?.profilePic != null
                                          ? CachedNetworkImageProvider(
                                            _profile!.profilePic!,
                                          )
                                          : null,
                                  child:
                                      _profile?.profilePic == null
                                          ? Icon(
                                            Icons.person,
                                            size: 60 * scale,
                                            color: Colors.grey.shade700,
                                          )
                                          : null,
                                ),
                      ),
                      Positioned(
                        bottom: -4 * scale,
                        right: -4 * scale,
                        child: GestureDetector(
                          onTap: _pickProfileImage,
                          child: CircleAvatar(
                            radius: 26 * scale,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              size: 30 * scale,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20 * scale),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16 * scale, // 좌우 여백
                      vertical: 8 * scale, // 상하 여백
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // 배경색
                      border: Border.all(
                        color: Colors.grey.shade400, // 테두리 색
                        width: 1 * scale, // 테두리 두께
                      ),
                      borderRadius: BorderRadius.circular(8 * scale), // 둥근 모서리
                    ),
                    child: Text(
                      _profile != null
                          ? _profile!.nickname
                          : (_loadingProfile
                              ? appLocalizations.loading
                              : appLocalizations.guest),
                      style: TextStyle(
                        fontSize: 18 * scale,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 20 * scale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16 * scale, // 좌우 여백
                          vertical: 8 * scale, // 상하 여백
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white, // 배경색
                          border: Border.all(
                            color: Colors.grey.shade400, // 테두리 색
                            width: 1 * scale, // 테두리 두께
                          ),
                          borderRadius: BorderRadius.circular(
                            8 * scale,
                          ), // 둥근 모서리
                        ),
                        child: Text(
                          _profile != null
                              ? _profile!.birthdate.toString().split(' ')[0]
                              : (_loadingProfile
                                  ? appLocalizations.loading
                                  : appLocalizations.ageIsJustANumber),
                          style: TextStyle(
                            fontSize: 18 * scale,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(width: 16 * scale),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16 * scale, // 좌우 여백
                          vertical: 8 * scale, // 상하 여백
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white, // 배경색
                          border: Border.all(
                            color: Colors.grey.shade400, // 테두리 색
                            width: 1 * scale, // 테두리 두께
                          ),
                          borderRadius: BorderRadius.circular(
                            8 * scale,
                          ), // 둥근 모서리
                        ),
                        child: Text(
                          _profile != null
                              ? _getUserTypeName(
                                _profile!.userType,
                                appLocalizations,
                              )
                              : (_loadingProfile
                                  ? appLocalizations.loading
                                  : appLocalizations.unknownUserType),
                          style: TextStyle(
                            fontSize: 18 * scale,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20 * scale),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _handleLogout,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12 * scale),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(45 * scale),
                            ),
                            child: Center(
                              child: Text(
                                appLocalizations.logout,
                                style: TextStyle(
                                  fontSize: 16 * scale,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16 * scale),
                      Expanded(
                        child: GestureDetector(
                          onTap: _loadingProfile ? null : _showEditProfileDialog,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12 * scale),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(45 * scale),
                            ),
                            child: Center(
                              child: _loadingProfile
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                  : Text(
                                    appLocalizations.editProfile,
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 16 * scale,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40 * scale),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12 * scale),
                    child: Column(
                      children: [
                        // 1) 토글 Row
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       '일일 학습 알림',
                        //       style: TextStyle(
                        //         fontSize: 20 * scale,
                        //         fontWeight: FontWeight.w500,
                        //         color: Colors.black87,
                        //       ),
                        //     ),
                        //     Switch(
                        //       value: isDailyAlarmOn,
                        //       onChanged:
                        //           (v) => setState(() => isDailyAlarmOn = v),
                        //       activeColor: Colors.green,
                        //       activeTrackColor: Colors.grey.shade300,
                        //       inactiveThumbColor: Colors.grey.shade700,
                        //       inactiveTrackColor: Colors.grey.shade300,
                        //     ),
                        //   ],
                        // ),
                        // Divider(), // 토글 아래 구분선
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       '다크 모드',
                        //       style: TextStyle(
                        //         fontSize: 20 * scale,
                        //         fontWeight: FontWeight.w500,
                        //         color: Colors.black87,
                        //       ),
                        //     ),
                        //     Switch(
                        //       value: isDailyAlarmOn,
                        //       onChanged:
                        //           (v) => setState(() => isDailyAlarmOn = v),
                        //       activeColor: Colors.green,
                        //       activeTrackColor: Colors.grey.shade300,
                        //       inactiveThumbColor: Colors.grey.shade700,
                        //       inactiveTrackColor: Colors.grey.shade300,
                        //     ),
                        //   ],
                        // ),

                        // Divider(), // 토글 아래 구분선
                        // SizedBox(height: 40 * scale),
                        PracticeCard(
                          title: appLocalizations.characterIntroductionTitle,
                          subtitle:
                              appLocalizations.characterIntroductionSubtitle,
                          imagePath: '',
                          onTap: () {
                            // 곰곰 카드 탭 로직
                          },
                        ),
                        SizedBox(height: 20 * scale),
                        PracticeCard(
                          title: appLocalizations.gomgomTitle,
                          subtitle: appLocalizations.gomgomSubtitle,
                          imagePath: 'assets/character/bearTeacher.png',
                          onTap: () {
                            // 해당 페이지로 이동하는 로직
                          },
                        ),
                        SizedBox(height: 20 * scale),
                        PracticeCard(
                          title: appLocalizations.totoTitle,
                          subtitle: appLocalizations.totoSubtitle,
                          imagePath: 'assets/character/rabbitTeacher.png',
                          onTap: () {},
                        ),
                        SizedBox(height: 20 * scale),
                        PracticeCard(
                          title: appLocalizations.daramTitle,
                          subtitle: appLocalizations.daramSubtitle,
                          imagePath: 'assets/character/hamster.png',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 80 * scale),
                ],
              ),

              // 하단 버튼 영역을 위해 여백
            ),
          ],
        ),
      ),
    );
  }

  // 가로 화면(태블릿/landscape 용)
  Widget _buildLandscape(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    // reuse portrait scaling logic
    final double basePortrait = 390.0;
    final double baseLandscape = 844.0;
    final bool isLandscape = screenSize.width > screenSize.height;
    final double scale =
        isLandscape
            ? screenSize.height / baseLandscape
            : screenSize.width / basePortrait;
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: screenSize.width,
                  height: 180 * scale,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/mypage2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 80 * scale,
                  left: 50 * scale,
                  child: Text(
                    appLocalizations.myPageTitle,
                    style: TextStyle(
                      fontSize: 33 * scale,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16 * scale),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16 * scale,
                vertical: 8 * scale,
              ),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        child:
                            _loadingProfile
                                ? CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  radius: 70 * scale,
                                  child: CircularProgressIndicator(),
                                )
                                : CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  radius: 70 * scale,
                                  backgroundImage:
                                      _profile?.profilePic != null
                                          ? CachedNetworkImageProvider(
                                            _profile!.profilePic!,
                                          )
                                          : null,
                                  child:
                                      _profile?.profilePic == null
                                          ? Icon(
                                            Icons.person,
                                            size: 60 * scale,
                                            color: Colors.grey.shade700,
                                          )
                                          : null,
                                ),
                      ),
                      Positioned(
                        bottom: -4 * scale,
                        right: -4 * scale,
                        child: GestureDetector(
                          onTap: _pickProfileImage,
                          child: CircleAvatar(
                            radius: 26 * scale,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              size: 30 * scale,

                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20 * scale),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 35 * scale, // 좌우 여백
                      vertical: 10 * scale, // 상하 여백
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // 배경색
                      border: Border.all(
                        color: Colors.grey.shade400, // 테두리 색
                        width: 1 * scale, // 테두리 두께
                      ),
                      borderRadius: BorderRadius.circular(8 * scale), // 둥근 모서리
                    ),
                    child: Text(
                      _profile != null
                          ? _profile!.nickname
                          : (_loadingProfile
                              ? appLocalizations.loading
                              : appLocalizations.guest),
                      style: TextStyle(
                        fontSize: 18 * scale,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20 * scale),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * scale, // 좌우 여백
                    vertical: 8 * scale, // 상하 여백
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white, // 배경색
                    border: Border.all(
                      color: Colors.grey.shade400, // 테두리 색
                      width: 1 * scale, // 테두리 두께
                    ),
                    borderRadius: BorderRadius.circular(8 * scale), // 둥근 모서리
                  ),
                  child: Text(
                    _profile != null
                        ? _profile!.birthdate.toString().split(' ')[0]
                        : (_loadingProfile
                            ? appLocalizations.loading
                            : appLocalizations.ageIsJustANumber),
                    style: TextStyle(
                      fontSize: 18 * scale,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(width: 40 * scale),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * scale, // 좌우 여백
                    vertical: 8 * scale, // 상하 여백
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white, // 배경색
                    border: Border.all(
                      color: Colors.grey.shade400, // 테두리 색
                      width: 1 * scale, // 테두리 두께
                    ),
                    borderRadius: BorderRadius.circular(8 * scale), // 둥근 모서리
                  ),
                  child: Text(
                    _profile != null
                        ? _getUserTypeName(_profile!.userType, appLocalizations)
                        : (_loadingProfile
                            ? appLocalizations.loading
                            : appLocalizations.unknownUserType),
                    style: TextStyle(
                      fontSize: 18 * scale,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20 * scale),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── 로그아웃 버튼 ──
                GestureDetector(
                  onTap: _handleLogout,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12 * scale,
                      horizontal: 35 * scale,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(45 * scale),
                    ),
                    child: Center(
                      child: Text(
                        appLocalizations.logout,
                        style: TextStyle(
                          fontSize: 16 * scale,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 100 * scale),

                // ── 회원정보수정 버튼 ──
                GestureDetector(
                  onTap: _loadingProfile ? null : _showEditProfileDialog,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12 * scale,
                      horizontal: 35 * scale,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(45 * scale),
                    ),
                    child: Center(
                      child: _loadingProfile
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text(
                            appLocalizations.editProfile,
                            style: TextStyle(
                              fontSize: 16 * scale,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueAccent, // 수정은 정보 표시 색상
                            ),
                          ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40 * scale),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 200 * scale),
              child: Column(
                children: [
                  // 1) 토글 Row
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       '일일 학습 알림',
                  //       style: TextStyle(
                  //         fontSize: 20 * scale,
                  //         fontWeight: FontWeight.w500,
                  //         color: Colors.black87,
                  //       ),
                  //     ),
                  //     Switch(
                  //       value: isDailyAlarmOn,
                  //       onChanged: (v) => setState(() => isDailyAlarmOn = v),
                  //       activeColor: Colors.green,
                  //       activeTrackColor: Colors.grey.shade300,
                  //       inactiveThumbColor: Colors.grey.shade700,
                  //       inactiveTrackColor: Colors.grey.shade300,
                  //     ),
                  //   ],
                  // ),
                  // Divider(),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       '다크 모드',
                  //       style: TextStyle(
                  //         fontSize: 20 * scale,
                  //         fontWeight: FontWeight.w500,
                  //         color: Colors.black87,
                  //       ),
                  //     ),
                  //     Switch(
                  //       value: isDailyAlarmOn,
                  //       onChanged: (v) => setState(() => isDailyAlarmOn = v),
                  //       activeColor: Colors.green,
                  //       activeTrackColor: Colors.grey.shade300,
                  //       inactiveThumbColor: Colors.grey.shade700,
                  //       inactiveTrackColor: Colors.grey.shade300,
                  //     ),
                  //   ],
                  // ),
                  // Divider(),
                  //SizedBox(height: 40 * scale),
                  PracticeCard(
                    title: appLocalizations.characterIntroductionTitle,
                    subtitle: appLocalizations.characterIntroductionSubtitle,
                    imagePath: '',
                    onTap: () {
                      // 곰곰 카드 탭 로직
                    },
                  ),

                  SizedBox(height: 10 * scale),
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true, // 부모 ScrollView 안에서 높이를 콘텐츠에 맞춤
              physics: const NeverScrollableScrollPhysics(), // 그리드 자체 스크롤 해제
              crossAxisCount: 2, // 2열 배치
              crossAxisSpacing: 16 * scale, // 카드 간 가로 간격
              mainAxisSpacing: 16 * scale, // 카드 간 세로 간격
              childAspectRatio: 3, // 카드 가로:세로 비율 (필요시 조정)
              children: [
                PracticeCard(
                  title: appLocalizations.gomgomTitle,
                  subtitle: appLocalizations.gomgomSubtitle,
                  imagePath: 'assets/character/bearTeacher.png',
                  onTap: () {
                    // 곰곰 카드 탭 로직
                  },
                ),
                PracticeCard(
                  title: appLocalizations.totoTitle,
                  subtitle: appLocalizations.totoSubtitle,
                  imagePath: 'assets/character/rabbitTeacher.png',
                  onTap: () {
                    // 토토 카드 탭 로직
                  },
                ),
                PracticeCard(
                  title: appLocalizations.daramTitle,
                  subtitle: appLocalizations.daramSubtitle,
                  imagePath: 'assets/character/hamster.png',
                  onTap: () {
                    // 다람 카드 탭 로직
                  },
                ),
              ],
            ), // 토글 아래 구분선
          ],
        ),
      ),
    );
  }
}
