import 'package:aiwriting_collection/api.dart';
import 'package:aiwriting_collection/model/practice.dart';
import 'package:aiwriting_collection/model/typeEnum.dart';
import 'package:aiwriting_collection/screen/free_study/free_studypage.dart';
import 'package:aiwriting_collection/widget/word_tile.dart';
import 'package:flutter/material.dart';
import 'package:aiwriting_collection/widget/back_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class WordWritingScreen extends StatelessWidget {

  const WordWritingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final api=Api();
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
            return Center(child: Text('${appLocalizations.error}: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(appLocalizations.noDataAvailable));
          }

          List<Practice> wordPractices =
              snapshot.data!
                  .where((practice) => practice.practiceType == WritingType.WORD)
                  .toList();

          // 글자 수별로 단어를 그룹화
          final Map<int, List<Practice>> groups = {};
          for (var practice in wordPractices) {
            final length = practice.practiceText.length;
            if (!groups.containsKey(length)) {
              groups[length] = [];
            }
            groups[length]!.add(practice);
          }

          // 가장 긴 글자수
          int maxLength = groups.keys.reduce((a, b) => a > b ? a : b);

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
                                appLocalizations.wordWritingTitle,
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
                    alignment: Alignment.center,
                    child: Text(
                      appLocalizations.wordWritingDescription,
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
                  padding: EdgeInsets.symmetric(horizontal: 50 * scale),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      appLocalizations.wordPractice,
                      style: TextStyle(
                        fontSize: 30 * scale,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30 * scale),
                //글자수별로 단어를 그룹화하여 표시
                for (int len = 1; len <= maxLength; len++) ...[
                  // Header for this group
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16 * scale),
                    child: Text(
                      '$len ${appLocalizations.characterWords}',
                      style: TextStyle(
                        fontSize: 30 * scale,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Wrap(
                      spacing: 15 * scale,
                      runSpacing: 12 * scale,
                      alignment: WrapAlignment.center,
                      children: [
                        for (int i = 0; i < groups[len]!.length; i++)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5 * scale),
                            child: WordTile(
                              word: groups[len]![i].practiceText,
                              scale: 1.7 * scale,
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => FreeStudyPage(
                                          nowPractice: groups[len]![i],
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
                  SizedBox(height: 50 * scale),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
