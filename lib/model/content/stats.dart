import 'package:aiwriting_collection/model/common/type_enum.dart';

class Stats {
  final int missionId;
  final WritingType stepType;
  final double score;
  final bool isCleared;
  final DateTime submissionTime;

  Stats({
    required this.missionId,
    required this.stepType,
    required this.score,
    required this.isCleared,
    required this.submissionTime,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      missionId: json['mission_id'],
      stepType: WritingType.values.byName(json['step_type'] as String),
      score: (json['score'] as num).toDouble(),
      isCleared: json['isCleared'],
      submissionTime: DateTime.parse(json['submission_time']),
    );
  }
}

