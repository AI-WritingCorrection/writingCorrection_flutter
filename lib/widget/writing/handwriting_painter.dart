import 'package:flutter/material.dart';

//터치/펜 입력으로 그려진 스트로크를 렌더링하는 CustomPainter 정의
/// [points]는 Offset의 리스트로, 각 점은 그려진 선의 좌표를 나타냅니다.
/// [strokeColor]는 선의 색상을 지정하며, 기본값은 검정색입니다.
/// [strokeWidth]는 선의 두께를 지정하며, 기본값은 3.0입니다.
/// [paint] 메서드는 주어진 [Canvas]와 [Size]를 사용하여 선을 그립니다.
/// [shouldRepaint] 메서드는 이전과 현재의 점 리스트가 다를 경우에만 다시 그리도록 설정합니다.
class HandwritingPainter extends CustomPainter {
  //획들의 모음
  final List<List<Offset>> strokes;
  //한 획
  final List<Offset> currentStroke;
  final Color strokeColor;
  final double strokeWidth;

  HandwritingPainter({
    required this.strokes,
    required this.currentStroke,
    this.strokeColor = Colors.black,
    this.strokeWidth = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = strokeColor
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true;

    // Draw completed strokes
    for (final stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], paint);
      }
    }
    // Draw current in-progress stroke
    for (int i = 0; i < currentStroke.length - 1; i++) {
      canvas.drawLine(currentStroke[i], currentStroke[i + 1], paint);
    }

  }

  @override
  bool shouldRepaint(covariant HandwritingPainter old) {
    return true;
  }
}
