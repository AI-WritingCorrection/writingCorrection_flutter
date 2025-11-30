import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:aiwriting_collection/model/content/stroke/stroke.dart';
import 'package:aiwriting_collection/widget/writing/inactivecell_painter.dart';
import 'package:flutter/material.dart';
import 'package:aiwriting_collection/model/content/stroke/stroke_guide_model.dart';
import 'grid_painter.dart';
import 'handwriting_painter.dart';
import 'guide_painter.dart';

// grid_painter와 handwriting_painter를 조합해 터치 이벤트를 처리하는 위젯
class GridHandwritingCanvas extends StatefulWidget {
  final int charCount; // 총 그리드 셀 개수 (최대 크기)
  final List<int>? essentialStrokeCounts;
  final int maxPerRow;
  final double cellSize;
  final Color gridColor;
  final double gridWidth;
  final Color penColor;
  final double penStrokeWidth;

  /// 가이드라인을 그릴지 여부
  final bool showGuides;

  /// 셀마다 그릴 가이드 문자열. 이 문자열의 길이가 실제 쓰기 가능한 셀의 수를 결정합니다.
  final String? guideChar;

  final bool showStrokeGuide;

  final Map<String, StrokeCharGuide> strokeGuides;

  const GridHandwritingCanvas({
    super.key,
    required this.charCount, // 그리드의 최대 셀 개수
    required this.essentialStrokeCounts,
    this.strokeGuides = const <String, StrokeCharGuide>{},
    this.maxPerRow = 10,
    this.cellSize = 40,
    this.gridColor = Colors.black,
    this.gridWidth = 1.0,
    this.penColor = Colors.black,
    this.penStrokeWidth = 7.0,
    this.showGuides = false,
    this.guideChar, // 쓰기 가능한 실제 문자열 (이 길이까지만 활성화)
    this.showStrokeGuide = false,
  });

  @override
  GridHandwritingCanvasState createState() => GridHandwritingCanvasState();
}

class GridHandwritingCanvasState extends State<GridHandwritingCanvas> {
  // 획들의 모음
  final List<Stroke> strokes = [];
  // 현재 그리고 있는 하나의 획
  List<Offset> currentStrokePath = [];
  // 현재 활성화된(쓰기가 가능한) 셀의 인덱스
  int activeCell = 0;

  // 총 그리드 열 개수 (최대)
  int get cols =>
      widget.charCount < widget.maxPerRow ? widget.charCount : widget.maxPerRow;
  // 총 그리드 행 개수 (최대)
  int get rows => (widget.charCount / widget.maxPerRow).ceil();

  // 실제로 쓰기가 가능한 셀의 총 개수 (guideChar의 길이에 따름)
  int get _writeableCharCount => widget.guideChar?.length ?? widget.charCount;

  /// 그리드에서 특정 셀(cellIndex)이 차지하는 사각 영역(Rectangle)을 계산합니다.
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

  /// 포인터 다운 이벤트 핸들러.
  /// 현재 활성화된 셀 내에서만 쓰기 상호작용을 허용합니다.
  void _onPointerDown(PointerEvent e) {
    // 현재 쓰기 가능한 셀 수를 초과하면 아무 작업도 하지 않습니다.
    if (activeCell >= _writeableCharCount) return;

    if (_cellRect(activeCell).contains(e.localPosition)) {
      _addPoint(e.localPosition);
    }
  }

  /// 포인터 이동 이벤트 핸들러.
  /// 현재 활성화된 셀 내에서만 쓰기 상호작용을 허용합니다.
  void _onPointerMove(PointerEvent e) {
    // 현재 쓰기 가능한 셀 수를 초과하면 아무 작업도 하지 않습니다.
    if (activeCell >= _writeableCharCount) return;

    if (_cellRect(activeCell).contains(e.localPosition)) {
      _addPoint(e.localPosition);
    }
  }

  /// 포인터 업 이벤트 핸들러.
  /// 하나의 획이 완료되면 다음 셀로 진행할지 판단합니다.
  void _onPointerUp(PointerEvent e) {
    // 현재 쓰기 가능한 셀 수를 초과하면 아무 작업도 하지 않습니다.
    if (activeCell >= _writeableCharCount) return;

    if (currentStrokePath.isNotEmpty) {
      _addPoint(null); // 현재 획 마감 (currentStrokePath를 strokes에 추가)
      _maybeAdvanceCell();
    }
  }

  /// 써야 하는 획수가 0인 셀들을 건너뛰고 다음 쓰기 가능한 셀로 `activeCell`을 이동시킵니다.
  void _skipZeroStrokeCells() {
    final required = widget.essentialStrokeCounts;
    while (activeCell < _writeableCharCount && // 쓰기 가능한 셀 내에서만 확인
        required != null &&
        activeCell < required.length &&
        required[activeCell] == 0) {
      activeCell++;
    }
    // _writeableCharCount를 넘어가지 않도록 최종적으로 제한
    activeCell = min(activeCell, _writeableCharCount == 0 ? 0 : _writeableCharCount - 1);
    // 예외 처리: 쓰기 가능한 셀이 없으면 activeCell을 0으로 설정
    if (_writeableCharCount == 0) activeCell = 0;
  }

