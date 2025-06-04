import 'package:flutter/material.dart';
import 'package:aiwriting_collection/widget/back_button.dart';
import 'package:aiwriting_collection/widget/word_tile.dart';
import 'package:provider/provider.dart';
import 'package:aiwriting_collection/repository/practice_repository.dart';
import 'package:aiwriting_collection/screen/home/writing_page.dart';

class SentenceWritingScreen extends StatelessWidget {
  const SentenceWritingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<PracticeRepository>(context, listen: false);

    final size = MediaQuery.of(context).size;
    final scale = size.height / 844.0;

    // 2) 짧은 문장 예시 목록
    final List<String> shortSentences = [
      '내가 마음에 드는 글을 예쁜 글씨체로 쓰고 싶다.',
      '때로는 질문은 복잡하지만 해답은 간단할 수도 있다.',
      '항상 변화한다는 사실만 변하지 않을 뿐이다.',
      '가는 말이 고와야 오는 말도 곱다.',
    ];

    // 3) 긴 문장 예시 목록
    final List<String> longSentences = [
      '난 가끔 낮보다 밤이 더 활기 넘치고\n풍부한 색감을 가지고 있다고 생각한다.',
      '결국 모든 것은 괜찮아질 것이다,\n만약 그렇지 않다면, 끝이 아니다.',
    ];

    // 4) 두 열로 배치하기 위한 기본 계산
    // 화면 전체 폭
    final double screenWidth = size.width;
    // 화면 좌우에 줄 Padding 값을 동일하게 주기 (예: 16pt)
    final double sidePadding = 64 * scale;
    // 두 열 사이 간격
    final double spacingBetweenTiles = 128 * scale;
    // 실제로 사용 가능한 폭 = 전체폭 - (좌우 Padding) - (열 사이 간격)
    final double availableWidth =
        screenWidth - sidePadding * 2 - spacingBetweenTiles;
    // 2개의 열로 나눌 때, 한 타일이 가지는 너비
    final double eachTileWidth = availableWidth / 2;

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
                            '문장 쓰기',
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
                  '자음과 모음의 모양을 올바르게 잡고 글씨의 크기와 간격을 일정하게 맞춰\n내 마음에 드는 글을 써보세요.',
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

            // 3) 짧은 문장 연습 섹션
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32 * scale),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '짧은 문장 연습:',
                  style: TextStyle(
                    fontSize: 20 * scale,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32 * scale),
            // 4) 짧은 문장들을 두 열로 배치 → Wrap 사용
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePadding),
              child: Wrap(
                spacing: spacingBetweenTiles, // 열 간 가로 간격
                runSpacing: 64 * scale, // 행 간 세로 간격
                alignment: WrapAlignment.start,
                children: [
                  for (var sentence in shortSentences)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        // 한 타일이 최소한 이 높이만큼은 차지하도록 보장
                        minWidth: eachTileWidth,
                        minHeight: 80 * scale,
                      ),
                      child: WordTile(
                        word: sentence,
                        scale: 1.2 * scale,
                        maxWidth: eachTileWidth,
                        onTap: () async {
                          // 1) 리포지토리에서 전체 리스트를 가져온 뒤,
                          // 2) practiceText와 missionType으로 해당 Practice를 찾아냅니다.
                          final allPractices = await repo.getAllPractices();
                          final practice = allPractices.firstWhere(
                            (p) =>
                                p.missionType == 'sentence' &&
                                p.practiceText == sentence,
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
            ),

            SizedBox(height: 64 * scale),

            // 4) 긴 문장 연습 섹션
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32 * scale),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '긴 문장 연습:',
                  style: TextStyle(
                    fontSize: 20 * scale,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32 * scale),
            // 7) 긴 문장들을 두 열로 배치 → Wrap 사용
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePadding),
              child: Wrap(
                spacing: spacingBetweenTiles,
                runSpacing: 16 * scale,
                alignment: WrapAlignment.start,
                children: [
                  for (var sentence in longSentences)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        // 한 타일이 최소한 이 높이만큼은 차지하도록 보장
                        minWidth: eachTileWidth,
                        minHeight: 80 * scale,
                      ),
                      child: WordTile(
                        word: sentence,
                        scale: 1.2 * scale,
                        maxWidth: eachTileWidth,
                        onTap: () async {
                          // 1) 리포지토리에서 전체 리스트를 가져온 뒤,
                          // 2) practiceText와 missionType으로 해당 Practice를 찾아냅니다.
                          final allPractices = await repo.getAllPractices();
                          final practice = allPractices.firstWhere(
                            (p) =>
                                p.missionType == 'sentence' &&
                                p.practiceText == sentence,
                            orElse: () => throw Exception('Practice not found'),
                          );

                          // 3) WritingPage로 곧바로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WritingPage(practice: practice),
                            ),
                          );
                        },
                      ),
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
