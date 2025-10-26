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
import 'package:aiwriting_collection/widget/mini_dialog.dart';
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
    'assets/character/hamster.png',
    'assets/character/rabbitTeacher.png',
  ];
  @override
  void initState() {
    super.initState();
    // 초기화 작업이 필요하면 여기에 추가
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

    // 첫스텝 시작 y좌표
    final double startY = 220 * scale;

    // S-curve 좌표 생성
    final double diameter = 80 * scale; //지름

    //이미지 버튼 크기
    final double separatorSize = diameter * 1.7;

    final double marginX = 40 * scale; //가로 여백
    final double stepGap = 140 * scale; //스텝들간의 수직 간격

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
          final int numBreaks = (count - 1) ~/ 5;
          final int totalSlots = count + numBreaks;

          final List<Offset> positions = [];
          for (int i = 0; i < totalSlots; i++) {
            double x;
            switch (i % 4) {
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
            double y = startY + i * stepGap;
            positions.add(Offset(x, y));
          }

          // 스크롤 가능한 최대길이
          final double maxDy = positions
              .map((p) => p.dy)
              .reduce((a, b) => a > b ? a : b);
          final double contentHeight = maxDy + diameter + 100 * scale;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              final screenHeight = MediaQuery.of(context).size.height;
              final targetY = positions[maxCleared].dy;
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

          final widgets = <Widget>[];

          // 처음 이미지 버튼은 중간에 배치
          widgets.add(
            Positioned(
              left: (screenSize.width - separatorSize * 0.9) / 2,
              top: 100 * scale,
              child: CharacterButton(
                assetPath: 'assets/character/rabbitTeacher.png',
                size: separatorSize,
                onTap: () {},
              ),
            ),
          );

          //스텝5개 쌓이면 break걸고 이미지버튼추가
          bool insertedChapterBreak = false;
          int stepCounter = 0; // next step number to show

          for (int i = 0; i < positions.length; i++) {
            final pos = positions[i];

            // Insert chapter break after every 5 steps (once)
            if (!insertedChapterBreak &&
                stepCounter > 0 &&
                stepCounter % 5 == 0) {
              final double sepX = pos.dx - (separatorSize - diameter) / 2;
              widgets.add(
                Positioned(
                  left: sepX,
                  top: pos.dy,
                  child: CharacterButton(
                    assetPath: 'assets/character/bearTeacher.png',
                    size: separatorSize,
                    onTap: () {},
                  ),
                ),
              );
              insertedChapterBreak = true;
              continue;
            }

            // Always add the study step
            final currentStep = stepCounter;
            final bool isActive = currentStep < enableUpTo;
            widgets.add(
              Positioned(
                left: pos.dx,
                top: pos.dy,
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
            stepCounter++;

            // Allow next image break after another 5 steps
            if (stepCounter % 5 == 0) {
              insertedChapterBreak = false;
            }
          }

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

    // 첫스텝 시작 y좌표
    final double startY = 240 * scale;

    // S-curve 좌표 생성
    final double diameter = 100 * scale; //지름

    //이미지 버튼 크기
    final double separatorSize = diameter * 1.7 * 1.3;

    final double marginX = 130 * scale; //가로 여백
    final double stepGap = 200 * scale; //스텝들간의 수직 간격

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
          final int numBreaks = (count - 1) ~/ 5;
          final int totalSlots = count + numBreaks;
          int nowImageButtonNum = 0;

          final List<Offset> positions = [];
          for (int i = 0; i < totalSlots; i++) {
            double x;
            switch (i % 4) {
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
            double y = startY + i * stepGap;
            positions.add(Offset(x, y));
          }

          // 스크롤 가능한 최대길이
          final double maxDy = positions
              .map((p) => p.dy)
              .reduce((a, b) => a > b ? a : b);
          final double contentHeight = maxDy + diameter + 100 * scale;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              final screenHeight = MediaQuery.of(context).size.height;
              final targetY = positions[maxCleared].dy;
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

          final widgets = <Widget>[];

          // 처음 이미지 버튼은 중간에 배치
          widgets.add(
            Positioned(
              left: (screenSize.width - separatorSize * 0.9) / 2,
              top: 100 * scale,
              child: CharacterButton(
                assetPath: 'assets/character/rabbitTeacher.png',
                size: separatorSize,
                onTap: () {},
              ),
            ),
          );

          //스텝5개 쌓이면 break걸고 이미지버튼추가
          bool insertedChapterBreak = false;
          int stepCounter = 0; // next step number to show

          for (int i = 0; i < positions.length; i++) {
            final pos = positions[i];
            final bool imageActive = (stepCounter - 1) < enableUpTo;
            // Insert chapter break after every 5 steps (once)
            if (!insertedChapterBreak &&
                stepCounter > 0 &&
                stepCounter % 5 == 0) {
              final int capturedStepId = stepCounter;
              final double sepX = pos.dx - (separatorSize - diameter) / 2;
              final int buttonIndex = stepCounter ~/ 5 - 1;
              widgets.add(
                Positioned(
                  left: sepX,
                  top: pos.dy,
                  child: CharacterButton(
                    assetPath:
                        _characterImages[buttonIndex % _characterImages.length],
                    size: separatorSize,
                    onTap:
                        imageActive
                            ? () async {
                              // --- 🚀 디버깅 코드 1 시작 🚀 ---
                              print('=======================================');
                              print('[디버그 1] 이미지 버튼 탭!');
                              print('버튼 인덱스 (buttonIndex): $buttonIndex');
                              // --- 🚀 디버깅 코드 1 끝 🚀 ---
                              final nowRequest =
                                  generatedRequestList[buttonIndex];
                              final form = nowRequest['form'];

                              // 1. 로딩 다이얼로그 표시
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );

                              try {
                                // 2. API 호출
                                final res = await api.requestAiText(nowRequest);

                                // 3. (중요) 성공 시 로딩 다이얼로그 닫기
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                }

                                // 4. (중요) 모든 성공 로직을 try 블록 안으로 이동
                                final decoded = utf8.decode(res.bodyBytes);
                                final Map<String, dynamic> data = jsonDecode(
                                  decoded,
                                );
                                final String requestedText =
                                    (data['result'] as String) ?? '오류';
                                Steps aiStep = Steps(
                                  stepId: capturedStepId,
                                  stepMission: '밑의 글자를 작성해보세요!',
                                  stepCharacter:
                                      'assets/character/bearTeacher.png',
                                  stepType: WritingType.values.byName(form),
                                  stepText: requestedText,
                                );
                                // --- 🚀 디버깅 코드 2 시작 🚀 ---
                                print(
                                  'WritingPage로 전달하는 aiStep.stepId: ${aiStep.stepId}',
                                );
                                print(
                                  '=======================================',
                                );
                                // --- 🚀 디버깅 코드 2 끝 🚀 ---

                                // 5. (중요) 페이지 이동
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            WritingPage(nowStep: aiStep),
                                  ),
                                );
                                if (mounted) {
                                  setState(() {});
                                }
                              } catch (e) {
                                // 6. (중요) 실패 시 로딩 다이얼로그 닫기
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                }

                                // 7. 실패 시 오류 다이얼로그 표시
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text('오류'),
                                        content: Text('평가 전송 중 오류가 발생했습니다: $e'),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
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
                ),
              );
              insertedChapterBreak = true;
              continue;
            }

            // Always add the study step
            final currentStep = stepCounter;
            final bool isActive = currentStep < enableUpTo;
            widgets.add(
              Positioned(
                left: pos.dx,
                top: pos.dy,
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
            stepCounter++;

            // Allow next image break after another 5 steps
            if (stepCounter % 5 == 0) {
              insertedChapterBreak = false;
            }
          }

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
