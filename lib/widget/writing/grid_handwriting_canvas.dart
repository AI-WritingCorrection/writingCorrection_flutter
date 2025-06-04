import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:aiwriting_collection/widget/writing/inactivecell_painter.dart';
import 'package:flutter/material.dart';
import 'grid_painter.dart';
import 'handwriting_painter.dart';
//각 함수마다 low와 col를 선언하는 이유
//exportCellStrokeImages() 같은 메서드가 호출될 시점에 initState() 가 이미 지나갔거나,
//아예 initState() 가 실행되지 않았다면 “필드가 초기화되지 않았다”는 LateInitializationError 가 터집니다.
//근데 개인적으로 이게 맞는 방법인가 싶기는 한...

// grid_painter와 handwriting_painter를 조합해 터치 이벤트를 처리하는 위젯
class GridHandwritingCanvas extends StatefulWidget {
  final int charCount;
  final List<int>? essentialStrokeCounts;
  final int maxPerRow;
  final double cellSize;
  final Color gridColor;
  final double gridWidth;
  final Color penColor;
  final double penStrokeWidth;

  const GridHandwritingCanvas({
    super.key,
    required this.charCount,
    required this.essentialStrokeCounts,
    this.maxPerRow = 10,
    this.cellSize = 40,
    this.gridColor = Colors.black,
    this.gridWidth = 1.0,
    this.penColor = Colors.black,
    this.penStrokeWidth = 5.0,
  });

  @override
  GridHandwritingCanvasState createState() => GridHandwritingCanvasState();
}

class GridHandwritingCanvasState extends State<GridHandwritingCanvas> {
  //획들의 모음
  final List<List<Offset>> strokes = [];
  //한 획
  List<Offset> currentStroke = [];
  //현재 활성화된 셀의 인덱스
  int activeCell = 0;

  // 셀 개수
  int get cols =>
      widget.charCount < widget.maxPerRow ? widget.charCount : widget.maxPerRow;
  int get rows => (widget.charCount / widget.maxPerRow).ceil();

  //그리드에서 특정 셀(cellIndex)이 차지하는 사각 영역(Rectangle)을 계산”해 주는 역할
  // ~/는 정수 나눗셈
  //Rect는 Dart에서 사각형을 나타내는 값 객체(value object)
  Rect _cellRect(int cellIndex) {
    final row = cellIndex ~/ cols;
    final col = cellIndex % cols;
    return Rect.fromLTWH(
      col * widget.cellSize,
      row * widget.cellSize,
      widget.cellSize,
      widget.cellSize,
    );
  }

  void _onPointerDown(PointerEvent e) {
    if (_cellRect(activeCell).contains(e.localPosition)) {
      _addPoint(e.localPosition);
    }
  }

  void _onPointerMove(PointerEvent e) {
    if (_cellRect(activeCell).contains(e.localPosition)) {
      _addPoint(e.localPosition);
    }
  }

  void _onPointerUp(PointerEvent e) {
    if (currentStroke.isNotEmpty) {
      _addPoint(null); // 현재 획 마감
      _maybeAdvanceCell();
    }
  }

  /// 써야 하는 획수가 0인 경우에는 바로 다음 셀이 활성화되도록
  void _skipZeroStrokeCells() {
    final required = widget.essentialStrokeCounts;
    while (activeCell < (cols * rows) &&
           required != null &&
           activeCell < required.length &&
           required[activeCell] == 0) {
      activeCell++;
    }
  }

