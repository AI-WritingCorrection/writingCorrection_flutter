import 'package:flutter/material.dart';

class PillSection extends StatelessWidget {
  final String label;
  final String trailingImage; // asset 경로
  final Widget child;
  final double scale;
  final double? minHeight;
  final EdgeInsetsGeometry? contentPadding;
  final Color backgroundColor;

  const PillSection({
    super.key,
    required this.label,
    required this.trailingImage,
    required this.child,
    required this.scale,
    this.minHeight,
    this.contentPadding,
    this.backgroundColor = const Color(0xFFCEEF91), // 기존 초록색
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: (minHeight ?? 0)),
      padding: contentPadding ?? EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18 * scale),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 24 * scale,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8 * scale),
                child,
              ],
            ),
          ),
          SizedBox(width: 8 * scale),
          //Image.asset(trailingImage, width: 48 * scale, height: 48 * scale),
        ],
      ),
    );
  }
}
