import 'package:aiwriting_collection/api.dart';
import 'package:aiwriting_collection/model/practice.dart';
import 'package:aiwriting_collection/model/typeEnum.dart';
import 'package:aiwriting_collection/screen/free_study/free_studypage.dart';
import 'package:flutter/material.dart';
import 'package:aiwriting_collection/widget/back_button.dart';
import 'package:aiwriting_collection/widget/word_tile.dart';
import 'package:aiwriting_collection/generated/app_localizations.dart';

class SentenceWritingScreen extends StatelessWidget {
  const SentenceWritingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final api = Api();
    final size = MediaQuery.of(context).size;
    final scale = size.height / 844.0;

    final double screenWidth = size.width;
    final double sidePadding = 64 * scale; // 좌우 패딩
    final double spacingBetweenTiles = 128 * scale; // 두 열 사이 간격
    final double availableWidth =
        screenWidth - (sidePadding * 2) - spacingBetweenTiles;
    final double eachTileWidth = availableWidth / 2;

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: FutureBuilder<List<Practice>>(
        future: api.getPracticeList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('${appLocalizations.error}: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(appLocalizations.noDataAvailable));
          }

          List<Practice> shortSentences =
              snapshot.data!
                  .where(
                    (practice) =>
                        practice.practiceType == WritingType.SENTENCE &&
                        practice.practiceText.length <= 30,
                  )
                  .toList();

          List<Practice> longSentences =
              snapshot.data!
                  .where(
                    (practice) =>
                        practice.practiceType == WritingType.SENTENCE &&
                        practice.practiceText.length > 30,
                  )
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
                                appLocalizations.sentenceWritingTitle,
                                style: TextStyle(
                                  fontSize: 33 * scale,
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
                      appLocalizations.sentenceWritingDescription,
                      style: TextStyle(
                        fontSize: 18 * scale,
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
                      appLocalizations.shortSentencePractice,
                      style: TextStyle(
                        fontSize: 20 * scale,
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
                    spacing: spacingBetweenTiles, // 열 간격 고정
                    runSpacing: 64 * scale, // 행 간 세로 간격
                    alignment: WrapAlignment.center,
                    children: [
                      for (int i = 0; i < shortSentences.length; i++)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5 * scale),
                          child: WordTile(
                            word: shortSentences[i].practiceText,
                            scale: 1.2 * scale,
                            maxWidth: eachTileWidth,
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
                      appLocalizations.longSentencePractice,
                      style: TextStyle(
                        fontSize: 20 * scale,
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
                    alignment: WrapAlignment.center,
                    children: [
                      for (int i = 0; i < longSentences.length; i++)
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: eachTileWidth,
                            minHeight: 80 * scale,
                          ),
                          child: WordTile(
                            word: longSentences[i].practiceText,
                            scale: 1.2 * scale,
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
