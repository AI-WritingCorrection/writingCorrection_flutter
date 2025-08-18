import 'package:flutter/material.dart';

/// AI 피드백 결과를 보여주는 모달 다이얼로그 위젯
class FeedbackDialog extends StatelessWidget {
  final int? score; // 총점(백엔드 score)
  final Map<int, String>? recognizedTexts; // 글자별 OCR 결과(백엔드 recognized_texts)
  /// 보여줄 피드백 텍스트
  final String feedback;

  /// 캐릭터 이미지 경로
  final String imagePath;

  const FeedbackDialog({
    super.key,
    required this.feedback,
    required this.imagePath,
    this.score,
    this.recognizedTexts,
  });

  @override
  Widget build(BuildContext context) {
    // 화면 높이의 80%를 다이얼로그 높이로 사용
    final screenHeight = MediaQuery.of(context).size.height;
    final dialogHeight = screenHeight * 0.8;
    // 스케일 계산 (기존 scaled 함수와 유사)
    final basePortrait = 390.0;
    final baseLandscape = 844.0;
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final base = isLandscape ? baseLandscape : basePortrait;
    final scale = (isLandscape ? size.height : size.width) / base;

    final sortedEntries =
        (recognizedTexts ?? const <int, String>{}).entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

    return Container(
      height: dialogHeight,
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

          // ✅ 고정 섹션 1: 총점 박스 (있을 때만)
          if (score != null)
            _pillSection(
              context,
              label: '총점',
              trailingImage: imagePath,
              child: Text(
                '$score 점',
                style: TextStyle(
                  fontSize: 22 * scale,
                  fontWeight: FontWeight.w700,
                ),
              ),
              scale: scale,
            ),
          SizedBox(height: 12 * scale),

          // ✅ 고정 섹션 2: 요약 박스 (기존 feedback)
          _pillSection(
            context,
            label: '요약',
            trailingImage: imagePath,
            child: Text(
              feedback,
              style: TextStyle(
                fontSize: 18 * scale,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            scale: scale,
          ),
          SizedBox(height: 12 * scale),

          // ✅ 스크롤 섹션: 글자별 피드백
          Expanded(
            child: _pillSection(
              context,
              label: '글자별 피드백',
              trailingImage: imagePath,
              // 안쪽만 스크롤!
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child:
                      (recognizedTexts == null || recognizedTexts!.isEmpty)
                          ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 8 * scale),
                            child: Text(
                              '데이터 없음',
                              style: TextStyle(fontSize: 16 * scale),
                            ),
                          )
                          : Wrap(
                            spacing: 8 * scale,
                            runSpacing: 8 * scale,
                            children:
                                sortedEntries
                                    .map(
                                      (e) => _chip(
                                        context,
                                        scale,
                                        index: e.key,
                                        text: e.value,
                                      ),
                                    )
                                    .toList(),
                          ),
                ),
              ),
              scale: scale,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _chip(
  BuildContext context,
  double scale, {
  required int index,
  required String text,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10 * scale, vertical: 8 * scale),
    decoration: BoxDecoration(
      color: const Color(0xFFE6F7E6),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.black12),
    ),
    child: Text(
      '[$index] $text',
      style: TextStyle(fontSize: 14 * scale, fontWeight: FontWeight.w600),
    ),
  );
}

Widget _pillSection(
  BuildContext context, {
  required String label,
  required String trailingImage,
  required Widget child,
  required double scale,
}) {
  return Container(
    padding: EdgeInsets.all(16 * scale),
    decoration: BoxDecoration(
      color: const Color(0xFFCEEF91),
      borderRadius: BorderRadius.circular(18 * scale), // 둥근 모서리 크게
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 왼쪽: 제목 + 내용
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 18 * scale,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8 * scale),
              child,
            ],
          ),
        ),
        SizedBox(width: 8 * scale),
        Image.asset(trailingImage, width: 48 * scale, height: 48 * scale),
      ],
    ),
  );
}
