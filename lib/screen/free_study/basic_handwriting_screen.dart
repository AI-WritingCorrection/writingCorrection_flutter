import 'package:aiwriting_collection/widget/back_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aiwriting_collection/generated/app_localizations.dart';

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
                  _buildSectionTitle(context, AppLocalizations.of(context)!.correctPencilGripTitle, 22 * scale),
                  SizedBox(height: 16 * scale),
                  _buildParagraph(
                    AppLocalizations.of(context)!.correctPencilGripContent,
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
                      AppLocalizations.of(context)!.learnWithVideo,
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
                  _buildSectionTitle(context, AppLocalizations.of(context)!.howAreLettersMadeTitle, 22 * scale),
                  SizedBox(height: 16 * scale),
                  _buildParagraph(
                    AppLocalizations.of(context)!.howAreLettersMadeContent,
                    14 * scale,
                  ),
                  SizedBox(height: 16 * scale),
                  _buildSubSectionTitle(context, AppLocalizations.of(context)!.consonantFriends, 18 * scale),
                  _buildParagraph(
                    AppLocalizations.of(context)!.consonantList,
                    14 * scale,
                  ),
                  SizedBox(height: 16 * scale),
                  _buildSubSectionTitle(context, AppLocalizations.of(context)!.vowelFriends, 18 * scale),
                  _buildParagraph(AppLocalizations.of(context)!.vowelList, 14 * scale),
                ],
              ),
            ),
            _buildTopicBlock(
              scale: scale,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, AppLocalizations.of(context)!.firstStepOfWritingTitle, 22 * scale),
                  SizedBox(height: 16 * scale),
                  _buildParagraph(
                    AppLocalizations.of(context)!.firstStepOfWritingContentPortrait,
                    14 * scale,
                  ),
                  SizedBox(height: 16 * scale),
                  _buildSubSectionTitle(context, AppLocalizations.of(context)!.drawingVariousLines, 18 * scale),
                  _buildParagraph(
                    AppLocalizations.of(context)!.drawingVariousLinesContentPortrait,
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
                  _buildSectionTitle(context, AppLocalizations.of(context)!.correctPencilGripTitle, 28 * scale),
                  SizedBox(height: 20 * scale),
                  _buildParagraph(
                    AppLocalizations.of(context)!.correctPencilGripContent,
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
                      AppLocalizations.of(context)!.learnWithVideo,
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
                  _buildSectionTitle(context, AppLocalizations.of(context)!.howAreLettersMadeTitle, 28 * scale),
                  SizedBox(height: 20 * scale),
                  _buildParagraph(
                    AppLocalizations.of(context)!.howAreLettersMadeContent,
                    18 * scale,
                  ),
                  SizedBox(height: 20 * scale),
                  _buildSubSectionTitle(context, AppLocalizations.of(context)!.consonantFriends, 24 * scale),
                  _buildParagraph(
                    AppLocalizations.of(context)!.consonantList,
                    18 * scale,
                  ),
                  SizedBox(height: 20 * scale),
                  _buildSubSectionTitle(context, AppLocalizations.of(context)!.vowelFriends, 24 * scale),
                  _buildParagraph(AppLocalizations.of(context)!.vowelList, 18 * scale),
                ],
              ),
            ),
            _buildTopicBlock(
              scale: scale,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, AppLocalizations.of(context)!.firstStepOfWritingTitle, 28 * scale),
                  SizedBox(height: 20 * scale),
                  _buildParagraph(
                    AppLocalizations.of(context)!.firstStepOfWritingContentLandscape,
                    18 * scale,
                  ),
                  SizedBox(height: 20 * scale),
                  _buildSubSectionTitle(context, AppLocalizations.of(context)!.drawingVariousLines, 24 * scale),
                  _buildParagraph(
                    AppLocalizations.of(context)!.drawingVariousLinesContentLandscape,
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
