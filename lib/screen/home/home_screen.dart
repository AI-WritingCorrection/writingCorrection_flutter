import 'package:aiwriting_collection/repository/practice_repository_impl.dart';
import 'package:aiwriting_collection/screen/home/detail_studyPage.dart';
import 'package:aiwriting_collection/widget/character_button.dart';
import 'package:aiwriting_collection/widget/study_step.dart';
import 'package:flutter/material.dart';

/// 홈 탭용 나선형 레이아웃 페이지
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 초기화 작업이 필요하면 여기에 추가
  }

  //연습 과제 더미 데이터
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    // Use width-based scaling in portrait, height-based in landscape
    final double basePortrait = 390.0;
    final double baseLandscape = 844.0; // e.g. typical device height

    //가로모드인지 체크 후 ui세팅값 변경
    final orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;
    final double scale =
        isLandscape
            ? screenSize.height / baseLandscape
            : screenSize.width / basePortrait;

    // 첫스텝 시작 y좌표
    final double startY = (isLandscape ? 240 : 220) * scale;

    // S-curve 좌표 생성
    final double diameter = (isLandscape ? 100 : 80) * scale; //지름

    //이미지 버튼 크기
    final double separatorSize = diameter * (isLandscape ? 1.7 * 1.3 : 1.7);

    final double marginX = isLandscape ? (130 * scale) : 40 * scale; //가로 여백
    final double stepGap = (isLandscape ? 200 : 140) * scale; //스텝들간의 수직 간격

    //이후에 데이터베이스에 저장되어 있는 만큼 불러오도록 변경
    final practiceRepository = DummyPracticeRepository();
    int count = practiceRepository.getPracticeNum(); //스텝 개수
    int numBreaks = (count - 1) ~/ 5; // one break after every 5 steps
    int totalSlots = count + numBreaks;

    final List<Offset> positions = [];
    for (int i = 0; i < totalSlots; i++) {
      double x;
      switch (i % 4) {
        case 0:
          x = marginX; // left
          break;
        case 1:
        case 3:
          x = (screenSize.width - diameter) / 2; // center
          break;
        case 2:
        default:
          x = screenSize.width - marginX - diameter; // right
      }
      double y = startY + i * stepGap;
      positions.add(Offset(x, y));
    }

    // 스크롤 가능한 최대길이
    final double maxDy = positions
        .map((p) => p.dy)
        .reduce((a, b) => a > b ? a : b);
    // 안 잘리도록 패딩 추가
    final double contentHeight = maxDy + diameter + 100 * scale;

    // 스텝과 캐릭터 버튼을 위치에 따라 배치
    final widgets = <Widget>[];

    // 처음 이미지 버튼은 중간에 배치
    widgets.add(
      Positioned(
        left: (screenSize.width - separatorSize * 0.9) / 2,
        top: 100 * scale,
        child: CharacterButton(
          assetPath: 'assets/character/rabbitTeacher.png',
          size: separatorSize,
          onTap: () {},
        ),
      ),
    );

    //스텝5개 쌓이면 break걸고 이미지버튼추가
    bool insertedChapterBreak = false;
    int stepCounter = 0; // next step number to show

    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];

      // Insert chapter break after every 5 steps (once)
      if (!insertedChapterBreak && stepCounter > 0 && stepCounter % 5 == 0) {
        final double sepX = pos.dx - (separatorSize - diameter) / 2;
        widgets.add(
          Positioned(
            left: sepX,
            top: pos.dy,
            child: CharacterButton(
              assetPath: 'assets/character/bearTeacher.png',
              size: separatorSize,
              onTap: () {},
            ),
          ),
        );
        insertedChapterBreak = true;
        continue;
      }

      // Always add the study step
      final currentStep = stepCounter;
      widgets.add(
        Positioned(
          left: pos.dx,
          top: pos.dy,
          child: StudyStep(
            label: currentStep,
            diameter: diameter,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailStudyPage(pageNum: currentStep),
                ),
              );
            },
          ),
        ),
      );
      stepCounter++;

      // Allow next image break after another 5 steps
      if (stepCounter % 5 == 0) {
        insertedChapterBreak = false;
      }
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        height: contentHeight,
        child: Stack(children: widgets),
      ),
    );
  }
}
