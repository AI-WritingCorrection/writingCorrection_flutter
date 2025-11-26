import 'package:aiwriting_collection/api.dart';
import 'package:aiwriting_collection/model/practice.dart';
import 'package:aiwriting_collection/model/typeEnum.dart';
import 'package:aiwriting_collection/screen/free_study/free_studypage.dart';
import 'package:aiwriting_collection/widget/word_tile.dart';
import 'package:flutter/material.dart';
import 'package:aiwriting_collection/widget/back_button.dart';
import 'package:aiwriting_collection/generated/app_localizations.dart';

class LetterWritingScreen extends StatelessWidget {
  const LetterWritingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final api = Api();
    final size = MediaQuery.of(context).size;
    final scale = size.height / 844.0;
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: FutureBuilder<List<Practice>>(
        future: api.getPracticeList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${appLocalizations.error}: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(appLocalizations.noDataAvailable));
          }

          List<Practice> consonantRows =
              snapshot.data!
                  .where(
                    (practice) =>
                        practice.practiceType == WritingType.PHONEME &&
                        (practice.practiceId >= 1 && practice.practiceId <= 19),
                  )
                  .toList();

          List<Practice> vowelRows =
              snapshot.data!
                  .where(
                    (practice) =>
                        practice.practiceType == WritingType.PHONEME &&
                        (practice.practiceId >= 20 &&
                            practice.practiceId <= 39),
                  )
                  .toList();

          print(
            'consonantRows length: ${consonantRows.length}, vowelRows length: ${vowelRows.length}',
          );

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
                                child: BackButtonWidget(scale: 0.9 * scale),
                              ),
                              SizedBox(width: 8 * scale),
                              Text(
                                appLocalizations.consonantsAndVowelsTitle,
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
                    horizontal: 40 * scale,
                    vertical: 24 * scale,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      appLocalizations.consonantsAndVowelsDescription,
                      style: TextStyle(
                        fontSize: 25 * scale,
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
                      appLocalizations.consonantsPractice,
                      style: TextStyle(
                        fontSize: 30 * scale,
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
                    for (int i = 0; i < consonantRows.length; i++)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5 * scale),
                        child: WordTile(
                          word: consonantRows[i].practiceText,
                          scale: 1.7 * scale,
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => FreeStudyPage(
                                      nowPractice: consonantRows[i],
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
                      appLocalizations.vowelsPractice,
                      style: TextStyle(
                        fontSize: 30 * scale,
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
                    for (int i = 0; i < vowelRows.length; i++)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5 * scale),
                        child: WordTile(
                          word: vowelRows[i].practiceText,
                          scale: 1.7 * scale,
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => FreeStudyPage(
                                      nowPractice: vowelRows[i],
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
          );
        },
      ),
    );
  }
}
