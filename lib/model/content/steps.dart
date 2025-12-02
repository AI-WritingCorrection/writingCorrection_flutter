import 'package:aiwriting_collection/model/common/type_enum.dart';
import 'package:aiwriting_collection/model/common/util.dart';

class Steps {
  final int stepId;
  final String stepMission;
  final String stepCharacter;
  final WritingType stepType;
  final String stepText;
  Map<int, List<int>>? detailedStrokeCounts; // 각 글자의 초성, 중성, 종성 획수
  List<int>? essentialStrokeCounts; // 각 글자의 획수
  final int stepTime;
  String stepTip;

  Steps({
    required this.stepId,
    required this.stepMission,
    required this.stepCharacter,
    required this.stepType,
    required this.stepText,
    this.essentialStrokeCounts,
    this.detailedStrokeCounts,
    this.stepTime = 120,
    this.stepTip = 'Default Tip',
  }) {
    detailedStrokeCounts ??= calculateDetailedStrokeCounts(
      detailedStrokeCounts,
      stepText,
    );
    essentialStrokeCounts =
        detailedStrokeCounts!.entries.map((entry) {
          final counts = entry.value;
          return counts[0] + counts[1] + counts[2];
        }).toList();
  }

  factory Steps.fromJson(Map<String, dynamic> json) {
    return Steps(
      stepId: json['step_id'],
      stepMission: json['step_mission'],
      stepCharacter: json['step_character'],
      stepType: WritingType.values.byName(json['step_type'] as String),
      stepText: json['step_text'],
      stepTime: json['step_time'] ?? 120,
      stepTip: json['step_tip'] ?? 'Default Tip',
    );
  }
}