  void _maybeAdvanceCell() {
    // 이 셀에 속한 획 개수 집계
    final cellStrokes =
        strokes.where((stroke) {
          final mid = stroke[stroke.length ~/ 2];
          return _cellRect(activeCell).contains(mid);
        }).length;

    final required = widget.essentialStrokeCounts;
    // 아직 정의된 획수가 남아 있다면 비교
    if (activeCell < required!.length && cellStrokes >= required[activeCell]) {
      setState(() {
        activeCell = min(activeCell + 1, cols * rows - 1);
        _skipZeroStrokeCells();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _skipZeroStrokeCells();
  }

  @override
  Widget build(BuildContext context) {
    //한 줄에 그릴 실제 열 개수
    final cols =
        widget.charCount < widget.maxPerRow
            ? widget.charCount
            : widget.maxPerRow;
    final rows = (widget.charCount / widget.maxPerRow).ceil();
    //캔버스 크기
    final width = cols * widget.cellSize;
    final height = rows * widget.cellSize;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(width, height),
            painter: InactiveCellPainter(
              activeCell: activeCell,
              charCount: widget.charCount,
              maxPerRow: widget.maxPerRow,
              cellSize: widget.cellSize,
            ),
          ),
          Listener(
            behavior: HitTestBehavior.opaque,
            onPointerMove: (e) => _onPointerMove(e),
            onPointerDown: (e) => _onPointerDown(e),
            onPointerUp: (e) => _onPointerUp(e),
            child: CustomPaint(
              size: Size(width, height),
              painter: GridPainter(
                charCount: widget.charCount,
                maxPerRow: widget.maxPerRow,
                cellSize: widget.cellSize,
                lineWidth: widget.gridWidth,
                lineColor: widget.gridColor,
              ),
              foregroundPainter: HandwritingPainter(
                strokes: strokes,
                currentStroke: currentStroke,
                strokeColor: widget.penColor,
                strokeWidth: widget.penStrokeWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addPoint(Offset? point) {
    setState(() {
      if (point != null) {
        currentStroke.add(point);
      } else {
        //손을 뗐을 때: 하나의 획 종료
        strokes.add(currentStroke);
        currentStroke = [];
      }
    });
  }

  /// 마지막으로 그린 획만 지우기 (전역적으로 마지막 획을 지우고, 그 셀로 activeCell 이동)
  void undoLastStroke() {
    setState(() {
      if (strokes.isNotEmpty) {
        // 가장 마지막 획 삭제
        final last = strokes.removeLast();
        // Determine the cell index of that stroke via its midpoint
        final mid = last[last.length ~/ 2];
        final int colCount =
            widget.charCount < widget.maxPerRow
                ? widget.charCount
                : widget.maxPerRow;
        final int rowCount = (widget.charCount / widget.maxPerRow).ceil();
        final int colIndex = (mid.dx ~/ widget.cellSize).clamp(0, colCount - 1);
        final int rowIndex = (mid.dy ~/ widget.cellSize).clamp(0, rowCount - 1);
        final cellIndex = rowIndex * colCount + colIndex;
        // Move activeCell back to that cell
        activeCell = cellIndex;
      }
      // Clear any in-progress stroke
      currentStroke = [];
    });
  }

  /// 전체 그린 내용 전부 지우기
  void clearAll() {
    setState(() {
      strokes.clear();
      currentStroke = [];
      activeCell = 0;
    });
  }
  //각 획의 첫 점과 마지막 점을 “격자 셀 단위”로 묶어서 반환하는 기능
  Map<int, List<Offset>> getFirstAndLastStrokes() {
    final Map<int, List<Offset>> firstAndLast = {};
    for (var stroke in strokes) {
      if (stroke.isEmpty) continue;
      final mid = stroke[stroke.length ~/ 2];
      final int colIndex = (mid.dx ~/ widget.cellSize).clamp(0, cols - 1);
      final int rowIndex = (mid.dy ~/ widget.cellSize).clamp(0, rows - 1);
      final cellIndex = rowIndex * cols + colIndex;

      // 첫 점과 마지막 점을 저장
      firstAndLast.putIfAbsent(cellIndex, () => []).add(stroke.first);
      firstAndLast[cellIndex]?.add(stroke.last);
    }
    return firstAndLast;
  }

  /// 사용자가 그린 획(Strokes)들을 “격자 셀 단위”로 묶어서, 각 셀 크기만큼의 PNG 이미지 바이트 리스트로 변환해 주는 기능
  /// Uint8List는 바이너리 데이터(예: 이미지, 오디오, 네트워크 패킷)를 다룰 때, 바이트 단위로 메모리를 효율적으로 관리하기 위해 사용.
  Future<Map<int, List<Uint8List>>> exportCellStrokeImages() async {
    final int cols =
        widget.charCount < widget.maxPerRow
            ? widget.charCount
            : widget.maxPerRow;
    final int rows = (widget.charCount / widget.maxPerRow).ceil();

    // cellGroups 맵은 셀 인덱스, 그 셀에 속한 획(Offset 리스트) 모음을 저장.
    final Map<int, List<List<Offset>>> cellGroups = {};

    //획마다 셀 찾기&그룹화
    //획의 중간 좌표를 기준으로 셀 인덱스 계산
    //그 셀 키에 해당하는 리스트에 획 데이터를 추가하여 그룹화
    for (var stroke in strokes) {
      if (stroke.isEmpty) continue;
      final mid = stroke[stroke.length ~/ 2];
      final int colIndex = (mid.dx ~/ widget.cellSize).clamp(0, cols - 1);
      final int rowIndex = (mid.dy ~/ widget.cellSize).clamp(0, rows - 1);
      final cellIndex = rowIndex * cols + colIndex;
      cellGroups.putIfAbsent(cellIndex, () => []).add(stroke);
    }

    //그룹별로 획을 PNG 이미지로 변환
    final Map<int, List<Uint8List>> result = {};
    for (var entry in cellGroups.entries) {
      final cellIndex = entry.key;
      final strokesInCell = entry.value;
      final List<Uint8List> images = [];

      // Export each stroke to an offscreen image sized to one cell
      for (var stroke in strokesInCell) {
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(
          recorder,
          Rect.fromLTWH(0, 0, widget.cellSize, widget.cellSize),
        );
        final paint =
            Paint()
              ..color = widget.penColor
              ..strokeWidth = widget.penStrokeWidth
              ..strokeCap = StrokeCap.round;

        // Draw translated stroke so that the cell's origin is (0,0)
        // Compute cell origin in canvas coords
        final cellRow = cellIndex ~/ cols;
        final cellCol = cellIndex % cols;
        final dx = -cellCol * widget.cellSize;
        final dy = -cellRow * widget.cellSize;
        canvas.translate(dx, dy);

        for (int i = 0; i < stroke.length - 1; i++) {
          canvas.drawLine(stroke[i], stroke[i + 1], paint);
        }

        final picture = recorder.endRecording();
        final uiImage = await picture.toImage(
          widget.cellSize.toInt(),
          widget.cellSize.toInt(),
        );
        final byteData = await uiImage.toByteData(
          format: ui.ImageByteFormat.png,
        );
        if (byteData != null) {
          images.add(byteData.buffer.asUint8List());
        }
      }
      result[cellIndex] = images;
    }

    return result;
  }
}
