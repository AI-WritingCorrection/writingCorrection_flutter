// lib/widget/word_tile.dart

import 'package:flutter/material.dart';

/// 1글자/2글자/그 이상의 문자열을 표시할 수 있도록 확장한 WordTile
class WordTile extends StatelessWidget {
  /// 표시할 단어 또는 문장
  final String word;

  /// 화면 크기에 따라 미리 계산된 배율 값 (WordWritingScreen 등에서 받아 옴)
  final double scale;

  /// 터치 시 실행할 콜백 (옵셔널)
  final VoidCallback? onTap;

  /// 타일이 가질 최대 너비 (필요 시 줄바꿈을 위해 전달)
  final double? maxWidth;

  const WordTile({
    super.key,
    required this.word,
    required this.scale,
    this.onTap,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    // 1칸 기본 높이(또는 최소 높이)
    final double tileHeight = 60 * scale;

    // 원리:
    //  만약 maxWidth가 지정되었다면 그 너비를 사용하고,
    //  그렇지 않다면 (1글자면 tileHeight, 2글자 이상이면 tileHeight * 2)로 기존 로직 사용
    final double calculatedWidth =
        maxWidth != null
            ? maxWidth!
            : (word.length > 1 ? tileHeight * 2 : tileHeight);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8 * scale),
      child: Container(
        // 너비와 높이를 고정하거나 제약을 줌
        width: calculatedWidth,
        // 높이를 최소 tileHeight 이상으로 지정하고, 텍스트 줄바꿈에 따라 높이 확장
        constraints: BoxConstraints(minHeight: tileHeight),
        padding: EdgeInsets.symmetric(
          horizontal: 8 * scale,
          vertical: 8 * scale,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3 * scale,
              offset: Offset(2 * scale, 2 * scale),
            ),
          ],
          color: const Color(0xFFCEEF91),
          borderRadius: BorderRadius.circular(8 * scale),
        ),
        child: Text(
          word,
          style: TextStyle(
            fontSize: 20 * scale,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
          softWrap: true, // 자동 줄바꿈 허용
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }
}
