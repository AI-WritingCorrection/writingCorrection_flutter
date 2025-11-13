// lib/model/stroke_guide_repository.dart
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'stroke_guide_model.dart';

class StrokeGuideRepository {
  // 한 번 로드한 뒤 캐싱
  static Map<String, StrokeCharGuide>? _cache;

  /// 전체 JSON을 로드해서 글자 -> StrokeCharGuide 맵으로 반환
  static Future<Map<String, StrokeCharGuide>> load() async {
    if (_cache != null) return _cache!;

    // assets/stroke_guide.json 읽기
    final jsonStr = await rootBundle.loadString('assets/stroke_guide.json');
    final Map<String, dynamic> data = jsonDecode(jsonStr);

    _cache = data.map((key, value) {
      return MapEntry(
        key,
        StrokeCharGuide.fromJson(value as Map<String, dynamic>),
      );
    });

    return _cache!;
  }
}
