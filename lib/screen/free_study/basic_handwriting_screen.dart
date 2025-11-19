import 'package:aiwriting_collection/widget/back_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BasicHandwritingScreen extends StatelessWidget {
  const BasicHandwritingScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return _buildPortrait(context);
    } else {
      return _buildLandscape(context);
    }
  }

  Widget _buildPortrait(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;
    final double basePortrait = 390.0;
    final double baseLandscape = 844.0;
    final double scale =
        isLandscape
            ? screenSize.height / baseLandscape
            : screenSize.width / basePortrait;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF3),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20 * scale),
            Align(
              alignment: Alignment.centerLeft,
              child: BackButtonWidget(scale: 0.8 * scale),
            ),
            SizedBox(height: 20 * scale),
            _buildTopicBlock(
              scale: scale,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, '연필 바르게 잡는 법', 22 * scale),
                  SizedBox(height: 16 * scale),
                  _buildParagraph(
                    '1. 엄지와 검지 손가락으로 연필을 살짝 잡고, 가운데 손가락으로 연필을 받쳐보세요.\n'
                    '2. 연필의 뾰족한 반대쪽 끝이 어깨를 향하게 살짝 눕혀주세요.\n'
                    '3. 손목은 편안하게 두고, 팔 전체로 그림을 그리듯 글씨를 써봐요.\n'
                    '4. 허리를 꼿꼿하게 펴고 앉으면 팔이 아프지 않고 글씨를 더 예쁘게 쓸 수 있어요.',
                    14 * scale,
                  ),
                  SizedBox(height: 16 * scale),
                  ElevatedButton.icon(
                    onPressed:
                        () => _launchURL(
                          'https://www.youtube.com/watch?v=gvIfVisKB0o',
                        ),
                    icon: Icon(Icons.play_circle_fill, size: 20 * scale),
                    label: Text(
                      '영상으로 배우기',
                      style: TextStyle(fontSize: 14 * scale),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8 * scale),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildTopicBlock(
              scale: scale,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, '글자는 어떻게 만들어질까?', 22 * scale),
                  SizedBox(height: 16 * scale),
                  _buildParagraph(
                    '한글은 멋진 로봇처럼 자음 친구와 모음 친구가 합체해서 만들어져요! 자음과 모음이 만나면 우리가 아는 글자가 짠! 하고 나타난답니다.',
                    14 * scale,
                  ),
                  SizedBox(height: 16 * scale),
                  _buildSubSectionTitle(context, '자음 친구들', 18 * scale),
                  _buildParagraph(
                    'ㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅅ, ㅇ, ㅈ, ㅊ, ㅋ, ㅌ, ㅍ, ㅎ',
                    14 * scale,
                  ),
                  SizedBox(height: 16 * scale),
                  _buildSubSectionTitle(context, '모음 친구들', 18 * scale),
                  _buildParagraph('ㅏ, ㅑ, ㅓ, ㅕ, ㅗ, ㅛ, ㅜ, ㅠ, ㅡ, ㅣ', 14 * scale),
                ],
              ),
            ),
            _buildTopicBlock(
              scale: scale,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, '글씨의 첫걸음: 선 긋기(획)', 22 * scale),
                  SizedBox(height: 16 * scale),
                  _buildParagraph(
                    '모든 글씨는 선을 그리는 것에서 시작해요. 앞으로는 이 선을 \'획\'이라고 부를거예요.반듯반듯 예쁜 선을 그릴 수 있으면 어떤 글씨든 잘 쓸 수 있답니다. 여러 가지 선을 그리면서 글씨 쓰기 놀이를 해볼까요?',
                    14 * scale,
                  ),
                  SizedBox(height: 16 * scale),
                  _buildSubSectionTitle(context, '여러 가지 선 그리기', 18 * scale),
                  _buildParagraph(
                    '1. 가로선(-): 왼쪽에서 오른쪽으로 쭉! 미끄럼틀을 타요.\n'
                    '2. 세로선(|): 위에서 아래로 쭉! 폭포수가 떨어져요.\n'
                    '3. 대각선(ㅅ): 삐뚤빼뚤! 재미있는 모양을 만들어요.\n'
                    '4. 동그라미(○): 동글동글! 예쁜 해님을 그려봐요.',
                    14 * scale,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscape(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;
    final double basePortrait = 390.0;
    final double baseLandscape = 844.0;
    final double scale =
        isLandscape
            ? screenSize.height / baseLandscape
            : screenSize.width / basePortrait;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF3),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 50.0 * scale,
          vertical: 24.0 * scale,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: BackButtonWidget(scale: 1),
            ),
            SizedBox(height: 20 * scale),
            _buildTopicBlock(
              scale: scale,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, '연필 바르게 잡는 법', 28 * scale),
                  SizedBox(height: 20 * scale),
                  _buildParagraph(
                    '1. 엄지와 검지 손가락으로 연필을 살짝 잡고, 가운데 손가락으로 연필을 받쳐보세요.\n'
                    '2. 연필의 뾰족한 반대쪽 끝이 어깨를 향하게 살짝 눕혀주세요.\n'
                    '3. 손목은 편안하게 두고, 팔 전체로 그림을 그리듯 글씨를 써봐요.\n'
                    '4. 허리를 꼿꼿하게 펴고 앉으면 팔이 아프지 않고 글씨를 더 예쁘게 쓸 수 있어요.',
                    18 * scale,
                  ),
                  SizedBox(height: 20 * scale),
                  ElevatedButton.icon(
                    onPressed:
                        () => _launchURL(
                          'https://www.youtube.com/watch?v=gvIfVisKB0o',
                        ),
                    icon: Icon(Icons.play_circle_fill, size: 24 * scale),
                    label: Text(
                      '영상으로 배우기',
                      style: TextStyle(fontSize: 18 * scale),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20 * scale,
                        vertical: 12 * scale,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8 * scale),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildTopicBlock(
              scale: scale,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, '글자는 어떻게 만들어질까?', 28 * scale),
                  SizedBox(height: 20 * scale),
                  _buildParagraph(
                    '한글은 멋진 로봇처럼 자음 친구와 모음 친구가 합체해서 만들어져요! 자음과 모음이 만나면 우리가 아는 글자가 짠! 하고 나타난답니다.',
                    18 * scale,
                  ),
                  SizedBox(height: 20 * scale),
                  _buildSubSectionTitle(context, '자음 친구들', 24 * scale),
                  _buildParagraph(
                    'ㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅅ, ㅇ, ㅈ, ㅊ, ㅋ, ㅌ, ㅍ, ㅎ',
                    18 * scale,
                  ),
                  SizedBox(height: 20 * scale),
                  _buildSubSectionTitle(context, '모음 친구들', 24 * scale),
                  _buildParagraph('ㅏ, ㅑ, ㅓ, ㅕ, ㅗ, ㅛ, ㅜ, ㅠ, ㅡ, ㅣ', 18 * scale),
                ],
              ),
            ),
            _buildTopicBlock(
              scale: scale,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, '글씨의 첫걸음: 선 긋기(획)', 28 * scale),
                  SizedBox(height: 20 * scale),
                  _buildParagraph(
                    '모든 글씨는 선을 그리는 것에서 시작해요. 앞으로는 이 선을 \'획\'이라고 부를거예요. 반듯반듯 예쁜 선을 그릴 수 있으면 어떤 글씨든 잘 쓸 수 있답니다. 여러 가지 선을 그리면서 글씨 쓰기 놀이를 해볼까요?',
                    18 * scale,
                  ),
                  SizedBox(height: 20 * scale),
                  _buildSubSectionTitle(context, '여러 가지 선 그리기', 24 * scale),
                  _buildParagraph(
                    '1. 가로선(-): 왼쪽에서 오른쪽으로 쭉! 미끄럼틀을 타요.\n'
                    '2. 세로선(ㅣ): 위에서 아래로 쭉! 폭포수가 떨어져요.\n'
                    '3. 대각선(ㅅ): 삐뚤빼뚤! 재미있는 모양을 만들어요.\n'
                    '4. 동그라미(ㅇ): 동글동글! 예쁜 해님을 그려봐요.',
                    18 * scale,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicBlock({required Widget child, required double scale}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16 * scale),
      padding: EdgeInsets.all(20 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    double fontSize,
  ) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.green[800],
      ),
    );
  }

  Widget _buildSubSectionTitle(
    BuildContext context,
    String title,
    double fontSize,
  ) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildParagraph(String text, double fontSize) {
    return Text(text, style: TextStyle(fontSize: fontSize, height: 1.6));
  }
}
