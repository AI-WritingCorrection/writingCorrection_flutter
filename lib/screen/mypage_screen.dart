import 'package:aiwriting_collection/widget/practice_card.dart';
import 'package:aiwriting_collection/model/login_status.dart';
import 'package:provider/provider.dart';
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
  bool isDailyAlarmOn = false; // 알람 토글

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
      backgroundColor: Theme.of(context).primaryColor,
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
                              fontSize: 24 * scale,
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
                          image: AssetImage('assets/bearTeacher.png'),
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
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        radius: 70 * scale,
                        child: Icon(
                          Icons.person,
                          size: 60 * scale,
                          color: Colors.grey.shade700,
                        ),
                      ),
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
                      '게스트', // 사용자 이름 또는 '게스트'
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
                            ).setLoggedIn(false);
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
                    child: Row(
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
                          onChanged: (bool value) {
                            setState(() {
                              isDailyAlarmOn = value;
                            });
                          },
                          // 켜졌을 때 thumb(동그라미) 색
                          activeColor: Colors.green,
                          // 켜졌을 때 track(바탕) 색
                          activeTrackColor: Colors.grey.shade300,
                          // 꺼졌을 때 thumb 색
                          inactiveThumbColor: Colors.grey.shade700,
                          // 꺼졌을 때 track 색
                          inactiveTrackColor: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
                  Divider(), // 토글 아래 구분선
                  SizedBox(height: 40 * scale),
                  PracticeCard(
                    title: '곰곰',
                    subtitle:
                        '곰곰이는 부드러운 솜결 같은 한 획 한 획을 좋아해요. 함께라면 글씨가 포근한 마음을 담아 전달될 거예요!',
                    imagePath: 'assets/bearTeacher.png',
                    onTap: () {
                      // 해당 페이지로 이동하는 로직
                    },
                  ),
                  SizedBox(height: 20 * scale),
                  PracticeCard(
                    title: '토토',
                    subtitle:
                        '토토는 껑충껑충 경쾌한 리듬으로 글씨 연습을 즐겨요. 지루할 틈 없이 신나게 따라와 보세요!',
                    imagePath: 'assets/rabbitTeacher.png',
                    onTap: () {},
                  ),
                  SizedBox(height: 20 * scale),
                  PracticeCard(
                    title: '다람',
                    subtitle:
                        '다람이는 작은 손으로 도토리를 모으듯 꼼꼼하게 글씨를 완성시켜 준답니다. 섬세한 한 획까지 믿고 맡겨 보세요!',
                    imagePath: 'assets/hamster.png',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 80 * scale), // 하단 버튼 영역을 위해 여백
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
      backgroundColor: const Color(0xFFFFFBF3),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 상단 영역 (동일하게 재사용)
            Stack(
              children: [
                Container(
                  width: screenSize.width,
                  height: 180 * scale,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/letter.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 80 * scale,
                  left: 50 * scale,
                  child: Text(
                    '손글씨 연습',
                    style: TextStyle(
                      fontSize: 30 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            // 설명 텍스트
            Padding(
              padding: EdgeInsets.fromLTRB(
                20 * scale,
                40 * scale,
                20 * scale,
                8 * scale,
              ),
              child: Text(
                '자음, 모음, 받침, 문장들을 올바르게 쓰는 연습법을 차근차근 알려드립니다.',
                style: TextStyle(
                  fontSize: 20 * scale,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // 2열 Grid of cards
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16 * scale,
                vertical: 8 * scale,
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16 * scale,
                mainAxisSpacing: 16 * scale,
                childAspectRatio: 3, // width:height 비율 조정
                children: [
                  PracticeCard(
                    title: '손글씨 자세',
                    subtitle: '손글씨를 잘 쓰기 위한 기본 자세와 도구',
                    imagePath: 'assets/bearTeacher.png',
                    onTap: () {},
                  ),
                  PracticeCard(
                    title: '자음과 모음 쓰기',
                    subtitle: '자음, 모음 등 기본 글자를 바르게 쓰는 연습',
                    imagePath: 'assets/rabbitTeacher.png',
                    onTap: () {},
                  ),
                  PracticeCard(
                    title: '받침 있는 글자 쓰기',
                    subtitle: '쌍자음, 겹받침 등 복잡한 글자 연습',
                    imagePath: 'assets/hamster.png',
                    onTap: () {},
                  ),
                  PracticeCard(
                    title: '문장 쓰기',
                    subtitle: '문장 단위로 또박또박 쓰는 연습',
                    imagePath: 'assets/bearTeacher.png',
                    onTap: () {},
                  ),
                  PracticeCard(
                    title: '캘리그라피 연습',
                    subtitle: '캘리그라피 연습을 통해 글씨체를 살려봐요',
                    imagePath: 'assets/bearTeacher.png',
                    onTap: () {},
                  ),
                  PracticeCard(
                    title: '무한 글씨 연습',
                    subtitle: '원하는 만큼 원고지에 글씨를 적어보세요',
                    imagePath: 'assets/bearTeacher.png',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 80 * scale),
          ],
        ),
      ),
    );
  }
}
