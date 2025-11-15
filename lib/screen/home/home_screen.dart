import 'dart:convert';
import 'package:aiwriting_collection/api.dart';
import 'package:aiwriting_collection/model/generated_request_list.dart';
import 'package:aiwriting_collection/model/steps.dart';
import 'package:aiwriting_collection/model/mission_record.dart';
import 'package:aiwriting_collection/model/login_status.dart';
import 'package:aiwriting_collection/model/typeEnum.dart';
import 'package:aiwriting_collection/screen/home/detail_studypage.dart';
import 'package:aiwriting_collection/screen/home/writing_page.dart';
import 'package:aiwriting_collection/widget/character_button.dart';
import 'package:aiwriting_collection/widget/dialog/mini_dialog.dart';
import 'package:aiwriting_collection/widget/study_step.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 홈 탭용 나선형 레이아웃 페이지
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final api = Api();
  final ScrollController _scrollController = ScrollController();
  final List<String> _characterImages = [
    'assets/character/bearTeacher.png',
    'assets/character/rabbitTeacher.png',
    'assets/character/hamster.png',
  ];

  final List<String> _chapterTitles = [
    '~받침 없는 쉬운 글자 연습~',
    '~받침 없는 글자 연습~',
    '~받침 있는 쉬운 글자 연습~',
    '~받침 있는 글자 연습~',
    '~받침 있는 글자\n 빠르게 써보기~',
    '~받침 없는 낱말 연습~',
    '~받침 있는 낱말 연습~',
    '~낱말 추가 연습~',
    '~낱말을 빠르게 써보기~',
    '~짧은 문장 연습~',
    '~긴 문장 연습~',
  ];

  final TextStyle aiTextStyle = const TextStyle(
    fontSize: 25, // Default font size, will be scaled
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  @override
  void initState() {
    super.initState();
    // 초기화 작업이 필요하면 여기에 추가
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('도움말'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  '스텝 활성화 규칙',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '이전 단계를 성공적으로 완료해야 다음 단계가 활성화됩니다.\n차근차근 단계를 밟아가며 실력을 키워보세요!',
                ),
                const SizedBox(height: 20),
                const Text(
                  '색상 안내',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
                Row(
                  children: const [
                    Icon(
                      Icons.circle,
                      color: Color.fromARGB(255, 199, 246, 151),
                    ),
                    SizedBox(width: 8),
                    Expanded(child: Text('현재 학습할 수 있는 단계입니다.')),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.circle, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(child: Text('아직 잠겨있는 단계입니다. 이전 단계를 먼저 완료해주세요.')),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  '이미지 버튼 기능',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
                const Text(
                  '각 챕터의 마지막에 있는 동물 선생님 버튼을 누르면, 특별한 AI 추천 문제를 풀어볼 수 있습니다.',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('닫기', style: TextStyle(color: Colors.black87)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //연습 과제 더미 데이터
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;
    const double basePortrait = 390.0;
    const double baseLandscape = 844.0;
    final double scale =
        isLandscape
            ? screenSize.height / baseLandscape
            : screenSize.width / basePortrait;

    if (!isLandscape) {
      // PORTRAIT
      return _buildPortrait(context, scale);
    } else {
      // LANDSCAPE
      return _buildLandscape(context, scale);
    }
  }

  Widget _buildPortrait(BuildContext context, double scale) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          api.getStepList(),
          api.getMissionRecords(context.read<LoginStatus>().userId ?? 0),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          }
          final steps = snapshot.data![0] as List<Steps>;
          final records = snapshot.data![1] as List<MissionRecord>;
          // Determine highest cleared step index
          final cleared =
              records.where((r) => r.isCleared).map((r) => r.stepId).toList();
          final maxCleared =
              cleared.isEmpty ? 0 : cleared.reduce((a, b) => a > b ? a : b);
          print('Max cleared step: $maxCleared');
          final enableUpTo = maxCleared + 1;

          final int count = steps.length;
          final widgets = <Widget>[];

          // --- 레이아웃 로직 수정 시작 ---

          // S-curve 좌표용 변수
          final double diameter = 80 * scale; //지름
          final double separatorSize = diameter * 1.7; //이미지 버튼 크기
          final double marginX = 40 * scale; //가로 여백

          // 원하는 균일한 간격 (조절 가능)
          final double uniformGap = 80 * scale;
          // 챕터 제목 위젯의 예상 높이 (폰트 크기 + 상하 여백)
          final double titleHeight = 80 * scale;

          // 스크롤 위치 계산용: 각 스텝의 Y좌표 저장
          final Map<int, double> stepTopPositions = {};

          // 상단 여백으로 초기화
          double currentY = 100 * scale;

          int stepCounter = 0; // 현재 스텝 번호
          int itemIndex = 0; // S-curve 위치 계산용 인덱스 (스텝 + 이미지 버튼)

          // 1. 도움말 버튼 배치
          final double searchButtonSize = separatorSize * 0.6;
          widgets.add(
            Positioned(
              left: 0,
              right: 0,
              top: currentY, // 고정값이 아닌 currentY 사용
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CharacterButton(
                    assetPath: 'assets/image/search.png',
                    size: searchButtonSize,
                    onTap: () {
                      _showHelpDialog();
                    },
                  ),
                  SizedBox(height: 10 * scale), // 간격 추가
                  Text(
                    '도움말 버튼을 눌러\n학습 방법을 확인하세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20 * scale,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );

          // 2. Y좌표 갱신: 검색 버튼 높이 + 텍스트 높이 + 균일 간격
          currentY +=
              searchButtonSize + (10 * scale) + (40 * scale) + uniformGap;
          while (stepCounter < count) {
            // 1. 챕터 제목 추가 (5의 배수 스텝 시작 시)
            if (stepCounter % 5 == 0 &&
                stepCounter ~/ 5 < _chapterTitles.length) {
              // 가로선 추가
              final double lineHeight = 2 * scale;
              widgets.add(
                Positioned(
                  left: 0,
                  right: 0,
                  top: currentY,
                  child: Container(height: lineHeight, color: Colors.grey[300]),
                ),
              );
              currentY += lineHeight + uniformGap / 2; // 선 높이 + 여백

              widgets.add(
                Positioned(
                  left: 0,
                  right: 0,
                  top: currentY,
                  child: Text(
                    _chapterTitles[stepCounter ~/ 5],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
              );
              // Y좌표 갱신: 제목 높이 + 균일 간격
              currentY += titleHeight + uniformGap / 2;
            }

            // 2. 스터디 스텝 추가
            final bool isActive = stepCounter < enableUpTo;
            final int currentStep = stepCounter; // 클로저 캡처용

            // S-curve에 따른 X좌표 계산
            double x;
            switch (itemIndex % 4) {
              case 0:
                x = marginX;
                break;
              case 1:
              case 3:
                x = (screenSize.width - diameter) / 2;
                break;
              case 2:
              default:
                x = screenSize.width - marginX - diameter;
            }

            // 스크롤 타겟을 위해 Y좌표 저장
            stepTopPositions[currentStep] = currentY;

            widgets.add(
              Positioned(
                left: x,
                top: currentY,
                child: StudyStep(
                  label: currentStep,
                  diameter: diameter,
                  onTap:
                      isActive
                          ? () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MiniDialog(
                                  scale: scale,
                                  title: '너무 작아!',
                                  content: '공부는 태블릿에서만 가능합니다!',
                                );
                              },
                            );
                          }
                          : () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MiniDialog(
                                  scale: scale,
                                  title: '알림',
                                  content: '아직 공부할 수 없어요!',
                                );
                              },
                            );
                          },
                  myColor:
                      isActive
                          ? Color.fromARGB(255, 199, 246, 151)
                          : Colors.grey,
                ),
              ),
            );

            // Y좌표 갱신: 스텝 높이 + 균일 간격
            currentY += diameter + uniformGap;
            stepCounter++;
            itemIndex++; // S-curve 인덱스 증가

            // 3. 이미지 버튼 추가 (5의 배수 스텝 완료 후)
            if (stepCounter > 0 && stepCounter % 5 == 0) {
              final int buttonIndex = stepCounter ~/ 5 - 1;
              final bool imageActive = (stepCounter - 1) < enableUpTo;
              // S-curve에 따른 X좌표 계산
              double? imgX; // ⭐️ Nullable로 변경
              CrossAxisAlignment colAlignment;
              switch (itemIndex % 4) {
                case 0: // Left
                  imgX = marginX;
                  colAlignment = CrossAxisAlignment.start;
                  break;
                case 1: // Center
                case 3: // Center
                  imgX = null; // ⭐️ Center일 땐 null
                  colAlignment = CrossAxisAlignment.center;
                  break;
                case 2: // Right
                default:
                  // ⭐️ separatorSize 기준으로 오른쪽 여백 계산
                  imgX = screenSize.width - marginX - separatorSize;
                  colAlignment = CrossAxisAlignment.end;
              }

              widgets.add(
                Positioned(
                  left: (imgX == null) ? 0 : imgX,
                  right: (imgX == null) ? 0 : null,
                  top: currentY,
                  // ⭐️ CharacterButton을 Column과 Stack으로 감싸기
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: colAlignment,
                    children: [
                      Stack(
                        clipBehavior:
                            Clip.antiAlias, // Allow children to overflow
                        alignment: Alignment.topRight, // 전구를 우측 상단에 배치
                        children: [
                          CharacterButton(
                            assetPath:
                                _characterImages[buttonIndex %
                                    _characterImages.length],
                            size: separatorSize,
                            onTap:
                                imageActive
                                    ? () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MiniDialog(
                                            scale: scale,
                                            title: '너무 작아!',
                                            content: '공부는 태블릿에서만 가능합니다!',
                                          );
                                        },
                                      );
                                    }
                                    : () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MiniDialog(
                                            scale: scale,
                                            title: '알림',
                                            content: '아직 공부할 수 없어요!',
                                          );
                                        },
                                      );
                                    },
                          ),
                          // ⭐️ imageActive일 때만 전구 이미지 표시
                          if (imageActive)
                            Padding(
                              padding: EdgeInsets.all(4.0 * scale),
                              child: Image.asset(
                                'assets/image/bulb.png', // 이미지 경로 확인!
                                width: separatorSize * 0.33, // 전구 크기 조절
                                height: separatorSize * 0.33,
                              ),
                            ),
                        ],
                      ),
                      // ⭐️ imageActive일 때만 텍스트 표시
                      if (imageActive) ...[
                        SizedBox(height: 4 * scale),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12 * scale,
                            vertical: 6 * scale,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(15 * scale),
                          ),
                          child: Text(
                            'AI 추천 문제 풀기!',
                            style: aiTextStyle.copyWith(fontSize: 20 * scale),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
              // Y좌표 갱신: 이미지 버튼 높이 + 텍스트 높이 + 균일 간격
              currentY +=
                  separatorSize +
                  (imageActive ? (4 * scale + 20 * scale) : 0) +
                  uniformGap;
              itemIndex++; // S-curve 인덱스 증가
            }
          }

          // 스크롤 가능한 전체 높이
          final double contentHeight = currentY + 100 * scale; // 하단 여백

          // --- 레이아웃 로직 수정 끝 ---

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              final screenHeight = MediaQuery.of(context).size.height;
              // 수정: 저장된 Y좌표 맵에서 maxCleared 스텝의 Y값을 가져옴
              final targetY = stepTopPositions[maxCleared] ?? (220 * scale);
              final scrollOffset =
                  targetY - (screenHeight / 2) + (diameter / 2);
              _scrollController.jumpTo(
                scrollOffset.clamp(
                  0,
                  _scrollController.position.maxScrollExtent,
                ),
              );
            }
          });

          return SingleChildScrollView(
            controller: _scrollController,
            child: SizedBox(
              width: double.infinity,
              height: contentHeight,
              child: Stack(children: widgets),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLandscape(BuildContext context, double scale) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          api.getStepList(),
          api.getMissionRecords(context.read<LoginStatus>().userId ?? 0),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          }
          final steps = snapshot.data![0] as List<Steps>;
          final records = snapshot.data![1] as List<MissionRecord>;
          // Determine highest cleared step index
          final cleared =
              records.where((r) => r.isCleared).map((r) => r.stepId).toList();
          final maxCleared =
              cleared.isEmpty ? 0 : cleared.reduce((a, b) => a > b ? a : b);
          print('Max cleared step: $maxCleared');
          final enableUpTo = maxCleared + 1;

          final int count = steps.length;
          final widgets = <Widget>[];

          // --- 레이아웃 로직 수정 시작 ---

          // S-curve 좌표용 변수
          final double diameter = 100 * scale; //지름
          final double separatorSize = diameter * 1.7 * 1.3; //이미지 버튼 크기
          final double marginX = 100 * scale; //가로 여백

          // 원하는 균일한 간격 (조절 가능)
          final double uniformGap = 80 * scale;
          // 챕터 제목 위젯의 예상 높이 (폰트 크기 + 상하 여백)
          final double titleHeight = 77 * scale;

          // 스크롤 위치 계산용: 각 스텝의 Y좌표 저장
          final Map<int, double> stepTopPositions = {};

          // 상단 여백으로 초기화
          double currentY = 100 * scale;

          int stepCounter = 0; // 현재 스텝 번호
          int itemIndex = 0; // S-curve 위치 계산용 인덱스 (스텝 + 이미지 버튼)

          // 도움말 버튼은 중앙에 배치
          final double searchButtonSize = separatorSize * 0.8;
          widgets.add(
            Positioned(
              left: 0,
              right: 0,
              top: currentY, // 고정값이 아닌 currentY 사용
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CharacterButton(
                    assetPath: 'assets/image/search.png',
                    size: searchButtonSize,
                    onTap: () {
                      _showHelpDialog();
                    },
                  ),
                  SizedBox(height: 10 * scale), // 간격 추가
                  Text(
                    '어떻게 손글손글을 통해\n 연습하는지 알려드릴게요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20 * scale,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );

          // (수정) 2. Y좌표 갱신: 검색 버튼 높이 + 텍스트 높이 + 균일 간격
          currentY +=
              searchButtonSize +
              (10 * scale) +
              (40 * scale) +
              uniformGap; // 텍스트 높이 대략 40 * scale로 가정

          while (stepCounter < count) {
            // 1. 챕터 제목 추가 (5의 배수 스텝 시작 시)
            if (stepCounter % 5 == 0 &&
                stepCounter ~/ 5 < _chapterTitles.length) {
              // 가로선 추가
              final double lineHeight = 2 * scale;
              widgets.add(
                Positioned(
                  left: 0,
                  right: 0,
                  top: currentY,
                  child: Container(height: lineHeight, color: Colors.grey[300]),
                ),
              );
              currentY += lineHeight + uniformGap / 2; // 선 높이 + 여백

              widgets.add(
                Positioned(
                  left: 0,
                  right: 0,
                  top: currentY,
                  child: Text(
                    _chapterTitles[stepCounter ~/ 5],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 62 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
              );
              // Y좌표 갱신: 제목 높이 + 균일 간격
              currentY += titleHeight + uniformGap;
            }

            // 2. 스터디 스텝 추가
            final bool isActive = stepCounter < enableUpTo;
            final int currentStep = stepCounter; // 클로저 캡처용

            // S-curve에 따른 X좌표 계산
            double x;
            switch (itemIndex % 4) {
              case 0:
                x = marginX;
                break;
              case 1:
              case 3:
                x = (screenSize.width - diameter * 2) / 2;
                break;
              case 2:
              default:
                x = screenSize.width - marginX - diameter * 2;
            }

            // 스크롤 타겟을 위해 Y좌표 저장
            stepTopPositions[currentStep] = currentY;

            widgets.add(
              Positioned(
                left: x,
                top: currentY,
                child: StudyStep(
                  label: currentStep,
                  diameter: diameter,
                  onTap:
                      isActive
                          ? () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DetailStudyPage(
                                      nowStep: steps[currentStep],
                                    ),
                              ),
                            );
                            if (mounted) {
                              setState(() {});
                            }
                          }
                          : () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MiniDialog(
                                  scale: scale,
                                  title: '알림',
                                  content: '아직 공부할 수 없어요!',
                                );
                              },
                            );
                          },
                  myColor:
                      isActive
                          ? Color.fromARGB(255, 199, 246, 151)
                          : Colors.grey,
                ),
              ),
            );

            // Y좌표 갱신: 스텝 높이 + 균일 간격
            currentY += diameter * 2 + uniformGap;
            stepCounter++;
            itemIndex++; // S-curve 인덱스 증가

            // 3. 이미지 버튼 추가 (5의 배수 스텝 완료 후)
            if (stepCounter > 0 && stepCounter % 5 == 0) {
              final int capturedStepId = stepCounter; // 캡처
              final int buttonIndex = stepCounter ~/ 5 - 1;
              final bool imageActive = (stepCounter - 1) < enableUpTo;

              // S-curve에 따른 X좌표 계산
              double? imgX; // ⭐️ Nullable로 변경
              CrossAxisAlignment colAlignment;
              switch (itemIndex % 4) {
                case 0: // Left
                  imgX = marginX;
                  colAlignment = CrossAxisAlignment.start;
                  break;
                case 1: // Center
                case 3: // Center
                  imgX = null; // ⭐️ Center일 땐 null
                  colAlignment = CrossAxisAlignment.center;
                  break;
                case 2: // Right
                default:
                  // ⭐️ separatorSize 기준으로 오른쪽 여백 계산
                  imgX = screenSize.width - marginX - separatorSize;
                  colAlignment = CrossAxisAlignment.end;
              }

              widgets.add(
                Positioned(
                  left: (imgX == null) ? 0 : imgX,
                  right: (imgX == null) ? 0 : null,
                  top: currentY,
                  // ⭐️ CharacterButton을 Column과 Stack으로 감싸기
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: colAlignment,
                    children: [
                      Stack(
                        clipBehavior: Clip.none, // Allow children to overflow
                        alignment: Alignment.topRight, // 전구를 우측 상단에 배치
                        children: [
                          CharacterButton(
                            assetPath:
                                _characterImages[buttonIndex %
                                    _characterImages.length],
                            size: separatorSize,
                            onTap:
                                imageActive
                                    ? () async {
                                      final nowRequest =
                                          generatedRequestList[buttonIndex];
                                      final form = nowRequest['form'];
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder:
                                            (context) => const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                      );
                                      try {
                                        final res = await api.requestAiText(
                                          nowRequest,
                                        );
                                        if (Navigator.of(context).canPop()) {
                                          Navigator.of(context).pop();
                                        }
                                        final decoded = utf8.decode(
                                          res.bodyBytes,
                                        );
                                        final Map<String, dynamic> data =
                                            jsonDecode(decoded);
                                        final String requestedText =
                                            (data['result'] as String);
                                        Steps aiStep = Steps(
                                          stepId: capturedStepId,
                                          stepMission: '밑의 글자를 작성해보세요!',
                                          stepCharacter:
                                              _characterImages[buttonIndex %
                                                  _characterImages.length],
                                          stepType: WritingType.values.byName(
                                            form,
                                          ),
                                          stepText: requestedText,
                                        );
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => WritingPage(
                                                  nowStep: aiStep,
                                                ),
                                          ),
                                        );
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      } catch (e) {
                                        if (Navigator.of(context).canPop()) {
                                          Navigator.of(context).pop();
                                        }
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text('오류'),
                                                content: Text(
                                                  'AI 추천 문제 생성 중 오류가 발생했습니다: $e',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () =>
                                                            Navigator.of(
                                                              context,
                                                            ).pop(),
                                                    child: const Text('확인'),
                                                  ),
                                                ],
                                              ),
                                        );
                                      }
                                    }
                                    : () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MiniDialog(
                                            scale: scale,
                                            title: '알림',
                                            content: '아직 공부할 수 없어요!',
                                          );
                                        },
                                      );
                                    },
                          ),
                          // ⭐️ imageActive일 때만 전구 이미지 표시
                          if (imageActive)
                            Padding(
                              padding: EdgeInsets.all(12.0 * scale),
                              child: Image.asset(
                                'assets/image/bulb.png', // 이미지 경로 확인!
                                width: separatorSize * 0.3, // 전구 크기 조절
                                height: separatorSize * 0.3,
                              ),
                            ),
                        ],
                      ),
                      // ⭐️ imageActive일 때만 텍스트 표시
                      if (imageActive) ...[
                        SizedBox(height: 8 * scale),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16 * scale,
                            vertical: 8 * scale,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(20 * scale),
                          ),
                          child: Text(
                            'AI 추천 문제 풀기!',
                            style: aiTextStyle.copyWith(fontSize: 25 * scale),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );

              // Y좌표 갱신: 이미지 버튼 높이 + 텍스트 높이 + 균일 간격
              currentY +=
                  separatorSize +
                  (imageActive ? (8 * scale + 25 * scale) : 0) +
                  uniformGap;
              itemIndex++; // S-curve 인덱스 증가
            }
          }

          // 스크롤 가능한 전체 높이
          final double contentHeight = currentY + 100 * scale; // 하단 여백

          // --- 레이아웃 로직 수정 끝 ---

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              final screenHeight = MediaQuery.of(context).size.height;
              // 수정: 저장된 Y좌표 맵에서 maxCleared 스텝의 Y값을 가져옴
              final targetY = stepTopPositions[maxCleared] ?? (240 * scale);
              final scrollOffset =
                  targetY - (screenHeight / 2) + (diameter / 2);
              _scrollController.jumpTo(
                scrollOffset.clamp(
                  0,
                  _scrollController.position.maxScrollExtent,
                ),
              );
            }
          });

          return SingleChildScrollView(
            controller: _scrollController,
            child: SizedBox(
              width: double.infinity,
              height: contentHeight,
              child: Stack(children: widgets),
            ),
          );
        },
      ),
    );
  }
}
