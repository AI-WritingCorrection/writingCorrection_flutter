import 'package:aiwriting_collection/model/typeEnum.dart';
import 'package:aiwriting_collection/model/util.dart';

class Practice {
  final int practiceId;
  final String practiceCharacter;
  final WritingType practiceType;
  final String practiceText;
  Map<int, List<int>>? detailedStrokeCounts; // 각 글자의 초성, 중성, 종성 획수
  List<int>? essentialStrokeCounts; // 각 글자의 획수

  Practice({
    required this.practiceId,
    required this.practiceCharacter,
    required this.practiceType,
    required this.practiceText,
    this.essentialStrokeCounts,
    this.detailedStrokeCounts,
  }){
    detailedStrokeCounts ??= calculateDetailedStrokeCounts(detailedStrokeCounts, practiceText);
    essentialStrokeCounts =
        detailedStrokeCounts!.entries.map((entry) {
          final counts = entry.value;
          return counts[0] + counts[1] + counts[2];
        }).toList();
  }
}
