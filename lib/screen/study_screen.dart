import 'package:aiwriting_collection/widget/practice_card.dart';
import 'package:flutter/material.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;

    // 너비 기준으로 스케일링할 때 사용 (iPhone 14 Pro Max 가로 430, iPhone 14는 390 등)
    // 화면 크기에 따라 비율 조정
    final double baseWidth = 390.0; // iOS 디자인 기준
    final double scale = screenWidth / baseWidth;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF3), // 원하는 배경색
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 상단 영역 (배경 + '손글씨 연습' 텍스트 + 오른쪽 이미지)
            Stack(
              children: [
                // 상단 배경 이미지 (예: 노트 배경 등)
                Container(
                  width: screenWidth,
                  height: 180 * scale, // 상단 높이를 적절히 조정
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/letter.png'),
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
                '자음, 모음, 받침, 문장들을 올바르게 쓰는 연습법을\n차근차근 알려드립니다.',
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
              title: '손글씨 자세',
              subtitle: '손글씨를 잘 쓰기 위한 기본 자세와 도구',
              imagePath: 'assets/bearTeacher.png',
              onTap: () {
                // 해당 페이지로 이동하는 로직
              },
            ),
            PracticeCard(
              title: '자음과 모음 쓰기',
              subtitle: '자음, 모음 등 기본 글자를 바르게 쓰는 연습',
              imagePath: 'assets/rabbitTeacher.png',
              onTap: () {},
            ),
            PracticeCard(
              title: '받침 있는 글자 쓰기',
              subtitle: '쌍자음, 겹받침 등 조금 더 복잡한 글자 연습',
              imagePath: 'assets/bearTeacher.png',
              onTap: () {},
            ),
            PracticeCard(
              title: '문장 쓰기',
              subtitle: '문장 단위로 글씨를 또박또박 쓰는 연습',
              imagePath: 'assets/bearTeacher.png',
              onTap: () {},
            ),
            PracticeCard(
              title: '캘리그라피 연습',
              subtitle: '간단한 캘리그라피 연습을 통해 글씨체를 살려봐요',
              imagePath: 'assets/bearTeacher.png',
              onTap: () {},
            ),

            SizedBox(height: 80 * scale), // 하단 버튼 영역을 위해 여백
          ],
        ),
      ),
      // 하단 고정 버튼(예: '손글씨 촬영')
    );
  }
}
