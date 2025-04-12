import 'package:flutter/material.dart';

class PracticeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;
  final double baseWidth;

  const PracticeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
    this.baseWidth = 390.0,
  });

  double scaled(BuildContext context, double value) {
    final screenWidth = MediaQuery.of(context).size.width;
    return value * (screenWidth / baseWidth);
  }

  @override
  Widget build(BuildContext context) {
    final double paddingH = scaled(context, 16);
    final double spacing = scaled(context, 8);
    final double imageSize = scaled(context, 70);

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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: scaled(context, 16),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: spacing),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: scaled(context, 13),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                imagePath,
                width: imageSize,
                height: imageSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}