import 'package:aiwriting_collection/widget/word_tile.dart';
import 'package:flutter/material.dart';
import 'package:aiwriting_collection/widget/back_button.dart';

class LetterWritingScreen extends StatelessWidget {
  const LetterWritingScreen({super.key});

  static const List<List<String>> _consonantRows = [
    ['ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ'],
    ['ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'],
  ];

  static const List<List<String>> _vowelRows = [
    ['ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ'],
    ['ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ'],
    ['ㅣ'],
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = size.height / 844.0;

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1) 헤더 영역: 원고지 + 백 버튼 + 타이틀
            SizedBox(
              height: 180 * scale,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/image/letter.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16 * scale,
                      vertical: 16 * scale,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 여백을 추가한 백버튼
                          Padding(
                            padding: EdgeInsets.all(8 * scale),
                            child: BackButtonWidget(scale: scale),
                          ),
                          SizedBox(width: 8 * scale),
                          Text(
                            '자음과 모음 쓰기',
                            style: TextStyle(
                              fontSize: 33 * scale,
                              fontFamily: 'Maruburi',
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2) 설명 텍스트
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 32 * scale,
                vertical: 24 * scale,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '자음과 모음의 모양을 올바르게 잡고,\n내가 연습하고 싶은 자음 또는 모음을 골라 글자를 써보세요.',
                  style: TextStyle(
                    fontSize: 18 * scale,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),

            // 3) 단어 연습 섹션
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32 * scale),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '자음 연습:',
                  style: TextStyle(
                    fontSize: 20 * scale,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30 * scale),
            for (var row in _consonantRows) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32 * scale),
                child: Row(
                  children: [
                    for (var word in row) ...[
                      WordTile(word: word, scale: 1.5 * scale),
                      SizedBox(width: 35 * scale),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 12 * scale),
            ],
            SizedBox(height: 30 * scale),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32 * scale),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '모음 연습:',
                  style: TextStyle(
                    fontSize: 20 * scale,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30 * scale),
            for (var row in _vowelRows) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32 * scale),
                child: Row(
                  children: [
                    for (var word in row) ...[
                      WordTile(word: word, scale: 1.5 * scale),
                      SizedBox(width: 35 * scale),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 12 * scale),
            ],
            SizedBox(height: 80 * scale),
          ],
        ),
      ),
    );
  }
}
