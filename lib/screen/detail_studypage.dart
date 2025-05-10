import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class DetailStudypage extends StatelessWidget {
  const DetailStudypage({super.key});

  //오직 태블릿 가로 화면
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    // reuse portrait scaling logic
    final double basePortrait = 390.0;
    final double baseLandscape = 844.0;
    final bool isLandscape = screenSize.width > screenSize.height;
    final double scale =
        isLandscape
            ? screenSize.height / baseLandscape
            : screenSize.width / basePortrait;

    final double horizontalInset = 40 * scale;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: 1194 * scale,
            height: 834 * scale,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: const Color(0xFFFFFBF3)),
            child: Padding(
              padding: EdgeInsets.only(
                left: 20 * scale,
                right: 20 * scale,
                top: 20 * scale,
                bottom: scale * 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top bubble + bear image row
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Speech bubble with dotted/crayon border
                      SimpleShadow(
                        opacity: 0.3,
                        sigma: 4 * scale,
                        offset: Offset(0, 4 * scale),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalInset,
                          ),
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
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(16 * scale),
                            child: Text(
                              '30초 안에 밑의 문장을 정확히 써보자!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 55 * scale,
                                fontFamily: 'Bazzi',
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Bear image slightly overlapping the bubble tail
                      Positioned(
                        right: -50 * scale,
                        bottom: -140 * scale,
                        child: Image.asset(
                          'assets/bearTeacher.png',
                          height: 312 * scale,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 90 * scale),
                  // overlapped label + assignment box with fixed height
                  SizedBox(
                    height:
                        (140 * scale) +
                        20 *
                            scale, // label height + box height + overlap adjustment
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // assignment box aligned to bubble's content edges
                        Positioned(
                          left: horizontalInset + 50 * scale,
                          right: 40 * scale,
                          child: SimpleShadow(
                            opacity: 0.3,
                            sigma: 4 * scale,
                            offset: Offset(0, 4 * scale),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50 * scale),
                              child: Container(
                                height: 140 * scale,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFCEEF91),
                                    width: 6 * scale,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    50 * scale,
                                  ),
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16 * scale,
                                ),
                                child: Text(
                                  '오늘은 토요일이라 맘껏 놀자!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 40 * scale,
                                    fontFamily: 'Bazzi',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // pink label overlapping the top-left edge
                        Positioned(
                          left: horizontalInset,
                          top: -30 * scale,
                          child: SimpleShadow(
                            opacity: 0.3,
                            sigma: 4 * scale,
                            offset: Offset(0, 4 * scale),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30 * scale),
                              child: Container(
                                width: 250 * scale,
                                height: 90 * scale,
                                color: const Color(0xFFFFE5F2),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12 * scale,
                                  vertical: 12 * scale,
                                ),
                                child: Text(
                                  '연습 과제',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF151514),
                                    fontSize: 40 * scale,
                                    fontFamily: 'Bazzi',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 70 * scale),
                  // Start practice button
                  Center(
                    child: SimpleShadow(
                      opacity: 0.3,
                      sigma: 4 * scale,
                      offset: Offset(0, 4 * scale),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40 * scale),
                        child: Container(
                          color: const Color(0xFFCEEF91),
                          padding: EdgeInsets.symmetric(
                            horizontal: 36 * scale,
                            vertical: 24 * scale,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '연습 시작!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 35 * scale,
                                  fontFamily: 'Bazzi',
                                ),
                              ),
                              SizedBox(width: 8 * scale),
                              Icon(Icons.edit, size: 24 * scale),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
