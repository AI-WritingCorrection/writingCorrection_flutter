import 'package:flutter/material.dart';

class PracticeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;

  //기본 기준값
  final double basePortrait;
  final double baseLandscape;

  //원한다면 카드의 너비-높이-폰트크기를 직접 지정
  final double? cardWidth;
  final double? cardHeight;
  final double? fontSize;
  final double? semiFontSize;
  final double? imageScale;

  const PracticeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
    this.basePortrait = 390.0,
    this.baseLandscape = 844.0,

    this.cardWidth,
    this.cardHeight,
    this.fontSize,
    this.semiFontSize,
    this.imageScale,
  });

  double scaled(BuildContext context, double value) {
    // 만약 cardWidth, cardHeight가 지정되었다면 그 값을 사용
    final Size size =
        (cardWidth != null && cardHeight != null)
            ? Size(cardWidth!, cardHeight!)
            : MediaQuery.of(context).size;
    //가로모드/세로모드 구분
    final bool isLandscape = size.width > size.height;
    final double base = isLandscape ? baseLandscape : basePortrait;
    final double scale = (isLandscape ? size.height : size.width) / base;
    return value * scale;
  }

  @override
  Widget build(BuildContext context) {
    final double paddingH = scaled(context, 16);
    final double spacing = scaled(context, 8);

    final bool isLandscape =
        (cardWidth ?? MediaQuery.of(context).size.width) >
        (cardHeight ?? MediaQuery.of(context).size.height);
    final titleFontSize = scaled(context, fontSize ?? (isLandscape ? 28 : 20));
    final subtitleFontSize = scaled(
      context,
      semiFontSize ?? (isLandscape ? 20 : 13),
    );
    final imageSizeAdjusted = scaled(
      context,
      imageScale ?? (isLandscape ? 110 : 70),
    );

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: paddingH,
          vertical: scaled(context, 5),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: paddingH,
              vertical: paddingH,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(scaled(context, 12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, scaled(context, 2)),
                  blurRadius: scaled(context, 6),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: spacing),
                      Flexible(
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontFamily: 'MaruBuri',
                            fontSize: subtitleFontSize,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  imagePath,
                  width: imageSizeAdjusted,
                  height: imageSizeAdjusted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
