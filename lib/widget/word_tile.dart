import 'package:flutter/material.dart';

/// 1글자/2글자 단어 타일을 그려주는 범용 위젯
class WordTile extends StatelessWidget {
  /// 연습할 단어(1글자 또는 2글자)
  final String word;

  /// 스케일 배율 (화면 폭/높이에 따라 들어오는 값)
  final double scale;

  /// 탭했을 때 실행할 콜백
  final VoidCallback? onTap;

  const WordTile({
    super.key,
    required this.word,
    required this.scale,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 한 칸 기본 크기
    final double tile = 60 * scale;
    // 2글자면 너비를 두 칸으로
    final double width = word.length > 1 ? tile * 2 : tile;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8 * scale),
      child: Container(
        width: width,
        height: tile,
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
        ),
      ),
    );
  }
}
