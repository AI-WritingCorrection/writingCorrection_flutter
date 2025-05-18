class Practice {
  final String missionText;
  final String imageAddress;
  final String missionType;
  final String practiceText;
  final List<int>? essentialStrokeCounts;
  final int time;

  Practice({
    required this.missionText,
    required this.imageAddress,
    required this.missionType,
    required this.practiceText,
    this.essentialStrokeCounts,
    this.time = 120,
  });
}
