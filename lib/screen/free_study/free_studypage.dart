import 'package:aiwriting_collection/model/practice.dart';
import 'package:aiwriting_collection/model/typeEnum.dart';
import 'package:aiwriting_collection/widget/back_button.dart';
import 'package:aiwriting_collection/widget/speech_bubble.dart';
import 'package:aiwriting_collection/widget/writing/grid_handwriting_canvas.dart';
import 'package:flutter/material.dart';


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
                      // behavior를 opaque로 주면, 자식 위 투명 영역에도 제스처를 잡습니다.
                      behavior: HitTestBehavior.opaque,

                      // 이 두 콜백만 있어도 세로 드래그를 잡아서 스크롤로 넘어가지 않게 합니다.
                      onPanDown: (_) {}, // 터치다운 이벤트를 먼저 소비
                      onVerticalDragUpdate: (_) {}, // 세로 드래그가 시작되면 아무 것도 하지 않음
                      child: GridHandwritingCanvas(
                        key: _canvasKey,
                        essentialStrokeCounts:
                            widget.nowPractice.essentialStrokeCounts,
                        charCount: widget.nowPractice.practiceText.length,
                        gridColor: Color(0xFFFFCEEF),
                        gridWidth: scaled(context, 3),
                        cellSize: scaled(context, cellSize),
                        // 가이드라인 표시 여부와 문자 전달
                        showGuides: widget.showGuides,
                        guideChar: widget.nowPractice.practiceText,
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
                      Container(
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