import 'dart:math';
import 'package:flutter/material.dart';

/// 왼쪽 아래에 배치할 기호 목록
const Set<String> _punctuationSet = {'.', ','};

class GuidePainter extends CustomPainter {
  final String guideText;
  final int charCount, maxPerRow;
  final double cellSize;
  final TextStyle textStyle;

  GuidePainter({
    required this.guideText,
    required this.charCount,
    required this.maxPerRow,
    required this.cellSize,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cols = min(charCount, maxPerRow);

    for (int i = 0; i < charCount; i++) {
      final char = guideText[i];
      final row = i ~/ cols;
      final col = i % cols;
      final dx = col * cellSize;
      final dy = row * cellSize;

      final tp = TextPainter(
        text: TextSpan(text: char, style: textStyle),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      final centerX = dx + cellSize / 2;
      final centerY = dy + cellSize / 2;

      Offset offset;
      if (_punctuationSet.contains(char)) {
        // 기호: 왼쪽 아래
        final padding = cellSize * 0.1;
        offset = Offset(dx + padding, dy + cellSize - tp.height);
      } else {
        // 일반 문자: 중앙
        offset = Offset(centerX - tp.width / 2, centerY - tp.height / 2);
      }

      tp.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant GuidePainter old) {
    return old.guideText != guideText ||
        old.charCount != charCount ||
        old.maxPerRow != maxPerRow ||
        old.cellSize != cellSize ||
        old.textStyle != textStyle;
  }
}
