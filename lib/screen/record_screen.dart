import 'package:aiwriting_collection/widget/practice_card.dart';
import 'package:aiwriting_collection/widget/waitdevelop_dialog.dart';
import 'package:flutter/material.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

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
      backgroundColor: const Color(0xFFFFFBF3),
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
                      image: AssetImage('assets/image/calendar.png'),
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
                        '나의 기록',
                        style: TextStyle(
                          fontSize: 22 * scale,
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
                '나의 연습 기록들을 다양한 방법으로 확인해보세요!',
                style: TextStyle(
                  fontSize: 15 * scale,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            // 기능 목록 (카드 형태)
            PracticeCard(
              title: '글씨 점수 통계',
              subtitle: '내가 연습한 글씨 점수를 통계로 확인해볼까요?',
              imagePath: 'assets/image/graph.png',
              onTap: () {
                // 해당 페이지로 이동하는 로직
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return WaitdevelopDialog(scale: scale);
                  },
                );
              },
            ),
            PracticeCard(
              title: '나만의 글씨 달력',
              subtitle: '하루하루마다 연습한 글씨를 달력으로 확인해보세요',
              imagePath: 'assets/image/dailyCalendar.png',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return WaitdevelopDialog(scale: scale);
                  },
                );
              },
            ),
            PracticeCard(
              title: '글씨 포토카트 만들기',
              subtitle: '오늘을 기념하는 사진과 함께 문장 하나를 남겨보세요',
              imagePath: 'assets/image/photocard.png',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return WaitdevelopDialog(scale: scale);
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
                      image: AssetImage('assets/image/calendar.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 80 * scale,
                  left: 50 * scale,
                  child: Text(
                    '나의 기록',
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
                '나의 연습 기록들을 다양한 방법으로 확인해보세요!',
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
                    title: '글씨 점수 통계',
                    subtitle: '내가 연습한 글씨 점수를 통계로 확인해볼까요?',
                    imagePath: 'assets/image/graph.png',
                    onTap: () {
                      // 개발진행중이라는 다이얼로그
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return WaitdevelopDialog(scale: scale);
                        },
                      );
                    },
                  ),
                  PracticeCard(
                    title: '나만의 글씨 달력',
                    subtitle: '하루하루마다 연습한 글씨를 달력으로 확인해보세요',
                    imagePath: 'assets/image/dailyCalendar.png',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return WaitdevelopDialog(scale: scale);
                        },
                      );
                    },
                  ),
                  PracticeCard(
                    title: '글씨 포토카트 만들기',
                    subtitle: '오늘을 기념하는 사진과 함께 문장 하나를 남겨보세요',
                    imagePath: 'assets/image/photocard.png',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return WaitdevelopDialog(scale: scale);
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
