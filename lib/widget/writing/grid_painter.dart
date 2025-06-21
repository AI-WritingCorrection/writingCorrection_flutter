import 'dart:math';

import 'package:flutter/material.dart';

/// [GridPainter]는 격자를 그리는 CustomPainter입니다.
/// [charCount]는 격자에 표시할 문자 수를 나타내며,
/// [maxPerRow]는 한 행에 표시할 최대 문자 수를 나타냅니다.
/// [paint] 메서드는 주어진 [Canvas]와 [Size]를 사용하여 격자를 그립니다.
/// [shouldRepaint] 메서드는 이전과 현재의 격자 설정이 다를 경우에만 다시 그리도록 설정합니다.
class GridPainter extends CustomPainter {
  final int charCount, maxPerRow;
  final double cellSize, lineWidth;
  final Color lineColor;

  const GridPainter({
    required this.charCount,
    this.maxPerRow = 10,
    required this.cellSize,
    this.lineWidth = 5.0,
    this.lineColor = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rows = (charCount / maxPerRow).ceil();
    final fullCols = min(charCount, maxPerRow);
    final paint =
        Paint()
          ..color = lineColor
          ..strokeWidth = lineWidth;

    // 1) 배경을 흰색으로 채우기
    // canvas.drawRect(
    //   Rect.fromLTWH(0, 0, fullCols * cellSize, rows * cellSize),
    //   Paint()..color = Colors.white,
    // );

    // 2) 모든 행에 대해 fullCols 칸씩 그리기
    for (int r = 0; r <= rows; r++) {
      final y = r * cellSize;
      canvas.drawLine(Offset(0, y), Offset(fullCols * cellSize, y), paint);
    }
    // 3) 모든 열에 대해 fullRows 칸씩 그리기
    for (int c = 0; c <= fullCols; c++) {
      final x = c * cellSize;
      canvas.drawLine(Offset(x, 0), Offset(x, rows * cellSize), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter old) {
    return old.charCount != charCount ||
        old.maxPerRow != maxPerRow ||
        old.cellSize != cellSize ||
        old.lineWidth != lineWidth ||
        old.lineColor != lineColor;
  }
}
