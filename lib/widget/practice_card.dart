import 'package:flutter/material.dart';

class PracticeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;
  final double basePortrait;
  final double baseLandscape;
  const PracticeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
    this.basePortrait = 390.0,
    this.baseLandscape = 844.0,
  });

  double scaled(BuildContext context, double value) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;
    // Use width-based scaling in portrait, height-based in landscape
    final double basePortrait = 390.0;
    final double baseLandscape = 844.0; // e.g. typical device height
    final double scale =
        isLandscape
            ? screenSize.height / baseLandscape
            : screenSize.width / basePortrait;    
    return value * scale;
  }

  @override
  Widget build(BuildContext context) {
    final double paddingH = scaled(context, 16);
    final double spacing = scaled(context, 8);
    final double imageSize = scaled(context, 70);

    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;
    final double titleFontSize =
        isLandscape ? scaled(context, 24) : scaled(context, 16);
    final double subtitleFontSize =
        isLandscape ? scaled(context, 20) : scaled(context, 13);
    final double imageSizeAdjusted =
        isLandscape ? scaled(context, 110) : imageSize;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: scaled(context, 16),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: spacing),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        color: Colors.grey[600],
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
    );
  }
}
