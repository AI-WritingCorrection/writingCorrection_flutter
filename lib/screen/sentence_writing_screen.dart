import 'package:flutter/material.dart';
import 'package:aiwriting_collection/widget/back_button.dart';
import 'package:aiwriting_collection/widget/practice_card.dart';

class SentenceWritingScreen extends StatelessWidget {
  const SentenceWritingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = size.height / 844.0;

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1) 헤더 영역: 원고지 + 백 버튼 + 타이틀
            SizedBox(
              height: 180 * scale,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/image/letter.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16 * scale,
                      vertical: 16 * scale,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 여백을 추가한 백버튼
                          Padding(
                            padding: EdgeInsets.all(8 * scale),
                            child: BackButtonWidget(scale: scale),
                          ),
                          SizedBox(width: 8 * scale),
                          Text(
                            '문장 쓰기',
                            style: TextStyle(
                              fontSize: 33 * scale,
                              fontFamily: 'Maruburi',
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2) 설명 텍스트
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 32 * scale,
                vertical: 24 * scale,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '자음과 모음의 모양을 올바르게 잡고 글씨의 크기와 간격을 일정하게 맞춰\n내 마음에 드는 글을 써보세요.',
                  style: TextStyle(
                    fontSize: 18 * scale,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),

            // 3) 짧은 문장 연습 섹션
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32 * scale),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '짧은 문장 연습:',
                  style: TextStyle(
                    fontSize: 20 * scale,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8 * scale),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16 * scale),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16 * scale,
                mainAxisSpacing: 16 * scale,
                childAspectRatio: 3,
                children: [
                  PracticeCard(
                    title: '내가 마음에 드는 글을 예쁜 글씨체로 쓰고 싶다.',
                    subtitle: '',
                    imagePath: 'assets/character/bearTeacher.png',
                    onTap: () {},
                  ),
                  PracticeCard(
                    title: '때로는 질문은 복잡하지만 해답은 간단할 수도 있다.',
                    subtitle: '',
                    imagePath: 'assets/character/rabbitTeacher.png',
                    onTap: () {},
                  ),
                  PracticeCard(
                    title: '항상 변화한다는 사실만 변하지 않을 뿐이다.',
                    subtitle: '',
                    imagePath: 'assets/character/hamster.png',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: 24 * scale),

            // 4) 긴 문장 연습 섹션
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32 * scale),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '긴 문장 연습:',
                  style: TextStyle(
                    fontSize: 20 * scale,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8 * scale),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16 * scale),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16 * scale,
                mainAxisSpacing: 16 * scale,
                childAspectRatio: 3,
                children: [
                  PracticeCard(
                    title: '난 가끔 낮보다 밤이 더 활기 넘치고 풍부한 색감을 가지고 있다고 생각한다.',
                    subtitle: '',
                    imagePath: 'assets/character/bearTeacher.png',
                    onTap: () {},
                  ),
                  PracticeCard(
                    title: '결국 모든 것은 괜찮아질 것이다, 만약 그렇지 않다면, 끝이 아니다.',
                    subtitle: '',
                    imagePath: 'assets/character/rabbitTeacher.png',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: 80 * scale),
          ],
        ),
      ),
    );
  }
}
