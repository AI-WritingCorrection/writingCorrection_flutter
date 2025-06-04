import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:aiwriting_collection/widget/mini_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:aiwriting_collection/model/practice.dart';
import 'package:aiwriting_collection/model/result.dart';
import 'package:aiwriting_collection/widget/back_button.dart';
import 'package:aiwriting_collection/widget/speech_bubble.dart';
import 'package:aiwriting_collection/widget/writing/grid_handwriting_canvas.dart';
import 'package:flutter/material.dart';

class WritingPage extends StatefulWidget {
  final Practice practice;
  final bool showGuides;
  const WritingPage({
    super.key,
    required this.practice,
    this.showGuides = false,
  });

  @override
  State<WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  //GlobalKey를 이용해 GridHandwritingCanvas의 내부 상태에 직접 접근할 수 있도록
  final GlobalKey<GridHandwritingCanvasState> _canvasKey =
      GlobalKey<GridHandwritingCanvasState>();

  Timer? _timer;
  late int _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.practice.time; // use practice.time
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //mounted는 state객체가 현재화면에 장착되어있는지를 나타내는 속성
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            final double dialogScale = scaled(context, 2);
            return MiniDialog(
              scale: dialogScale,
              title: '실패😢',
              content:
                  '시간이 초과되었어요!\n'
                  '다음에는 조금 더 빨리 써봐요~',
            );
          },
        ).then((_) {
          if (!mounted) return;
          Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
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

  //제출 버튼 클릭 시 호출되는 메서드
  Future<void> _handleSubmit() async {
    // 1.셀 단위 획 이미지 맵 추출
    final Map<int, List<Uint8List>> cellImages =
        await _canvasKey.currentState?.exportCellStrokeImages() ?? {};

    // 2. 마지막 셀의 획수를 확인하여, 정해진 획수와 맞는지 확인하고, 부족하거나 많으면 모달창을 띄우고 화면으로 돌아감
    final int lastIndex = widget.practice.practiceText.length - 1;
    final requiredStrokes =
        widget.practice.essentialStrokeCounts?[lastIndex] ?? 0;
    final actualStrokes = cellImages[lastIndex]?.length ?? 0;
    if (actualStrokes > requiredStrokes) {
      _timer?.cancel();
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) {
          final double dialogScale = scaled(context, 2);
          return MiniDialog(
            scale: dialogScale,
            title: '실패😢',
            content:
                '획이 너무 많아요!\n'
                '획 수를 맞춰서 연습해보세요.',
          );
        },
      );
      //모달창이 닫히면 시간이 다시 흐르도록
      if (!mounted) return;
      _startTimer();
      return;
    } else if (actualStrokes < requiredStrokes) {
      _timer?.cancel();
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) {
          final double dialogScale = scaled(context, 2);
          return MiniDialog(
            scale: dialogScale,
            title: '실패😢',
            content:
                '획이 부족해요!\n'
                '획 수를 맞춰서 연습해보세요.',
          );
        },
      );
      //모달창이 닫히면 시간이 다시 흐르도록
      if (!mounted) return;
      _startTimer();
      return;
    }
    //3.각 획의 첫번째 점과 마지막 점을 저장
    Map<int, List<Offset>>? firstAndLastStroke =
        _canvasKey.currentState
            ?.getFirstAndLastStrokes(); // 각 셀의 첫번째 점과 마지막 점을 저장

    // 4.Result 모델 생성
    final result = Result(
      userId: 'user123',
      practiceText: widget.practice.practiceText,
      cellImages: cellImages,
      firstAndLastStroke: firstAndLastStroke ?? {},
      detailedStrokeCounts: widget.practice.detailedStrokeCounts,
      score: 0.0, // 서버 응답 후 업데이트
    );

    // 5-1.로컬 저장용(test): 각 셀별 획 이미지 저장
    final dir = await getApplicationDocumentsDirectory();
    // 타임스태프로 네이밍된 폴더 안에 이미지들 있음.
    final now = DateTime.now();
    final timestamp =
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
    final saveDir = Directory('${dir.path}/$timestamp');
    if (!await saveDir.exists()) {
      await saveDir.create(recursive: true);
    }
    for (var entry in cellImages.entries) {
      final cellIndex = entry.key;
      for (int i = 0; i < entry.value.length; i++) {
        final bytes = entry.value[i];
        final file = File('${saveDir.path}/cell_${cellIndex}_$i.png');
        await file.writeAsBytes(bytes);
      }
    }

    // 로그 출력
    print(
      'Result submitted: userId=${result.userId}, practiceText="${result.practiceText}", firstAndLastStrokes=${result.firstAndLastStroke}, detailedStrokeCounts=${result.detailedStrokeCounts}',
    );
    //이미지 저장되는 위치 확인용
    print('saved to: ${dir.path}');

    //TODO 5.2 서버에 result 전송
    //TODO 6. 결과 페이지로 이동
  }

  @override
  Widget build(BuildContext context) {
    final double cellSize = switch (widget.practice.missionType) {
      'sentence' => 103.5,
      'word' => 200,
      'phoneme' => 200,
      // TODO: Handle this case.
      String() => throw UnimplementedError(),
    };
    //10자 이하 문장에서 중앙에 위치하기 위한 boolean 변수
    bool isBelow10Sentence =
        (widget.practice.practiceText.length <= 10 &&
            widget.practice.missionType == 'sentence');

    // Calculate grid width to match practice box
    final int colCount =
        widget.practice.practiceText.length < 10
            ? widget.practice.practiceText.length
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
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: scaled(context, 200),
                            height: scaled(context, 60),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFCEEF),
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
                              _formatTime(_remainingTime),
                              style: TextStyle(
                                fontSize: scaled(context, 35),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: scaled(context, 20)),

                  SpeechBubble(
                    text: widget.practice.missionText,
                    imageAsset: widget.practice.imageAddress,
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
                        widget.practice.practiceText,
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
                            widget.practice.essentialStrokeCounts,
                        charCount: widget.practice.practiceText.length,
                        gridColor: Color(0xFFFFCEEF),
                        gridWidth: scaled(context, 3),
                        cellSize: scaled(context, cellSize),
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
                        onTap: _handleSubmit,
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
                            '제출',
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
