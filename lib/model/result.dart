import 'dart:typed_data';
import 'dart:ui';

class Result {
  final String userId;//(이후 참조하는 방식으로 변경)
  final String practiceText;//(이후 참조하는 방식으로 변경)
  final Map<int, List<Uint8List>> cellImages; //int:cell index, List<Uint8List>: list of images for each stroke
  final Map<int, List<int>>? detailedStrokeCounts; // int: cell index,각 글자의 초성, 중성, 종성 획수(이후 참조하는 방식으로 변경)
  final Map<int, List<Offset>> firstAndLastStroke;//int:cell index, List<Offset>: list of first and last stroke points
  final double? score;

  Result({
    required this.userId,
    required this.practiceText,
    required this.cellImages,
    required this.firstAndLastStroke,
    required this.detailedStrokeCounts,
    this.score,
  });
}
