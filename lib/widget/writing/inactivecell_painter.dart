import 'dart:math';

import 'package:flutter/material.dart';

// Paints a light gray background for all inactive cells.
class InactiveCellPainter extends CustomPainter {
  final int activeCell;
  final int charCount;
  final int maxPerRow;
  final double cellSize;
  final Color inactiveColor;

  InactiveCellPainter({
    required this.activeCell,
    required this.charCount,
    required this.maxPerRow,
    required this.cellSize,
    this.inactiveColor = const Color(0xFFEEEEEE),
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 실제 캔버스 전체를 흰색으로 채워 활성 셀 배경 확보
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // 한 줄에 그릴 열 수와 총 행 수 계산
    final cols = min(charCount, maxPerRow);
    final rows = (charCount / maxPerRow).ceil();
    final paint = Paint()..color = inactiveColor;

    // 비활성 셀만 회색으로 덮기
    for (int cell = 0; cell < cols * rows; cell++) {
      if (cell == activeCell) continue;
      final row = cell ~/ cols;
      final col = cell % cols;
      final rect = Rect.fromLTWH(
        col * cellSize,
        row * cellSize,
        cellSize,
        cellSize,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant InactiveCellPainter old) {
    return old.activeCell != activeCell ||
        old.charCount != charCount ||
        old.cellSize != cellSize ||
        old.maxPerRow != maxPerRow;
  }
}
