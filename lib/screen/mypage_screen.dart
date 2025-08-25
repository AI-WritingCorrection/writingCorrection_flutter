import 'package:aiwriting_collection/api.dart';
import 'package:aiwriting_collection/model/user_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:aiwriting_collection/model/login_status.dart';
import 'package:aiwriting_collection/main.dart';
import 'package:aiwriting_collection/widget/practice_card.dart';
import 'package:flutter/material.dart';

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0) // 상단 우측
      ..lineTo(size.width * 0.8, size.height) // 우측 바닥에서 20% 지점
      ..lineTo(0, size.height) // 바닥 좌측
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  bool isDailyAlarmOn = false;
  final api = Api(); // 알람 토글
  UserProfile? _profile;
  bool _loadingProfile = true;

  // 로그인 상태 변경에 반응해 프로필을 재로딩하기 위한 상태
  int _lastLoadedUserId = 0;
  late final LoginStatus _loginStatus;

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickProfileImage() async {
    final XFile? picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (picked != null) {
      final uid = _lastLoadedUserId;
      final updatedPicUrl = await api.uploadProfileImage(picked.path, uid);
      if (!mounted) return;
      setState(() {
        _loadingProfile = true; // 로딩 표시만 하고, 실제 데이터는 서버에서 재로딩
      });
      await _loadUserProfile(force: true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필 이미지가 업데이트되었습니다.')),
      );
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

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 180 * scale,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: ClipPath(
                      clipper: DiagonalClipper(),
                      child: Container(
                        color: Theme.of(context).colorScheme.secondary,
                        child: Center(
                          child: Text(
                            '마이 페이지',
                            style: TextStyle(
                              fontSize: 25 * scale,
                              fontFamily: 'MaruBuri',
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        image: DecorationImage(
                          image: AssetImage('assets/character/bearTeacher.png'),
                          fit: BoxFit.cover,
                          alignment: Alignment(0, -2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                      GestureDetector(onTap: _pickProfileImage, child: _loadingProfile
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
                                    ? NetworkImage(_profile!.profilePic!)
                                    : null,
                            child:
                                _profile?.profilePic == null
                                    ? Icon(
                                      Icons.person,
                                      size: 60 * scale,
                                      color: Colors.grey.shade700,
                                    )
                                    : null,
                          ),),
                      
                      Positioned(
                        bottom: -4 * scale,
                        right: -4 * scale,
                        child: CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            size: 30 * scale,
                            color: Colors.black54,
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
                          : (_loadingProfile ? '불러오는 중...' : '게스트'),
                      style: TextStyle(
                        fontSize: 18 * scale,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 40 * scale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── 로그아웃 버튼 ──
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // 로그인 상태를 false 로 변경하면 main.dart 에서 자동으로 LoginScreen 으로 돌아갑니다.
                            Provider.of<LoginStatus>(
                              context,
                              listen: false,
                            ).logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyApp(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12 * scale),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(45 * scale),
                            ),
                            child: Center(
                              child: Text(
                                '로그아웃',
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

                      // ── 회원탈퇴 버튼 ──
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // TODO: 회원탈퇴 다이얼로그 및 로직 구현
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12 * scale),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(45 * scale),
                            ),
                            child: Center(
                              child: Text(
                                '회원탈퇴',
                                style: TextStyle(
                                  fontSize: 16 * scale,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.redAccent, // 탈퇴는 위험 표시 색상
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
                    padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                    child: Column(
                      children: [
                        // 1) 토글 Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '일일 학습 알림',
                              style: TextStyle(
                                fontSize: 20 * scale,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            Switch(
                              value: isDailyAlarmOn,
                              onChanged:
                                  (v) => setState(() => isDailyAlarmOn = v),
                              activeColor: Colors.green,
                              activeTrackColor: Colors.grey.shade300,
                              inactiveThumbColor: Colors.grey.shade700,
                              inactiveTrackColor: Colors.grey.shade300,
                            ),
                          ],
                        ),
                        Divider(), // 토글 아래 구분선
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '다크 모드',
                              style: TextStyle(
                                fontSize: 20 * scale,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            Switch(
                              value: isDailyAlarmOn,
                              onChanged:
                                  (v) => setState(() => isDailyAlarmOn = v),
                              activeColor: Colors.green,
                              activeTrackColor: Colors.grey.shade300,
                              inactiveThumbColor: Colors.grey.shade700,
                              inactiveTrackColor: Colors.grey.shade300,
                            ),
                          ],
                        ),

                        Divider(), // 토글 아래 구분선
                        SizedBox(height: 40 * scale),
                        PracticeCard(
                          title: '캐릭터 소개',
                          subtitle: '손글씨 연습을 도와줄 귀여운 동물 친구들을 소개할게요.',
                          imagePath: 'assets/character/bearTeacher.png',
                          onTap: () {
                            // 곰곰 카드 탭 로직
                          },
                        ),
                        SizedBox(height: 20 * scale),
                        PracticeCard(
                          title: '곰곰',
                          subtitle:
                              '곰곰이는 부드러운 솜결 같은 한 획 한 획을 좋아해요. 함께라면 글씨가 포근한 마음을 담아 전달될 거예요!',
                          imagePath: 'assets/character/bearTeacher.png',
                          onTap: () {
                            // 해당 페이지로 이동하는 로직
                          },
                        ),
                        SizedBox(height: 20 * scale),
                        PracticeCard(
                          title: '토토',
                          subtitle:
                              '토토는 껑충껑충 경쾌한 리듬으로 글씨 연습을 즐겨요. 지루할 틈 없이 신나게 따라와 보세요!',
                          imagePath: 'assets/character/rabbitTeacher.png',
                          onTap: () {},
                        ),
                        SizedBox(height: 20 * scale),
                        PracticeCard(
                          title: '다람',
                          subtitle:
                              '다람이는 작은 손으로 도토리를 모으듯 꼼꼼하게 글씨를 완성시켜 준답니다. 섬세한 한 획까지 믿고 맡겨 보세요!',
                          imagePath: 'assets/character/hamster.png',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 80 * scale),
                ],
              ),
            ),
            // 하단 버튼 영역을 위해 여백
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

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 180 * scale,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: ClipPath(
                      clipper: DiagonalClipper(),
                      child: Container(
                        color: Theme.of(context).colorScheme.secondary,
                        child: Center(
                          child: Text(
                            '마이 페이지',
                            style: TextStyle(
                              fontFamily: 'MaruBuri',
                              fontSize: 33 * scale,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        image: DecorationImage(
                          image: AssetImage('assets/character/bearTeacher.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                        onTap: _pickProfileImage,
                        child:_loadingProfile
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
                                    ? NetworkImage(_profile!.profilePic!)
                                    : null,
                            child:
                                _profile?.profilePic == null
                                    ? Icon(
                                      Icons.person,
                                      size: 60 * scale,
                                      color: Colors.grey.shade700,
                                    )
                                    : null,
                          ),),
                      
                      Positioned(
                        bottom: -4 * scale,
                        right: -4 * scale,
                        child: CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            size: 30 * scale,
                            color: Colors.black54,
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
                          : (_loadingProfile ? '불러오는 중...' : '게스트'),
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
            SizedBox(height: 40 * scale),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── 로그아웃 버튼 ──
                GestureDetector(
                  onTap: () async {
                    // 로그인 상태를 false 로 변경하면 main.dart 에서 자동으로 LoginScreen 으로 돌아갑니다.
                    await api.logout();
                    Provider.of<LoginStatus>(context, listen: false).logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                      (route) => false,
                    );
                  },
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
                        '로그아웃',
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

                // ── 회원탈퇴 버튼 ──
                GestureDetector(
                  onTap: () {
                    // TODO: 회원탈퇴 다이얼로그 및 로직 구현
                  },
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
                        '회원탈퇴',
                        style: TextStyle(
                          fontSize: 16 * scale,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent, // 탈퇴는 위험 표시 색상
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '일일 학습 알림',
                        style: TextStyle(
                          fontSize: 20 * scale,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Switch(
                        value: isDailyAlarmOn,
                        onChanged: (v) => setState(() => isDailyAlarmOn = v),
                        activeColor: Colors.green,
                        activeTrackColor: Colors.grey.shade300,
                        inactiveThumbColor: Colors.grey.shade700,
                        inactiveTrackColor: Colors.grey.shade300,
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '다크 모드',
                        style: TextStyle(
                          fontSize: 20 * scale,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Switch(
                        value: isDailyAlarmOn,
                        onChanged: (v) => setState(() => isDailyAlarmOn = v),
                        activeColor: Colors.green,
                        activeTrackColor: Colors.grey.shade300,
                        inactiveThumbColor: Colors.grey.shade700,
                        inactiveTrackColor: Colors.grey.shade300,
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 40 * scale),
                  PracticeCard(
                    title: '캐릭터 소개',
                    subtitle: '손글씨 연습을 도와줄 귀여운 동물 친구들을 소개할게요.',
                    imagePath: 'assets/character/bearTeacher.png',
                    onTap: () {
                      // 곰곰 카드 탭 로직
                    },
                  ),

                  SizedBox(height: 40 * scale),
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
                  title: '곰곰',
                  subtitle: '곰곰이는 부드러운 솜결 같은 한 획 한 획을 좋아해요.',
                  imagePath: 'assets/character/bearTeacher.png',
                  onTap: () {
                    // 곰곰 카드 탭 로직
                  },
                ),
                PracticeCard(
                  title: '토토',
                  subtitle: '토토는 껑충껑충 경쾌한 리듬으로 글씨 연습을 즐겨요.',
                  imagePath: 'assets/character/rabbitTeacher.png',
                  onTap: () {
                    // 토토 카드 탭 로직
                  },
                ),
                PracticeCard(
                  title: '다람',
                  subtitle: '다람이는 작은 손으로 꼼꼼하게 글씨를 완성시켜 준답니다.',
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
