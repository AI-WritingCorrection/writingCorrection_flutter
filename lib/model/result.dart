import 'dart:ui';

//채점 요청 보낼 때 payload 양식
class Result {
  final int userId; //(이후 참조하는 방식으로 변경)
  final int stepId;
  final String practiceText; //(이후 참조하는 방식으로 변경)
  final Map<int, List<String>> cellImages; //int:cell index, List<String>: list of images for each stroke
  final Map<int, List<int>>? detailedStrokeCounts; // int: cell index,각 글자의 초성, 중성, 종성 획수(이후 참조하는 방식으로 변경)
  final Map<int, List<Offset>> firstAndLastStroke; //int:cell index, List<Offset>: list of first and last stroke points
  final double? score;

  Result({
    required this.userId,
    required this.stepId,
    required this.practiceText,
    required this.cellImages,
    required this.firstAndLastStroke,
    required this.detailedStrokeCounts,
    this.score,
  });
}
