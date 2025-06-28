import 'package:flutter/material.dart';
/// 재사용 가능한 캐릭터 이미지 버튼
class CharacterButton extends StatelessWidget {
  final String assetPath;
  final double size;
  final VoidCallback? onTap;

  const CharacterButton({
    super.key,
    required this.assetPath,
    this.size = 80,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
      ),
    );
  }
}
