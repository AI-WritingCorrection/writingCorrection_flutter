import 'package:aiwriting_collection/widget/character_button.dart';
import 'package:aiwriting_collection/widget/study_step.dart';
import 'package:flutter/material.dart';

/// 홈 탭용 나선형 레이아웃 페이지
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    const double baseWidth = 390.0;
    final double scale = screenSize.width / baseWidth;
    // 나선형 중심점
    final double centerY = 200 * scale;

    // 나선형 전체 높이 (기본 120pt 간격에 따라 조정)
    double stepGap = 140 * scale;
    const int count = 10;
    final double contentHeight = centerY + count * stepGap + 100 * scale;

    // S-curve 좌표 생성
    final double diameter = 80 * scale;
    final double marginX = 40 * scale;
    final List<Offset> positions = [];
    for (int i = 0; i < count; i++) {
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
      double y = centerY + i * stepGap;
      positions.add(Offset(x, y));
    }

    // 스텝과 캐릭터 버튼을 위치에 따라 배치
    final widgets = <Widget>[];
    for (int i = 0; i < positions.length; i++) {
      // 스텝
      widgets.add(
        Positioned(
          left: positions[i].dx,
          top: positions[i].dy,
          child: StudyStep(i: i),
        ),
      );

      // 빈 공간에 캐릭터 이미지 버튼 추가
      double imgX;
      switch (i % 4) {
        case 0: // step at left => place image on right
          imgX = screenSize.width - marginX - diameter * 1.6;
          break;
        case 1: // step at center => place image on left
          imgX = marginX;
          break;
        case 2: // step at right => place image on left
          imgX = marginX * 0.9;
          break;
        case 3: // step at center => place image on right
          imgX = screenSize.width - marginX - diameter;
          break;
        default:
          imgX = marginX;
      }

      if ((i % 4) == 0) {
        widgets.add(
          Positioned(
            left: imgX,
            top: positions[i].dy,
            child: CharacterButton(
              assetPath: 'assets/bearTeacher.png', // 실제 이미지 경로 사용
              size: diameter * 1.7,
              onTap: () {
                // TODO: 캐릭터 버튼 탭 액션
              },
            ),
          ),
        );
      } else if ((i % 4) == 2) {
        widgets.add(
          Positioned(
            left: imgX,
            top: positions[i].dy,
            child: CharacterButton(
              assetPath: 'assets/rabbitTeacher.png', // 실제 이미지 경로 사용
              size: diameter * 1.7,
              onTap: () {
                // TODO: 캐릭터 버튼 탭 액션
              },
            ),
          ),
        );
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