  /// 획이 완료된 후 `activeCell`을 다음 셀로 진행시킬지 판단합니다.
  void _maybeAdvanceCell() {
    final required = widget.essentialStrokeCounts;

    // 현재 셀이 쓰기 가능한 범위를 벗어나면 진행하지 않음
    if (activeCell >= _writeableCharCount) return;

    // 이 셀에 속한 획 개수 집계 (획의 중간 좌표를 기준으로 셀 인덱스 계산)
    final cellStrokes = strokes.where((stroke) {
      if (stroke.path.isEmpty) return false;
      final mid = stroke.path[stroke.path.length ~/ 2];
      return _cellRect(activeCell).contains(mid);
    }).length;

    // 필수 획수가 정의되어 있고, 현재 셀의 획수가 필수 획수를 충족하면 다음 셀로 진행
    if (required != null &&
        activeCell < required.length &&
        cellStrokes >= required[activeCell]) {
      setState(() {
        activeCell = min(activeCell + 1, _writeableCharCount == 0 ? 0 : _writeableCharCount - 1); // 쓰기 가능한 셀 범위 내에서 진행
        _skipZeroStrokeCells(); // 획수가 0인 셀 건너뛰기
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
    // 한 줄에 그릴 실제 열 개수 (전체 그리드 크기 기준)
    final colCount =
        widget.charCount < widget.maxPerRow
            ? widget.charCount
            : widget.maxPerRow;
    final rowCount = (widget.charCount / widget.maxPerRow).ceil();
    // 캔버스 크기 (전체 그리드 크기 기준)
    final width = colCount * widget.cellSize;
    final height = rowCount * widget.cellSize;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // 비활성화된 셀을 그리는 CustomPaint
          CustomPaint(
            size: Size(width, height),
            painter: InactiveCellPainter(
              activeCell: activeCell,
              charCount: _writeableCharCount, // 쓰기 가능한 셀 수를 전달하여 그 이후는 비활성 처리
              maxPerRow: widget.maxPerRow,
              cellSize: widget.cellSize,
            ),
          ),

          // 터치 이벤트를 감지하는 Listener
          Listener(
            behavior: HitTestBehavior.opaque,
            onPointerMove: (e) => _onPointerMove(e),
            onPointerDown: (e) => _onPointerDown(e),
            onPointerUp: (e) => _onPointerUp(e),
            child: CustomPaint(
              size: Size(width, height),
              painter: GridPainter(
                charCount: widget.charCount, // 전체 그리드 크기 기준
                maxPerRow: widget.maxPerRow,
                cellSize: widget.cellSize,
                lineWidth: widget.gridWidth,
                lineColor: widget.gridColor,
              ),
              // GuidePainter와 HandwritingPainter를 함께 그립니다.
              child:
                  widget.showGuides
                      ? CustomPaint(
                        size: Size(width, height),
                        painter: GuidePainter(
                          guideText: widget.guideChar ?? '',
                          charCount: widget.charCount, // 전체 그리드 크기 기준
                          maxPerRow: widget.maxPerRow,
                          cellSize: widget.cellSize,
                          textStyle: TextStyle(
                            fontFamily: 'Maruburi',
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[400],
                            fontSize: widget.cellSize * 0.7,
                          ),
                          showStrokeGuide: widget.showStrokeGuide,
                          strokeGuides: widget.strokeGuides,
                        ),
                        foregroundPainter: HandwritingPainter(
                          strokes: strokes,
                          currentStroke: currentStrokePath,
                          strokeColor: widget.penColor,
                          strokeWidth: widget.penStrokeWidth,
                        ),
                      )
                      : CustomPaint(
                        size: Size(width, height),
                        painter: HandwritingPainter(
                          strokes: strokes,
                          currentStroke: currentStrokePath,
                          strokeColor: widget.penColor,
                          strokeWidth: widget.penStrokeWidth,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  /// 획의 한 점을 추가하거나, 획을 마감합니다.
  /// [point]: 추가할 Offset 좌표 또는 획 마감을 위한 null 값.
  void _addPoint(Offset? point) {
    setState(() {
      if (point != null) {
        currentStrokePath.add(point);
      } else {
        // 손을 떼면 하나의 획이 종료됩니다.
        strokes.add(Stroke(path: currentStrokePath, strokeWidth: widget.penStrokeWidth));
        currentStrokePath = [];
      }
    });
  }

  /// 마지막으로 그린 획만 지웁니다.
  /// (전역적으로 마지막 획을 지우고, 해당 셀로 `activeCell`을 이동시킵니다.)
  void undoLastStroke() {
    setState(() {
      if (strokes.isNotEmpty) {
        // 가장 마지막 획을 삭제합니다.
        final last = strokes.removeLast();
        
        // 삭제된 획의 중간 지점을 기준으로 셀 인덱스를 계산합니다.
        if (last.path.isNotEmpty) {
          final mid = last.path[last.path.length ~/ 2];
          // `_writeableCharCount`를 기준으로 열 수를 계산합니다.
          final int colCountForUndo = min(_writeableCharCount, widget.maxPerRow); 
          final int rowIndex = (mid.dy ~/ widget.cellSize).clamp(0, rows - 1);
          final int colIndex = (mid.dx ~/ widget.cellSize).clamp(0, colCountForUndo - 1);
          final cellIndex = rowIndex * colCountForUndo + colIndex;
          
          // `activeCell`을 해당 셀로 되돌립니다. (쓰기 가능한 범위 내에서)
          activeCell = min(cellIndex, _writeableCharCount == 0 ? 0 : _writeableCharCount - 1);
        }
      }
      // 현재 진행 중이던 획이 있다면 초기화합니다.
      currentStrokePath = [];
    });
  }

  /// 캔버스에 그려진 모든 내용을 지우고 `activeCell`을 초기화합니다.
  void clearAll() {
    setState(() {
      strokes.clear();
      currentStrokePath = [];
      activeCell = 0; // 첫 번째 셀로 초기화
      _skipZeroStrokeCells(); // 0획 셀 건너뛰기 로직 재실행
    });
  }

  /// 각 획의 첫 점과 마지막 점을 “격자 셀 단위”로 묶어서 반환하는 기능
  Map<int, List<Offset>> getFirstAndLastStrokes() {
    final Map<int, List<Offset>> firstAndLast = {};
    // 쓰기 가능한 셀 수 기준으로 열 수를 계산합니다.
    final int effectiveCols = min(_writeableCharCount, widget.maxPerRow);

    for (var stroke in strokes) {
      if (stroke.path.isEmpty) continue;
      final mid = stroke.path[stroke.path.length ~/ 2];
      final int colIndex = (mid.dx ~/ widget.cellSize).clamp(0, effectiveCols - 1);
      final int rowIndex = (mid.dy ~/ widget.cellSize).clamp(0, rows - 1); // rows는 전체 그리드 행 수
      final cellIndex = rowIndex * effectiveCols + colIndex;

      // 쓰기 가능한 셀 범위 내에서만 처리
      if (cellIndex < _writeableCharCount) {
        firstAndLast.putIfAbsent(cellIndex, () => []).add(stroke.path.first);
        firstAndLast[cellIndex]?.add(stroke.path.last);
      }
    }
    return firstAndLast;
  }

  /// 사용자가 그린 획(Strokes)들을 “격자 셀 단위”로 묶어서, 각 셀 크기만큼의 PNG 이미지 바이트 리스트로 변환해 주는 기능
  Future<Map<int, List<Uint8List>>> exportCellStrokeImages() async {
    final int colCount =
        widget.charCount < widget.maxPerRow
            ? widget.charCount
            : widget.maxPerRow;
    final int rowCount = (widget.charCount / widget.maxPerRow).ceil();

    // cellGroups 맵은 셀 인덱스, 그 셀에 속한 획(Stroke 객체) 모음을 저장.
    final Map<int, List<Stroke>> cellGroups = {};

    // 획마다 셀 찾기 & 그룹화 (쓰기 가능한 셀 범위 내에서만)
    for (var stroke in strokes) {
      if (stroke.path.isEmpty) continue;
      final mid = stroke.path[stroke.path.length ~/ 2];
      final int colIndex = (mid.dx ~/ widget.cellSize).clamp(0, colCount - 1);
      final int rowIndex = (mid.dy ~/ widget.cellSize).clamp(0, rowCount - 1);
      final cellIndex = rowIndex * colCount + colIndex;

      // 쓰기 가능한 셀 범위 내에서만 획을 그룹화
      if (cellIndex < _writeableCharCount) {
        cellGroups.putIfAbsent(cellIndex, () => []).add(stroke);
      }
    }

    // 그룹별로 획을 PNG 이미지로 변환
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
              ..strokeWidth = stroke.strokeWidth // Use the stroke's saved width
              ..strokeCap = StrokeCap.round;

        // Draw translated stroke so that the cell's origin is (0,0)
        // Compute cell origin in canvas coords
        final cellRow = cellIndex ~/ colCount;
        final cellCol = cellIndex % colCount;
        final dx = -cellCol * widget.cellSize;
        final dy = -cellRow * widget.cellSize;
        canvas.translate(dx, dy);

        for (int i = 0; i < stroke.path.length - 1; i++) {
          canvas.drawLine(stroke.path[i], stroke.path[i + 1], paint);
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