import 'package:flutter/material.dart';

/// 재사용 가능한 스텝 위젯
class StudyStep extends StatelessWidget {
  final double diameter;
  final VoidCallback? onTap;
  final int i;

  const StudyStep({
    super.key,
    this.diameter = 100,
    this.onTap,
    required this.i,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double baseWidth = 390.0;
    final double scale = screenSize.width / baseWidth;

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 237, 248, 219), // light highlight
            Color.fromARGB(255, 199, 246, 151), // darker base
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(4 * scale, 4 * scale),
            blurRadius: 4 * scale,
          ),
          BoxShadow(
            color: Colors.white60,
            offset: Offset(-4 * scale, -4 * scale),
            blurRadius: 4 * scale,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        type: MaterialType.transparency,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Center(
            child: Text(
              '${i + 1}',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 22 * scale,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
