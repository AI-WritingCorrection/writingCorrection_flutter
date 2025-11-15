import 'package:aiwriting_collection/model/practice.dart';
import 'package:aiwriting_collection/model/typeEnum.dart';
import 'package:aiwriting_collection/widget/back_button.dart';
import 'package:aiwriting_collection/widget/dialog/mini_dialog.dart';
import 'package:aiwriting_collection/widget/speech_bubble.dart';
import 'package:aiwriting_collection/widget/writing/grid_handwriting_canvas.dart';
import 'package:flutter/material.dart';
import 'package:aiwriting_collection/model/stroke_guide_model.dart';
import 'package:aiwriting_collection/model/stroke_guide_repository.dart';

class FreeStudyPage extends StatefulWidget {
  final Practice nowPractice;
  final bool showGuides;
  const FreeStudyPage({
    super.key,
    required this.nowPractice,
    this.showGuides = false,
  });

  @override
  State<FreeStudyPage> createState() => _FreeStudyPageState();
}

class _FreeStudyPageState extends State<FreeStudyPage> {
  //GlobalKey를 이용해 GridHandwritingCanvas의 내부 상태에 직접 접근할 수 있도록
  final GlobalKey<GridHandwritingCanvasState> _canvasKey =
      GlobalKey<GridHandwritingCanvasState>();

  final Future<Map<String, StrokeCharGuide>> _strokeGuidesFuture =
      StrokeGuideRepository.load();

  @override
  void initState() {
    super.initState();
  }

  //기본 기준값
  final double basePortrait = 390.0;
  final double baseLandscape = 844.0;

  double scaled(BuildContext context, double value) {
    final Size size = MediaQuery.of(context).size;
    //가로모드/세로모드 구분
    final bool isLandscape = size.width > size.height;
    final double base = isLandscape ? baseLandscape : basePortrait;
    final double scale = (isLandscape ? size.height : size.width) / base;
    return value * scale;
  }

  @override
  Widget build(BuildContext context) {
    final double cellSize = switch (widget.nowPractice.practiceType) {
      WritingType.SENTENCE => 103.5,
      WritingType.WORD => 200,
      WritingType.PHONEME => 200,
      WritingType.FREE => 200,
    };
    //10자 이하 문장에서 중앙에 위치하기 위한 boolean 변수
    bool isBelow10Sentence =
        (widget.nowPractice.practiceText.length <= 10 &&
            widget.nowPractice.practiceType == WritingType.SENTENCE);

    // Calculate grid width to match practice box
    final int colCount =
        widget.nowPractice.practiceText.length < 10
            ? widget.nowPractice.practiceText.length
            : 10;
    final double gridWidth = scaled(context, cellSize) * colCount;

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            //container가 벗어난 부분의 경계선을 부드럽게 잘라냄
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: const Color(0xFFFFFBF3)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(53, 5, 53, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //부모 Column의 너비에 맞춰 자식들이 폭을 꽉 채워서 렌더링됩니다.
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 뒤로 가기 버튼 및 타이머
                  SizedBox(
                    height: scaled(context, 60),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: BackButtonWidget(scale: 1),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: scaled(context, 20)),

                  SpeechBubble(
                    text: '천천히 연습해보세요!',
                    imageAsset: widget.nowPractice.practiceCharacter,
                    scale: scaled(context, 0.65),
                    horizontalInset: scaled(context, 80),
                    imageRight: -30,
                  ),

                  SizedBox(height: scaled(context, 75)),

                  // 연습과제 박스
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: scaled(context, 100),
                      ),
                      width: gridWidth,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFCEEF91),
                          width: scaled(context, 5),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: scaled(context, 6),
                            offset: Offset(0, scaled(context, 3)),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.nowPractice.practiceText,
                        style: TextStyle(
                          fontSize: scaled(context, 45),
                          fontFamily: "MaruBuri",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height:
                        isBelow10Sentence
                            ? scaled(context, 81.75)
                            : scaled(context, 30),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanDown: (_) {},
                      onVerticalDragUpdate: (_) {},
                      child: FutureBuilder<Map<String, StrokeCharGuide>>(
                        future: _strokeGuidesFuture,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox(
                              height: 100,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          // ★ 여기서 strokeGuides 변수를 정의해주고
                          final strokeGuides = snapshot.data!;

                          // ★ 이걸 GridHandwritingCanvas에 넘겨주는 구조
                          return GridHandwritingCanvas(
                            key: _canvasKey,
                            essentialStrokeCounts:
                                widget.nowPractice.essentialStrokeCounts,
                            charCount: widget.nowPractice.practiceText.length,
                            gridColor: const Color(0xFFFFCEEF),
                            gridWidth: scaled(context, 3),
                            cellSize: scaled(context, cellSize),

                            showGuides: widget.showGuides,
                            guideChar: widget.nowPractice.practiceText,
                            showStrokeGuide:
                                widget.nowPractice.practiceType ==
                                WritingType.PHONEME,

                            strokeGuides: strokeGuides,
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(
                    height:
                        isBelow10Sentence
                            ? scaled(context, 81.75)
                            : scaled(context, 30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _canvasKey.currentState?.undoLastStroke(),
                        child: Container(
                          width: scaled(context, 230),
                          height: scaled(context, 80),
                          decoration: BoxDecoration(
                            color: Color(0xFFCEEF91),
                            borderRadius: BorderRadius.circular(
                              scaled(context, 12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: scaled(context, 6),
                                offset: Offset(0, scaled(context, 3)),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '한 획 지우기',
                            style: TextStyle(
                              fontSize: scaled(context, 30),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: scaled(context, 35)),
                      GestureDetector(
                        onTap: () => _canvasKey.currentState?.clearAll(),
                        child: Container(
                          width: scaled(context, 230),
                          height: scaled(context, 80),
                          decoration: BoxDecoration(
                            color: Color(0xFFCEEF91),
                            borderRadius: BorderRadius.circular(
                              scaled(context, 12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: scaled(context, 6),
                                offset: Offset(0, scaled(context, 3)),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '글씨 지우기',
                            style: TextStyle(
                              fontSize: scaled(context, 30),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: scaled(context, 35)),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final double dialogScale = scaled(context, 2);
                              return MiniDialog(
                                scale: dialogScale,
                                title: '도움말',
                                content: widget.nowPractice.practiceTip,
                              );
                            },
                          );
                        },
                        child: Container(
                          width: scaled(context, 230),
                          height: scaled(context, 80),
                          decoration: BoxDecoration(
                            color: Color(0xFFCEEF91),
                            borderRadius: BorderRadius.circular(
                              scaled(context, 12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: scaled(context, 6),
                                offset: Offset(0, scaled(context, 3)),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '도움말 보기',
                            style: TextStyle(
                              fontSize: scaled(context, 30),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: scaled(context, 20)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
