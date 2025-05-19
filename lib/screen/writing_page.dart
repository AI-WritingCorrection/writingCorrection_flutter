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
  const WritingPage({super.key, required this.practice});

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
            final double dialogScale = scaled(context, 3);
            return MiniDialog(
              scale: dialogScale,
              title: '시간 초과',
              content: '제한 시간이 초과되었습니다.',
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

  Future<void> _handleSubmit() async {
    // 1.셀 단위 획 이미지 맵 추출
    final Map<int, List<Uint8List>> cellImages =
        await _canvasKey.currentState?.exportCellStrokeImages() ?? {};

    // 2.획 수 계산: 모든 셀의 획을 합친 총 획 수
    final int strokeCount = cellImages.values.fold(
      0,
      (sum, strokes) => sum + strokes.length,
    );

    // 3.Result 모델 생성
    final result = Result(
      userId: 'user123',
      practiceText: widget.practice.practiceText,
      streakCount: strokeCount,
      cellImages: cellImages,
      score: 0.0, // 서버 응답 후 업데이트
    );

    //4.로컬 저장용(test): 각 셀별 획 이미지 저장
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
      'Result submitted: userId=${result.userId}, practiceText="${result.practiceText}", streakCount=${result.streakCount}, cells=${result.cellImages.keys.toList()}',
    );
    //이미지 저장되는 위치 확인용
    //print('saved to: ${dir.path}');

    //TODO: 서버에 result 전송
    //TODO 결과 페이지로 이동
  }

  @override
  Widget build(BuildContext context) {
    final double cellSize = switch (widget.practice.missionType) {
      'sentence' => 103.5,
      'word' => 200,
      'letter' => 200,
      'phoneme' => 200,
      // TODO: Handle this case.
      String() => throw UnimplementedError(),
    };
    return Scaffold(
      body: SafeArea(
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
                // 뒤로 가기 버튼
                Row(
                  children: [
                    BackButtonWidget(scale: 1),
                    Spacer(),
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
                    Spacer(),
                  ],
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

                Container(
                  height: scaled(context, 100),
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
                      fontSize: scaled(context, 50),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.center,
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

                SizedBox(height: scaled(context, 30)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
