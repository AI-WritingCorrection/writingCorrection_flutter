import 'package:aiwriting_collection/widget/word_tile.dart';
import 'package:flutter/material.dart';
import 'package:aiwriting_collection/widget/back_button.dart';
import 'package:provider/provider.dart';
import 'package:aiwriting_collection/repository/practice_repository.dart';
import 'package:aiwriting_collection/screen/writing_page.dart';

class WordWritingScreen extends StatelessWidget {
  const WordWritingScreen({super.key});

  static const List<String> _allWords = [
    '감',
    '꽃',
    '눈',
    '돈',
    '땀',
    '락',
    '물',
    '밥',
    '빵',
    '삶',
    '쌀',
    '입',
    '자',
    '짱',
    '차',
    '컷',
    '탕',
    '형',
    '솔찬',
    '윤슬',
    '도담',
    '미르',
    '헤윰',
    '올랑',
    '다올',
    '늘빈',
    '꽃샘',
    '해솔',
  ];

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<PracticeRepository>(context, listen: false);

    final size = MediaQuery.of(context).size;
    final scale = size.height / 844.0;

    // 단어 글자수 기준으로 매핑
    final Map<int, List<String>> groups = {};
    for (var w in _allWords) {
      groups.putIfAbsent(w.length, () => []).add(w);
    }
    //글자수 길이 배열 [1,2,3 ...]
    final lengths = groups.keys.toList()..sort();

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
                            '단어 쓰기',
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
                alignment: Alignment.center,
                child: Text(
                  '자음과 모음의 모양을 올바르게 잡고,\n내가 연습하고 싶은 단어를 골라 글자를 써보세요.',
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
              padding: EdgeInsets.symmetric(horizontal: 50 * scale),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '단어 연습:',
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
            //글자수별로 단어를 그룹화하여 표시
            for (var len in lengths) ...[
              // Header for this group
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16 * scale),
                child: Text(
                  '$len글자 단어',
                  style: TextStyle(
                    fontSize: 30 * scale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                //Wrap 위젯은 여러 자식 위젯을 줄 단위로 배치하고,
                //가로나 세로 공간이 부족할 때 자동으로 줄을 바꿔 다음 줄(run)에 배치해 주는 레이아웃 도구
                child: Wrap(
                  spacing: 15 * scale,
                  runSpacing: 12 * scale,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var word in groups[len]!)
                      WordTile(
                        word: word,
                        scale: 1.7 * scale,
                        onTap: () async {
                          // 1) 리포지토리에서 전체 리스트를 가져온 뒤,
                          // 2) practiceText와 missionType으로 해당 Practice를 찾아냅니다.
                          final allPractices = await repo.getAllPractices();
                          final practice = allPractices.firstWhere(
                            (p) =>
                                p.missionType == 'word' &&
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
                  ],
                ),
              ),
              SizedBox(height: 50 * scale),
            ],
          ],
        ),
      ),
    );
  }
}
