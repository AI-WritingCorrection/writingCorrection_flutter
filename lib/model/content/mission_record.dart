class MissionRecord {
  final int stepId;
  final int userId;
  final bool isCleared;

  MissionRecord({
    required this.stepId,
    required this.userId,
    required this.isCleared,
  });

  factory MissionRecord.fromJson(Map<String, dynamic> json) {
    return MissionRecord(
      stepId: json['step_id'] as int,
      userId: json['user_id'] as int,
      isCleared: json['isCleared'] as bool,
    );
  }
}

