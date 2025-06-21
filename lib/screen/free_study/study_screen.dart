import 'package:aiwriting_collection/screen/free_study/letter_writing_screen.dart';
import 'package:aiwriting_collection/screen/free_study/sentence_writing_screen.dart';
import 'package:aiwriting_collection/screen/free_study/word_writing_screen.dart';
import 'package:aiwriting_collection/widget/mini_dialog.dart';
import 'package:aiwriting_collection/widget/practice_card.dart';
import 'package:flutter/material.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

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
            // 상단 영역 (배경 + '손글씨 연습' 텍스트 + 오른쪽 이미지)
            Stack(
              children: [
                // 상단 배경 이미지 (예: 노트 배경 등)
                Container(
                  width: screenSize.width,
                  height: 180 * scale, // 상단 높이를 적절히 조정
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/letter.png'),
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
                        '손글씨 연습',
                        style: TextStyle(
                          fontSize: 23 * scale,
                          fontFamily: 'MaruBuri',
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 8 * scale),
                    ],
                  ),
                ),
              ],
            ),
            // 손글씨 연습 설명
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20 * scale,
                vertical: 16 * scale,
              ),
              child: Text(
                '자음, 모음, 받침, 문장들을 올바르게 쓰는 연습법을\n차근차근 알려드립니다.',
                style: TextStyle(
                  fontSize: 15 * scale,
                  color: Colors.black87,
                  fontFamily: 'MaruBuri',
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            // 기능 목록 (카드 형태)
            PracticeCard(
              title: '손글씨 자세',
              subtitle: '손글씨를 잘 쓰기 위한 기본 자세와 도구',
              imagePath: 'assets/character/bearTeacher.png',
              onTap: () {
                // 해당 페이지로 이동하는 로직
              },
            ),
            PracticeCard(
              title: '자음과 모음 쓰기',
              subtitle: '자음, 모음 등 기본 글자를 바르게 쓰는 연습',
              imagePath: 'assets/character/rabbitTeacher.png',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MiniDialog(
                      scale: scale,
                      title: '너무 작아!',
                      content: '공부는 태블릿에서만 가능합니다!',
                    );
                  },
                );
              },
            ),
            PracticeCard(
              title: '단어 쓰기',
              subtitle: '쌍자음, 겹받침 등 조금 더 복잡한 글자 연습',
              imagePath: 'assets/character/hamster.png',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MiniDialog(
                      scale: scale,
                      title: '너무 작아!',
                      content: '공부는 태블릿에서만 가능합니다!',
                    );
                  },
                );
              },
            ),
            PracticeCard(
              title: '문장 쓰기',
              subtitle: '문장 단위로 글씨를 또박또박 쓰는 연습',
              imagePath: 'assets/character/bearTeacher.png',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MiniDialog(
                      scale: scale,
                      title: '너무 작아!',
                      content: '공부는 태블릿에서만 가능합니다!',
                    );
                  },
                );
              },
            ),
            PracticeCard(
              title: '캘리그라피 연습',
              subtitle: '간단한 캘리그라피 연습을 통해 글씨체를 살려봐요',
              imagePath: 'assets/character/bearTeacher.png',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MiniDialog(
                      scale: scale,
                      title: '너무 작아!',
                      content: '공부는 태블릿에서만 가능합니다!',
                    );
                  },
                );
              },
            ),
            PracticeCard(
              title: '무한 글씨 연습',
              subtitle: '원하는 만큼 원고지에 글씨를 적어보세요',
              imagePath: 'assets/character/bearTeacher.png',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MiniDialog(
                      scale: scale,
                      title: '너무 작아!',
                      content: '공부는 태블릿에서만 가능합니다!',
                    );
                  },
                );
              },
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
                      image: AssetImage('assets/image/letter.png'),
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
                      fontSize: 33 * scale,
                      fontFamily: 'MaruBuri',
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
                  fontSize: 23 * scale,
                  color: Colors.black87,
                  fontFamily: 'MaruBuri',
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
                    imagePath: 'assets/character/bearTeacher.png',
                    onTap: () {},
                  ),
                  PracticeCard(
                    title: '자음과 모음 쓰기',
                    subtitle: '자음, 모음 등 기본 글자를 바르게 쓰는 연습',
                    imagePath: 'assets/character/rabbitTeacher.png',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LetterWritingScreen(),
                        ),
                      );
                    },
                  ),
                  PracticeCard(
                    title: '단어 쓰기',
                    subtitle: '쌍자음, 겹받침 등 복잡한 글자 연습',
                    imagePath: 'assets/character/hamster.png',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const WordWritingScreen(),
                        ),
                      );
                    },
                  ),
                  PracticeCard(
                    title: '문장 쓰기',
                    subtitle: '문장 단위로 또박또박 쓰는 연습',
                    imagePath: 'assets/character/bearTeacher.png',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SentenceWritingScreen(),
                        ),
                      );
                    },
                  ),
                  PracticeCard(
                    title: '캘리그라피 연습',
                    subtitle: '캘리그라피 연습을 통해 글씨체를 살려봐요',
                    imagePath: 'assets/character/bearTeacher.png',
                    onTap: () {},
                  ),
                  PracticeCard(
                    title: '무한 글씨 연습',
                    subtitle: '원하는 만큼 원고지에 글씨를 적어보세요',
                    imagePath: 'assets/character/bearTeacher.png',
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
