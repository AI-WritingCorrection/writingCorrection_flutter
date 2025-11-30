import 'package:flutter/material.dart';

class PillSection extends StatefulWidget {
  final String? label;
  final String trailingImage;
  final Widget child;
  final double scale;
  final double? minHeight;
  final EdgeInsetsGeometry? contentPadding;
  final Color backgroundColor;

  const PillSection({
    super.key,
    this.label,
    required this.trailingImage,
    required this.child,
    required this.scale,
    this.minHeight,
    this.contentPadding,
    this.backgroundColor = const Color(0xFFCEEF91),
  });

  @override
  PillSectionState createState() => PillSectionState();
}

class PillSectionState extends State<PillSection> {
  String? label;

  @override
  void initState() {
    super.initState();
    label = widget.label;
  }

  @override
  Widget build(BuildContext context) {
    final double scale = widget.scale;
    final double minHeight = widget.minHeight ?? 0.0;
    final EdgeInsetsGeometry contentPadding =
        widget.contentPadding ?? EdgeInsets.all(16 * scale);
    final Color backgroundColor = widget.backgroundColor;

    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: contentPadding,
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
                if (label != null)
                  Text(
                    label!,
                    style: TextStyle(
                      fontSize: 24 * scale,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                SizedBox(height: 8 * scale),
                widget.child,
              ],
            ),
          ),
          SizedBox(width: 8 * scale),
          //Image.asset(widget.trailingImage, width: 48 * scale, height: 48 * scale),
        ],
      ),
    );
  }
}
