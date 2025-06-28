import 'package:aiwriting_collection/api.dart';
import 'package:aiwriting_collection/model/practice.dart';
import 'package:aiwriting_collection/model/typeEnum.dart';
import 'package:aiwriting_collection/screen/free_study/free_studypage.dart';
import 'package:flutter/material.dart';
import 'package:aiwriting_collection/widget/back_button.dart';
import 'package:aiwriting_collection/widget/word_tile.dart';


class SentenceWritingScreen extends StatelessWidget {
  const SentenceWritingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final api = Api();
    final size = MediaQuery.of(context).size;
    final scale = size.height / 844.0;

    // 화면 좌우에 줄 Padding 값을 동일하게 주기 (예: 16pt)
    final double sidePadding = 64 * scale;
 
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: FutureBuilder<List<Practice>>(
        future: api.getPracticeList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          List<Practice> shortSentences = snapshot.data!
              .where((practice) => practice.practiceType == WritingType.SENTENCE && practice.practiceText.length <= 30)
              .toList();

          List<Practice> longSentences = snapshot.data!
              .where((practice) => practice.practiceType == WritingType.SENTENCE && practice.practiceText.length > 30)
              .toList();

          return SingleChildScrollView(
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
                  child: 
                  Wrap(
                    spacing: 15 * scale,
                    runSpacing: 12 * scale,
                    alignment: WrapAlignment.center,
                    children: [
                      for (int i = 0; i < shortSentences.length; i++)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5 * scale),
                          child: WordTile(
                            word: shortSentences[i].practiceText,
                            scale: 1.7 * scale,
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => FreeStudyPage(
                                        nowPractice: shortSentences[i],
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
                  child: 
                  Wrap(
                    spacing: 15 * scale,
                    runSpacing: 12 * scale,
                    alignment: WrapAlignment.center,
                    children: [
                      for (int i = 0; i < longSentences.length; i++)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5 * scale),
                          child: WordTile(
                            word: longSentences[i].practiceText,
                            scale: 1.7 * scale,
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => FreeStudyPage(
                                        nowPractice: longSentences[i],
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

                SizedBox(height: 80 * scale),
              ],
            ),
          );
        },
      ),
    );
  }
}
