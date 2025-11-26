import 'package:aiwriting_collection/screen/free_study/basic_handwriting_screen.dart';
import 'package:aiwriting_collection/screen/free_study/letter_writing_screen.dart';
import 'package:aiwriting_collection/screen/free_study/sentence_writing_screen.dart';
import 'package:aiwriting_collection/screen/free_study/word_writing_screen.dart';
import 'package:aiwriting_collection/widget/dialog/mini_dialog.dart';
import 'package:aiwriting_collection/widget/practice_card.dart';
import 'package:flutter/material.dart';
import 'package:aiwriting_collection/generated/app_localizations.dart';

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
    final appLocalizations = AppLocalizations.of(context)!;

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
                        appLocalizations.studyTitle,
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
            // 손글씨 연습 설명
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20 * scale,
                vertical: 16 * scale,
              ),
              child: Text(
                appLocalizations.studyDescription,
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
              title: appLocalizations.handwritingPostureTitle,
              subtitle: appLocalizations.handwritingPostureSubtitle,
              imagePath: 'assets/character/bearTeacher.png',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const BasicHandwritingScreen(),
                  ),
                );
              },
            ),
            PracticeCard(
              title: appLocalizations.consonantsAndVowelsTitle,
              subtitle: appLocalizations.consonantsAndVowelsSubtitle,
              imagePath: 'assets/character/rabbitTeacher.png',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MiniDialog(
                      scale: scale,
                      title: appLocalizations.dialogTitleTooSmall,
                      content: appLocalizations.dialogContentTabletOnly,
                    );
                  },
                );
              },
            ),
            PracticeCard(
              title: appLocalizations.wordWritingTitle,
              subtitle: appLocalizations.wordWritingSubtitle,
              imagePath: 'assets/character/hamster.png',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MiniDialog(
                      scale: scale,
                      title: appLocalizations.dialogTitleTooSmall,
                      content: appLocalizations.dialogContentTabletOnly,
                    );
                  },
                );
              },
            ),
            PracticeCard(
              title: appLocalizations.sentenceWritingTitle,
              subtitle: appLocalizations.sentenceWritingSubtitle,
              imagePath: 'assets/character/bearTeacher.png',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MiniDialog(
                      scale: scale,
                      title: appLocalizations.dialogTitleTooSmall,
                      content: appLocalizations.dialogContentTabletOnly,
                    );
                  },
                );
              },
            ),
            PracticeCard(
              title: appLocalizations.calligraphyPracticeTitle,
              subtitle: appLocalizations.calligraphyPracticeSubtitle,
              imagePath: 'assets/character/rabbitTeacher.png',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MiniDialog(
                      scale: scale,
                      title: appLocalizations.dialogTitleTooSmall,
                      content: appLocalizations.dialogContentTabletOnly,
                    );
                  },
                );
              },
            ),
            PracticeCard(
              title: appLocalizations.infiniteWritingPracticeTitle,
              subtitle: appLocalizations.infiniteWritingPracticeSubtitle,
              imagePath: 'assets/character/hamster.png',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MiniDialog(
                      scale: scale,
                      title: appLocalizations.dialogTitleTooSmall,
                      content: appLocalizations.dialogContentTabletOnly,
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
    final appLocalizations = AppLocalizations.of(context)!;

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
                    appLocalizations.studyTitle,
                    style: TextStyle(
                      fontSize: 33 * scale,
                      // fontFamily: 'MaruBuri',
                      // fontWeight: FontWeight.bold,
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
                appLocalizations.studyDescription,
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
                    title: appLocalizations.handwritingBasicsTitle,
                    subtitle: appLocalizations.handwritingBasicsSubtitle,
                    imagePath: 'assets/character/bearTeacher.png',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const BasicHandwritingScreen(),
                        ),
                      );
                    },
                  ),
                  PracticeCard(
                    title: appLocalizations.consonantsAndVowelsTitle,
                    subtitle: appLocalizations.consonantsAndVowelsSubtitle,
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
                    title: appLocalizations.wordWritingTitle,
                    subtitle: appLocalizations.wordWritingSubtitle,
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
                    title: appLocalizations.sentenceWritingTitle,
                    subtitle: appLocalizations.sentenceWritingSubtitle,
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
                    title: appLocalizations.calligraphyPracticeTitle,
                    subtitle: appLocalizations.calligraphyPracticeSubtitle,
                    imagePath: 'assets/character/rabbitTeacher.png',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MiniDialog(
                            scale: scale * 1.5,
                            title: appLocalizations.dialogTitleInProgress,
                            content: appLocalizations.dialogContentInProgress,
                          );
                        },
                      );
                    },
                  ),
                  PracticeCard(
                    title: appLocalizations.infiniteWritingPracticeTitle,
                    subtitle: appLocalizations.infiniteWritingPracticeSubtitle,
                    imagePath: 'assets/character/hamster.png',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MiniDialog(
                            scale: scale * 1.5,
                            title: appLocalizations.dialogTitleInProgress,
                            content: appLocalizations.dialogContentInProgress,
                          );
                        },
                      );
                    },
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
