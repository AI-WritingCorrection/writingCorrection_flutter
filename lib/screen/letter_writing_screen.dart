import 'package:aiwriting_collection/widget/word_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aiwriting_collection/widget/back_button.dart';
import 'package:aiwriting_collection/repository/practice_repository.dart';
import 'package:aiwriting_collection/screen/writing_page.dart';

class LetterWritingScreen extends StatelessWidget {
  const LetterWritingScreen({super.key});

  static const List<String> _consonantRows = [
    'ㄱ',
    'ㄲ',
    'ㄴ',
    'ㄷ',
    'ㄸ',
    'ㄹ',
    'ㅁ',
    'ㅂ',
    'ㅃ',
    'ㅅ',
    'ㅆ',
    'ㅇ',
    'ㅈ',
    'ㅉ',
    'ㅊ',
    'ㅋ',
    'ㅌ',
    'ㅍ',
    'ㅎ',
  ];

  static const List<String> _vowelRows = [
    'ㅏ',
    'ㅐ',
    'ㅑ',
    'ㅒ',
    'ㅓ',
    'ㅔ',
    'ㅕ',
    'ㅖ',
    'ㅗ',
    'ㅘ',
    'ㅙ',
    'ㅚ',
    'ㅛ',
    'ㅜ',
    'ㅝ',
    'ㅞ',
    'ㅟ',
    'ㅠ',
    'ㅡ',
    'ㅢ',
    'ㅣ',
  ];

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<PracticeRepository>(context, listen: false);

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
                            child: BackButtonWidget(scale: 0.9 * scale),
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
                horizontal: 40 * scale,
                vertical: 24 * scale,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '자음과 모음의 모양을 올바르게 잡고,\n내가 연습하고 싶은 자음 또는 모음을 골라 글자를 써보세요.',
                  style: TextStyle(
                    fontSize: 25 * scale,
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
              padding: EdgeInsets.symmetric(horizontal: 52 * scale),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '자음 연습:',
                  style: TextStyle(
                    fontSize: 30 * scale,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30 * scale),

            // Consonant letters arranged in a wrap with vertical padding
            Wrap(
              spacing: 15 * scale,
              runSpacing: 12 * scale,
              alignment: WrapAlignment.center,
              children: [
                for (var word in _consonantRows)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5 * scale),
                    child: WordTile(
                      word: word,
                      scale: 1.7 * scale,
                      onTap: () async {
                        // 1) 리포지토리에서 전체 리스트를 가져온 뒤,
                        // 2) practiceText와 missionType으로 해당 Practice를 찾아냅니다.
                        final allPractices = await repo.getAllPractices();
                        final practice = allPractices.firstWhere(
                          (p) =>
                              p.missionType == 'phoneme' &&
                              p.practiceText == word,
                          orElse: () => throw Exception('Practice not found'),
                        );

                        // 3) WritingPage로 곧바로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => WritingPage(
                                  practice: practice,
                                  showGuides: true,
                                ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
            SizedBox(height: 30 * scale),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 52 * scale),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '모음 연습:',
                  style: TextStyle(
                    fontSize: 30 * scale,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30 * scale),

            // Vowel letters arranged in a wrap with vertical padding
            Wrap(
              spacing: 15 * scale,
              runSpacing: 12 * scale,
              alignment: WrapAlignment.center,
              children: [
                for (var word in _vowelRows)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5 * scale),
                    child: WordTile(
                      word: word,
                      scale: 1.7 * scale,
                      onTap: () async {
                        // 1) 리포지토리에서 전체 리스트를 가져온 뒤,
                        // 2) practiceText와 missionType으로 해당 Practice를 찾아냅니다.
                        final allPractices = await repo.getAllPractices();
                        final practice = allPractices.firstWhere(
                          (p) =>
                              p.missionType == 'phoneme' &&
                              p.practiceText == word,
                          orElse: () => throw Exception('Practice not found'),
                        );

                        // 3) WritingPage로 곧바로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => WritingPage(
                                  practice: practice,
                                  showGuides: true,
                                ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
            SizedBox(height: 80 * scale),
          ],
        ),
      ),
    );
  }
}
