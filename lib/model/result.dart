import 'dart:typed_data';

class Result {
  final String userId;
  final String practiceText;
  final int streakCount;
  final Map<int, List<Uint8List>> cellImages;
  final double? score;

  Result({
    required this.userId,
    required this.practiceText,
    required this.streakCount,
    required this.cellImages,
    this.score,
  });
}
