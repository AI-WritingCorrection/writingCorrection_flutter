import 'dart:math';
import 'package:flutter/material.dart';
import 'package:aiwriting_collection/model/stroke_guide_model.dart';

/// 왼쪽 아래에 배치할 기호 목록
const Set<String> _punctuationSet = {'.', ','};

class GuidePainter extends CustomPainter {
  final String guideText;
  final int charCount, maxPerRow;
  final double cellSize;
  final TextStyle textStyle;

  /// 자음·모음 쓰기 화면에서만 true 로 줄 예정
  final bool showStrokeGuide; // ★ 추가

  /// ★ 추가: 글자별 획순 정보 (JSON → 파싱된 데이터)
  final Map<String, StrokeCharGuide> strokeGuides;

  GuidePainter({
    required this.guideText,
    required this.charCount,
    required this.maxPerRow,
    required this.cellSize,
    required this.textStyle,
    required this.strokeGuides,
    this.showStrokeGuide = false, // ★ 기본값 false
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

      // 🔹 2) 자음·모음 + 단일 글자일 때만, 나중에 획순을 그릴 자리
      if (showStrokeGuide && charCount == 1) {
        final cellRect = Rect.fromLTWH(dx, dy, cellSize, cellSize);
        _drawStrokeGuide(canvas, cellRect, char);
      }
    }
  }

  /// ★ JSON 데이터(strokeGuides)를 이용해서 획순 가이드를 그리는 공통 함수
  void _drawStrokeGuide(Canvas canvas, Rect cellRect, String char) {
    final guide = strokeGuides[char];
    if (guide == null) return; // 해당 글자 데이터 없으면 그리지 않음

    // cellRect 에서 paddingRatio 만큼 안쪽으로 줄인 영역
    final Rect inner = cellRect.deflate(cellRect.width * guide.paddingRatio);

    // 공통 Paint들
    final Paint strokePaint =
        Paint()
          ..color = Colors.red
          ..strokeWidth = cellRect.width * 0.02
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final Paint circlePaint =
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = cellRect.width * 0.015;

    // order 순으로 정렬해서 1,2,3… 순서대로 그림
    final strokes = [...guide.strokes]
      ..sort((a, b) => a.order.compareTo(b.order));

    for (final stroke in strokes) {
      if (stroke.points.length < 2) continue;

      // 0~1 정규화 좌표를 실제 inner 좌표로 변환
      final List<Offset> pts =
          stroke.points.map((p) {
            return Offset(
              inner.left + p.dx * inner.width,
              inner.top + p.dy * inner.height,
            );
          }).toList();

      // 경로 그리기
      final Path path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (int i = 1; i < pts.length; i++) {
        path.lineTo(pts[i].dx, pts[i].dy);
      }
      canvas.drawPath(path, strokePaint);

      // 화살표 (끝점 기준)
      if (stroke.arrowAtEnd) {
        final Offset last = pts[pts.length - 1];
        final Offset prev = pts[pts.length - 2];

        // 각도: 마지막 두 점 방향으로 계산 (필요하면 JSON에서 override 가능)
        final double angle =
            stroke.arrowAngle ?? atan2(prev.dy - last.dy, prev.dx - last.dx);

        _drawArrowHead(
          canvas: canvas,
          tip: last,
          size: cellRect.width * 0.045,
          angle: angle,
          paint: strokePaint,
        );
      }

      // 번호 동그라미
      final Offset labelCenter = Offset(
        inner.left + stroke.labelPos.dx * inner.width,
        inner.top + stroke.labelPos.dy * inner.height,
      );
      final double radius = cellRect.width * 0.045;

      canvas.drawCircle(labelCenter, radius, circlePaint);

      // 번호 텍스트
      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: stroke.order.toString(),
          style: TextStyle(
            color: Colors.red,
            fontSize: cellRect.width * 0.07,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      final Offset textOffset = Offset(
        labelCenter.dx - tp.width / 2,
        labelCenter.dy - tp.height / 2,
      );
      tp.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant GuidePainter old) {
    return old.guideText != guideText ||
        old.charCount != charCount ||
        old.maxPerRow != maxPerRow ||
        old.cellSize != cellSize ||
        old.textStyle != textStyle ||
        old.showStrokeGuide != showStrokeGuide ||
        old.strokeGuides != strokeGuides; // ★ JSON 데이터 바뀌면 다시 그림
  }
}

void _drawArrowHead({
  required Canvas canvas,
  required Offset tip,
  required double size,
  required double angle,
  required Paint paint,
}) {
  // angle 방향으로 향하는 화살표 (두 갈래)
  final Path path = Path();

  // 양쪽 날개 각도 (45도씩 벌어지게)
  final double wingAngle = pi / 4;

  final Offset p1 = Offset(
    tip.dx + size * cos(angle - wingAngle),
    tip.dy + size * sin(angle - wingAngle),
  );
  final Offset p2 = Offset(
    tip.dx + size * cos(angle + wingAngle),
    tip.dy + size * sin(angle + wingAngle),
  );

  path
    ..moveTo(tip.dx, tip.dy)
    ..lineTo(p1.dx, p1.dy)
    ..moveTo(tip.dx, tip.dy)
    ..lineTo(p2.dx, p2.dy);

  canvas.drawPath(path, paint);
}
