import 'package:flutter/material.dart';

class SpeechBubble extends StatelessWidget {
  final String text;
  final String imageAsset;
  final double scale;
  final double horizontalInset;
  final double imageRight;
  final double imageBottom;
  final double imageHeight;

  const SpeechBubble({
    super.key,
    required this.text,
    required this.imageAsset,
    required this.scale,
    required this.horizontalInset,
    this.imageRight = -50,
    this.imageBottom = -140,
    this.imageHeight = 312,
  });

  double calculateImageBottom(String imageAsset) {
    // 이미지 주소에 따라 크기를 조정하는 로직을 추가합니다.
    if (imageAsset.contains('hamster')) {
      return -100; // hamster 이미지의 경우
    } else if (imageAsset.contains('rabbit')) {
      return -120; // rabbit 이미지의 경우
    } else {
      return -140; // 기본 크기
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        //그림자 효과를 적용하게 해주는 SimpleShadow 패키지 사용
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalInset),
          child: Container(
            width: double.infinity,
            height: 250 * scale,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50 * scale),
              border: Border.all(
                color: const Color(0xFFFFE5F2),
                width: 8 * scale,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12 * scale,
                  spreadRadius: 2 * scale,
                  offset: Offset(0, 3 * scale),
                ),
              ],
            ),

            alignment: Alignment.center,
            padding: EdgeInsets.all(16 * scale),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 58 * scale),
            ),
          ),
        ),

        Positioned(
          right: imageRight * scale,
          bottom: calculateImageBottom(imageAsset) * scale,
          child: Image.asset(
            imageAsset,
            height: imageHeight * scale,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
