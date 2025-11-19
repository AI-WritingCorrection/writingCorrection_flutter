import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {
  const Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate scale based on orientation
    final Size screenSize = MediaQuery.of(context).size;
    const double basePortrait = 390.0;
    const double baseLandscape = 844.0;
    final orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;
    final double scale =
        isLandscape
            ? screenSize.height / baseLandscape
            : screenSize.width / basePortrait;

    // Define bottom bar height using scale
    const double baseBarHeight = 65.0;
    final double barHeight = baseBarHeight * scale;

    return Container(
      height: barHeight,
      color: const Color(0xFFCEEF91),
      child: SizedBox(
        height: barHeight,
        child: TabBar(
          labelColor: const Color.fromARGB(221, 241, 105, 14),
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.transparent,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home, size: barHeight * 0.40),
              child: Text(
                '홈',
                style: TextStyle(
                  fontSize: barHeight * 0.23,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              icon: Icon(Icons.school, size: barHeight * 0.40),
              child: Text(
                '자유 공부',
                style: TextStyle(
                  fontSize: barHeight * 0.23,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              icon: Icon(Icons.history, size: barHeight * 0.40),
              child: Text(
                '기록',
                style: TextStyle(
                  fontSize: barHeight * 0.23,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              icon: Icon(Icons.person, size: barHeight * 0.40),
              child: Text(
                '내 정보',
                style: TextStyle(
                  fontSize: barHeight * 0.23,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
