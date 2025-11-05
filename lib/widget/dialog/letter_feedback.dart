import 'package:flutter/material.dart';
import 'package:aiwriting_collection/widget/pill_section.dart';

class LetterFeedbackSheet extends StatelessWidget {
  final String targetChar; // 대상 글자
  final double? score; // 점수
  final String stage; // 예: "0100"
  final List<String> feedback; // 피드백 문장 리스트
  final String imagePath; // 캐릭터/아이콘 asset 경로

  const LetterFeedbackSheet({
    super.key,
    required this.targetChar,
    required this.score,
    required this.stage,
    required this.feedback,
    required this.imagePath,
  });

  double _scaleOf(BuildContext context) {
    const basePortrait = 390.0;
    const baseLandscape = 844.0;
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final base = isLandscape ? baseLandscape : basePortrait;
    return (isLandscape ? size.height : size.width) / base;
  }

  @override
  Widget build(BuildContext context) {
    final scale = _scaleOf(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final dialogHeight = screenHeight * 0.4;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      height: dialogHeight, // ← 다시 고정 높이
      padding: EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24 * scale)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 드래그 핸들
          Center(
            child: Container(
              width: 40 * scale,
              height: 4 * scale,
              margin: EdgeInsets.only(bottom: 16 * scale),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2 * scale),
              ),
            ),
          ),

          // 내용 스크롤 + 하단 여유 공간
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset + 16 * scale),
              child: Column(
                children: [
                  // ── 대상 ──
                  PillSection(
                    label: '대상',
                    trailingImage: imagePath,
                    scale: scale,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoLine('대상 글자', targetChar, scale),
                        SizedBox(height: 6 * scale),
                        _infoLine(
                          '점수',
                          score != null ? '${score!}' : '-',
                          scale,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12 * scale),

                  // ── 피드백 ──
                  PillSection(
                    label: '피드백',
                    trailingImage: imagePath,
                    scale: scale,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16 * scale,
                      vertical: 16 * scale,
                    ),
                    child:
                        (feedback.isEmpty)
                            ? Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8 * scale,
                              ),
                              child: Text(
                                '피드백 없음',
                                style: TextStyle(
                                  fontSize: 18 * scale,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            )
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final f in feedback)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 6 * scale),
                                    child: Text(
                                      '• $f',
                                      style: TextStyle(
                                        fontSize: 18 * scale,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoLine(String key, String value, double scale) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$key: ',
            style: TextStyle(
              fontSize: 16 * scale,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: 16 * scale,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
