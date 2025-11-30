import 'package:flutter/material.dart';
import 'package:aiwriting_collection/widget/home/pill_section.dart';
import 'package:aiwriting_collection/generated/app_localizations.dart';

/// AI 피드백 결과를 보여주는 모달 다이얼로그 (총점 + 요약만)
class FeedbackDialog extends StatelessWidget {
  final double? avgScore;

  final String fullText;

  final List<String> stages;

  final String imagePath;

  const FeedbackDialog({
    super.key,
    required this.fullText,
    required this.stages,
    required this.imagePath,
    this.avgScore,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    // 화면 높이의 60% 사용
    final screenHeight = MediaQuery.of(context).size.height;
    final dialogHeight = screenHeight * 0.60;

    // 스케일 계산
    final basePortrait = 390.0;
    final baseLandscape = 844.0;
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final base = isLandscape ? baseLandscape : basePortrait;
    final scale = (isLandscape ? size.height : size.width) / base;

    return Container(
      height: dialogHeight,
      padding: EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24 * scale)),
      ),
      child: Scrollbar(
        child: SingleChildScrollView(
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
              SizedBox(height: 10 * scale), // Spacing after drag handle
              Text(
                appLocalizations.feedbackDialogInstruction,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20 * scale, color: Colors.black87),
              ),
              SizedBox(height: 10 * scale), // Spacing after the new text
              // ── 섹션 1: 총점 ─────────────────────────────────────────────
              PillSection(
                label: appLocalizations.feedbackDialogTotalScore,
                trailingImage: imagePath,
                scale: scale,
                child: Text(
                  (avgScore != null)
                      ? '${avgScore!.toStringAsFixed(1)} ${appLocalizations.points}'
                      : '- ${appLocalizations.points}',
                  style: TextStyle(
                    fontSize: 25 * scale,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 12 * scale),

              // ── 섹션 2: 요약(1~4차), 실패 글자만 빨강 ─────────────────────
              PillSection(
                label: appLocalizations.feedbackDialogSummary,
                trailingImage: imagePath,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16 * scale,
                  vertical: 20 * scale,
                ),
                scale: scale,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _filterLine(
                      context,
                      scale,
                      title: appLocalizations.feedbackDialogSummaryStage1,
                      filterIndex: 0,
                    ),
                    SizedBox(height: 8 * scale),
                    _filterLine(
                      context,
                      scale,
                      title: appLocalizations.feedbackDialogSummaryStage2,
                      filterIndex: 1,
                    ),
                    SizedBox(height: 8 * scale),
                    _filterLine(
                      context,
                      scale,
                      title: appLocalizations.feedbackDialogSummaryStage3,
                      filterIndex: 2,
                    ),
                    SizedBox(height: 8 * scale),
                    _filterLine(
                      context,
                      scale,
                      title: appLocalizations.feedbackDialogSummaryStage4,
                      filterIndex: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 각 차수(필터)에 대한 한 줄을 그려준다. 실패(해당 자리 '1')인 글자만 빨간색.
  Widget _filterLine(
    BuildContext context,
    double scale, {
    required String title,
    required int filterIndex,
  }) {
    final spans = <TextSpan>[];

    // 안전하게 문자/stage 길이 차이를 처리
    final int n = fullText.characters.length;
    for (int i = 0; i < n; i++) {
      final String ch = fullText.characters.elementAt(i);
      final String stage = (i < stages.length) ? stages[i] : '0000';
      final bool isFail =
          (filterIndex < stage.length) ? (stage[filterIndex] == '1') : false;

      spans.add(
        TextSpan(
          text: ch,
          style: TextStyle(
            fontSize: 22 * scale,
            fontWeight: FontWeight.w600,
            color: isFail ? Colors.red : Colors.black,
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 22 * scale,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.4,
        ),
        children: [TextSpan(text: title), ...spans],
      ),
    );
  }
}
