// lib/model/stroke_guide_model.dart
import 'dart:ui';

/// 글자 하나(예: 'ㄱ', 'ㄷ')에 대한 전체 가이드
class StrokeCharGuide {
  final double paddingRatio; // cellRect.deflate(cellRect.width * paddingRatio)
  final List<StrokeGuide> strokes; // 획 리스트

  StrokeCharGuide({required this.paddingRatio, required this.strokes});

  factory StrokeCharGuide.fromJson(Map<String, dynamic> json) {
    final strokesJson = json['strokes'] as List<dynamic>;
    return StrokeCharGuide(
      paddingRatio: (json['paddingRatio'] as num).toDouble(),
      strokes:
          strokesJson
              .map((e) => StrokeGuide.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

/// 개별 획 하나 (번호, 경로, 번호 라벨 위치 등)
class StrokeGuide {
  final int order; // 1,2,3...
  final List<Offset> points; // 0~1 정규화 좌표 (inner 기준)
  final Offset labelPos; // 번호 동그라미 위치 (0~1)
  final bool arrowAtEnd; // 끝에 화살표 그릴지 여부
  final double? arrowAngle; // 있으면 이 각도 사용, 없으면 자동 계산

  StrokeGuide({
    required this.order,
    required this.points,
    required this.labelPos,
    required this.arrowAtEnd,
    this.arrowAngle,
  });

  factory StrokeGuide.fromJson(Map<String, dynamic> json) {
    final pointsJson = json['points'] as List<dynamic>;
    final labelJson = json['labelPos'] as Map<String, dynamic>;

    return StrokeGuide(
      order: json['order'] as int,
      points:
          pointsJson.map((p) {
            final mp = p as Map<String, dynamic>;
            return Offset(
              (mp['x'] as num).toDouble(),
              (mp['y'] as num).toDouble(),
            );
          }).toList(),
      labelPos: Offset(
        (labelJson['x'] as num).toDouble(),
        (labelJson['y'] as num).toDouble(),
      ),
      arrowAtEnd: json['arrowAtEnd'] as bool? ?? true,
      arrowAngle:
          json['arrowAngle'] == null
              ? null
              : (json['arrowAngle'] as num).toDouble(),
    );
  }
}
