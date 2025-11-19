import 'dart:math';
import 'package:flutter/material.dart';

/// 한 번의 연습 기록
class WritingSession {
  final DateTime date; // 날짜(시각은 무시, 00:00 기준으로만 집계)
  final int durationMin; // 연습 시간(분)
  final int score; // 점수(0~100 가정)
  final String? thumbnail; // 썸네일 URL(옵션)

  WritingSession({
    required this.date,
    required this.durationMin,
    required this.score,
    this.thumbnail,
  });
}

/// 달력 화면
class MyWritingCalendarScreen extends StatefulWidget {
  /// 외부에서 세션 목록을 넘겨줄 수 있음. (미전달 시 샘플 데이터 표시)
  final List<WritingSession>? sessions;

  const MyWritingCalendarScreen({super.key, this.sessions});

  @override
  State<MyWritingCalendarScreen> createState() =>
      _MyWritingCalendarScreenState();
}

class _MyWritingCalendarScreenState extends State<MyWritingCalendarScreen> {
  late DateTime _focusedMonth; // 현재 보고 있는 달(1일 고정)
  late List<WritingSession> _sessions;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _focusedMonth = DateTime(today.year, today.month, 1);
    _sessions = widget.sessions ?? _makeSampleSessions(today);
  }

  // ───────────────────────────────────────── helpers

  // 자정 기준으로 normalize
  DateTime _d(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  // 해당 달의 일수
  int _daysInMonth(DateTime month) =>
      DateTime(month.year, month.month + 1, 0).day;

  // 첫째 날의 요일 보정(Sun=0..Sat=6)
  int _leadingBlankCount(DateTime month) {
    final w = DateTime(month.year, month.month, 1).weekday; // Mon=1..Sun=7
    return w % 7; // Sun->0, Mon->1 ...
  }

  // 분 -> "H:MM" 포맷
  String _fmtHm(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return "$h:${m.toString().padLeft(2, '0')}";
  }

  // 월 통계(총시간, 평균점수, 세션수)
  ({int totalMin, double avgScore, int count}) _monthSummary(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final list =
        _sessions
            .where(
              (s) =>
                  s.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
                  s.date.isBefore(end),
            )
            .toList();
    final totalMin = list.fold<int>(0, (p, e) => p + e.durationMin);
    final avgScore =
        list.isEmpty
            ? 0.0
            : list.map((e) => e.score).reduce((a, b) => a + b) / list.length;
    return (totalMin: totalMin, avgScore: avgScore, count: list.length);
  }

  // 일자별 집계 (해당 월만)
  Map<
    DateTime,
    ({int totalMin, double avgScore, int count, List<WritingSession> list})
  >
  _aggregateByDay(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final result =
        <
          DateTime,
          ({
            int totalMin,
            double avgScore,
            int count,
            List<WritingSession> list,
          })
        >{};
    final daily = <DateTime, List<WritingSession>>{};
    for (final s in _sessions) {
      if (s.date.isBefore(start) || !s.date.isBefore(end)) continue;
      final key = _d(s.date);
      daily.putIfAbsent(key, () => []).add(s);
    }
    daily.forEach((day, list) {
      final totalMin = list.fold<int>(0, (p, e) => p + e.durationMin);
      final avgScore =
          list.map((e) => e.score).reduce((a, b) => a + b) / list.length;
      result[day] = (
        totalMin: totalMin,
        avgScore: avgScore,
        count: list.length,
        list: list,
      );
    });
    return result;
  }

  // 샘플 데이터
  List<WritingSession> _makeSampleSessions(DateTime base) {
    final rnd = Random(2);
    final nowMonth = DateTime(base.year, base.month, 1);
    final prevMonth = DateTime(base.year, base.month - 1, 1);

    List<WritingSession> gen(DateTime month) {
      final d = _daysInMonth(month);
      final days = <int>{};
      while (days.length < 10) {
        days.add(rnd.nextInt(d) + 1);
      }
      return days.map((day) {
        final dur = (rnd.nextInt(70) + 20); // 20~89분
        final score = 70 + rnd.nextInt(31); // 70~100
        return WritingSession(
          date: DateTime(month.year, month.month, day),
          durationMin: dur,
          score: score,
        );
      }).toList();
    }

    return [...gen(prevMonth), ...gen(nowMonth)];
  }

  void _moveMonth(int delta) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + delta,
        1,
      );
    });
  }

  // ───────────────────────────────────────── UI

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final basePortrait = 390.0;
    final baseLandscape = 844.0;
    final scale =
        isLandscape ? size.height / baseLandscape : size.width / basePortrait;

    final days = _daysInMonth(_focusedMonth);
    final lead = _leadingBlankCount(_focusedMonth);
    final rows = ((lead + days) / 7).ceil();
    final trailing = rows * 7 - (lead + days);
    final agg = _aggregateByDay(_focusedMonth);
    final summary = _monthSummary(_focusedMonth);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF3),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 상단 배너
            Stack(
              children: [
                Container(
                  width: size.width,
                  height: 180 * scale,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/calendar.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 80 * scale,
                  left: 20 * scale,
                  right: 20 * scale,
                  child: Row(
                    children: [
                      // 뒤로가기
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 26 * scale,
                          color: Colors.black87,
                        ),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      SizedBox(width: 8 * scale),
                      Text(
                        '나만의 글씨 달력',
                        style: TextStyle(
                          fontSize: 23 * scale,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // 월 요약
            Padding(
              padding: EdgeInsets.fromLTRB(
                20 * scale,
                16 * scale,
                20 * scale,
                8 * scale,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 월 이동
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _moveMonth(-1),
                            icon: const Icon(Icons.chevron_left),
                          ),
                          Text(
                            '${_focusedMonth.year}년 ${_focusedMonth.month}월',
                            style: TextStyle(
                              fontSize: 20 * scale,
                              fontFamily: 'MaruBuri',
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _moveMonth(1),
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                      // 필터(확장 예정)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10 * scale,
                          vertical: 6 * scale,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8 * scale),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '모든 연습',
                              style: TextStyle(
                                fontSize: 14 * scale,
                                color: Colors.black87,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6 * scale),
                  // 요약 수치
                  Wrap(
                    spacing: 12 * scale,
                    runSpacing: 8 * scale,
                    children: [
                      _StatChip(
                        label: '총 연습시간',
                        value: _fmtHm(summary.totalMin),
                        scale: scale,
                      ),
                      _StatChip(
                        label: '평균 점수',
                        value: '${summary.avgScore.toStringAsFixed(0)}점',
                        scale: scale,
                      ),
                      _StatChip(
                        label: '세션 수',
                        value: '${summary.count}회',
                        scale: scale,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 요일 헤더 (일~토, 일요일 빨강)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12 * scale,
                vertical: 8 * scale,
              ),
              child: Row(
                children: List.generate(7, (i) {
                  final labels = ['일', '월', '화', '수', '목', '금', '토'];
                  final isSunday = i == 0;
                  return Expanded(
                    child: Center(
                      child: Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: 14 * scale,
                          fontWeight: FontWeight.w600,
                          color: isSunday ? Colors.redAccent : Colors.black54,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // 달력 그리드
            Padding(
              padding: EdgeInsets.fromLTRB(8 * scale, 0, 8 * scale, 20 * scale),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rows * 7,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                itemBuilder: (_, index) {
                  if (index < lead || index >= lead + days) {
                    return const SizedBox.shrink(); // 앞/뒤 공백
                  }
                  final day = index - lead + 1;
                  final date = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month,
                    day,
                  );
                  final key = _d(date);
                  final data = agg[key];
                  final today = _d(DateTime.now());
                  final isToday = key == today;

                  // 원 크기: 일자 총 연습시간에 따라 0~1 정규화
                  double radius = 0;
                  if (data != null) {
                    // 안전한 스케일링(루트): 20분~120분을 대표 범위로 가정
                    final norm = (data.totalMin.clamp(0, 120)) / 120.0;
                    radius = (8 + 22 * sqrt(norm)) * scale; // 8~30px
                  }

                  return InkWell(
                    onTap: () => _openDaySheet(context, key, data),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        color: Colors.white,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 연습 원(있으면)
                          if (data != null)
                            Container(
                              width: radius * 2,
                              height: radius * 2,
                              decoration: BoxDecoration(
                                color: const Color(0xFF22C55E), // 초록
                                shape: BoxShape.circle,
                              ),
                            ),
                          // 날짜 숫자
                          Positioned(
                            top: 6 * scale,
                            left: 6 * scale,
                            child: Text(
                              '$day',
                              style: TextStyle(
                                fontSize: 12 * scale,
                                fontWeight: FontWeight.w600,
                                color:
                                    key.weekday == DateTime.sunday
                                        ? Colors.redAccent
                                        : Colors.black87,
                              ),
                            ),
                          ),
                          // 오늘 하이라이트
                          if (isToday)
                            Positioned(
                              bottom: 6 * scale,
                              child: Container(
                                width: 6 * scale,
                                height: 6 * scale,
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 일자 탭 시 하단 시트
  void _openDaySheet(
    BuildContext context,
    DateTime day,
    ({int totalMin, double avgScore, int count, List<WritingSession> list})?
    data,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${day.year}.${day.month}.${day.day}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  if (data != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        border: Border.all(color: Colors.green.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '총 ${_fmtHm(data.totalMin)} • 평균 ${data.avgScore.toStringAsFixed(0)}점 • ${data.count}회',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (data == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    '이 날의 연습 기록이 없어요.',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              else
                ...data.list.map(
                  (s) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading:
                        s.thumbnail != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                s.thumbnail!,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                              ),
                            )
                            : Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.draw,
                                color: Colors.black45,
                              ),
                            ),
                    title: Text('연습 ${s.durationMin}분 • ${s.score}점'),
                    subtitle: const Text('상세 보기(추후 연결)'),
                    onTap: () {}, // TODO: 상세 페이지로 이동
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// 상단 요약 배지
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final double scale;

  const _StatChip({
    required this.label,
    required this.value,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10 * scale,
        vertical: 8 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10 * scale),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12 * scale, color: Colors.black54),
          ),
          SizedBox(width: 6 * scale),
          Text(
            value,
            style: TextStyle(fontSize: 13 * scale, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
