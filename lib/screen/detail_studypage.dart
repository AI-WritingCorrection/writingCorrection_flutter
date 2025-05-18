import 'package:aiwriting_collection/model/practice.dart';
import 'package:aiwriting_collection/screen/writing_page.dart';
import 'package:aiwriting_collection/widget/back_button.dart';
import 'package:aiwriting_collection/widget/speech_bubble.dart';
import 'package:flutter/material.dart';

class DetailStudyPage extends StatelessWidget {
  final int pageNum;
  DetailStudyPage({super.key, required this.pageNum});
  final List<Practice> practiceList = [
    Practice(
      missionText: '30초 안에 밑의 문장을 정확히 써보자',
      imageAddress: 'assets/character/bearTeacher.png',
      missionType: 'sentence',
      practiceText: '오늘은 토요일이니까 맘껏 놀자',
      time: 30,
      essentialStrokeCounts: [3, 5, 3, 0, 5, 4, 5, 2, 2, 4, 0, 8, 6, 0, 6, 5],
    ),
    Practice(
      missionText: '밑의 단어를 정확히 써보자',
      imageAddress: 'assets/character/rabbitTeacher.png',
      missionType: 'word',
      practiceText: '감자',
      essentialStrokeCounts: [6, 5],
    ),
    Practice(
      missionText: '밑의 문장을 정확히 써보자',
      imageAddress: 'assets/character/hamster.png',
      missionType: 'sentence',
      practiceText: '내일도 잘부탁해요요',
      essentialStrokeCounts: [4, 5, 4, 0, 8, 6, 6, 6, 4, 4],
    ),
    Practice(
      missionText: '밑의 글자을 정확히 써보자',
      imageAddress: 'assets/character/hamster.png',
      missionType: 'letter',
      practiceText: '환',
      essentialStrokeCounts: [8],
    ),
    Practice(
      missionText: '밑의 한글을 정확히 써보자',
      imageAddress: 'assets/character/hamster.png',
      missionType: 'phoneme',
      practiceText: 'ㄱ',
      essentialStrokeCounts: [1],
    ),
    Practice(
      missionText: '60초 안에 밑의 한글을 정확히 써보자',
      imageAddress: 'assets/character/hamster.png',
      missionType: 'phoneme',
      practiceText: 'ㅎ',
      time: 60,
      essentialStrokeCounts: [3],
    ),
  ];
  Practice get practice => practiceList[pageNum];

  //오직 태블릿 가로 화면
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    // reuse portrait scaling logic
    final double basePortrait = 390.0;
    final double baseLandscape = 844.0;
    final bool isLandscape = screenSize.width > screenSize.height;
    final double scale =
        isLandscape
            ? screenSize.height / baseLandscape
            : screenSize.width / basePortrait;

    //말풍선 왼쪽 여백
    final double horizontalInset = 40 * scale;
    final isHamster = practice.imageAddress.contains('hamster');
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF3),
      body: SafeArea(
        child: Container(
          //container가 벗어난 부분의 경계선을 부드럽게 잘라냄
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Color(0xFFFFFBF3)),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20 * scale,
              right: 20 * scale,
              top: 20 * scale,
              bottom: 20 * scale,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //부모 Column의 너비에 맞춰 자식들이 폭을 꽉 채워서 렌더링됩니다.
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 뒤로 가기 버튼
                BackButtonWidget(scale: scale),
                SizedBox(height: 20 * scale),

                // 말풍선 + 캐릭터 이미지
                SpeechBubble(
                  text: practice.missionText,
                  imageAsset: practice.imageAddress,
                  scale: scale,
                  horizontalInset: horizontalInset,
                  imageRight: isHamster ? -30 : -50,
                  imageBottom: isHamster ? -90 : -130,
                  imageHeight:
                      isHamster
                          ? 250 // smaller for hamster
                          : 312,
                ),
                // 캐릭터 이미지 아래 여백
                SizedBox(height: 120 * scale),

                // 연습과제 박스
                SizedBox(
                  height:
                      (140 * scale) +
                      20 *
                          scale, // label height + box height + overlap adjustment
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // assignment box aligned to bubble's content edges
                      Positioned(
                        left: horizontalInset + 50 * scale,
                        right: 40 * scale,
                        child: Container(
                          height: 140 * scale,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50 * scale),
                            border: Border.all(
                              color: const Color(0xFFCEEF91),
                              width: 6 * scale,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6 * scale,
                                offset: Offset(0, 4 * scale),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                          child: Text(
                            practice.practiceText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 40 * scale,
                            ),
                          ),
                        ),
                      ),
                      // pink label overlapping the top-left edge
                      Positioned(
                        left: horizontalInset,
                        top: -30 * scale,
                        child: Container(
                          width: 250 * scale,
                          height: 90 * scale,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE5F2),
                            borderRadius: BorderRadius.circular(30 * scale),
                            border: Border.all(
                              color: Colors.pink.shade200,
                              width: 6 * scale,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6 * scale,
                                offset: Offset(0, 4 * scale),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12 * scale,
                            vertical: 12 * scale,
                          ),
                          child: Text(
                            '연습 과제',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF151514),
                              fontSize: 40 * scale,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30 * scale),
                // 시작 버튼
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WritingPage(pageNum: pageNum),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFCEEF91),
                        borderRadius: BorderRadius.circular(40 * scale),
                        border: Border.all(
                          color: Colors.green.shade400,
                          width: 6 * scale,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4 * scale,
                            offset: Offset(0, 4 * scale),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 36 * scale,
                        vertical: 24 * scale,
                      ),
                      child: Text(
                        '연습 시작!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 35 * scale),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
