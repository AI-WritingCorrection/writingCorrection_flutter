import 'package:aiwriting_collection/model/typeEnum.dart';
import 'package:aiwriting_collection/model/util.dart';

class Steps {
  final int stepId;
  final String stepMission;
  final String stepCharacter;
  final WritingType stepType;
  final String stepText;
  Map<int, List<int>>? detailedStrokeCounts; // 각 글자의 초성, 중성, 종성 획수
  List<int>? essentialStrokeCounts; // 각 글자의 획수
  final int stepTime;

  Steps({
    required this.stepId,
    required this.stepMission,
    required this.stepCharacter,
    required this.stepType,
    required this.stepText,
    this.essentialStrokeCounts,
    this.detailedStrokeCounts,
    this.stepTime = 120,
  }) {
    detailedStrokeCounts ??= calculateDetailedStrokeCounts(detailedStrokeCounts, stepText);
    essentialStrokeCounts =
        detailedStrokeCounts!.entries.map((entry) {
          final counts = entry.value;
          return counts[0] + counts[1] + counts[2];
        }).toList();
  }
}
