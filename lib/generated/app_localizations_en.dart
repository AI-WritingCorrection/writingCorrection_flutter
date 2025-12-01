// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'MyPen';

  @override
  String get loginSubtitle => 'AI Korean Handwriting Learning Service';

  @override
  String get loginWithApple => 'Continue with Apple';

  @override
  String get loginWithGoogle => 'Continue with Google';

  @override
  String get loginWithKakao => 'Continue with Kakao';

  @override
  String get loginAsGuest => 'Continue as Guest';

  @override
  String get termsAndConditions =>
      'By logging in, you agree to the Terms of Service and Privacy Policy.';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get studyTitle => 'Handwriting Practice';

  @override
  String get studyDescription =>
      'Learn how to correctly write consonants, vowels, and sentences step by step.';

  @override
  String get handwritingPostureTitle => 'Handwriting Posture';

  @override
  String get handwritingPostureSubtitle =>
      'Basic posture and tools for good handwriting';

  @override
  String get consonantsAndVowelsTitle => 'Writing Consonants and Vowels';

  @override
  String get consonantsAndVowelsSubtitle =>
      'Practice writing basic letters such as consonants and vowels correctly';

  @override
  String get wordWritingTitle => 'Word Writing';

  @override
  String get wordWritingSubtitle =>
      'Practice writing more complex letters such as double consonants and double final consonants';

  @override
  String get sentenceWritingTitle => 'Sentence Writing';

  @override
  String get sentenceWritingSubtitle =>
      'Practice writing letters clearly in sentence units';

  @override
  String get calligraphyPracticeTitle => 'Calligraphy Practice';

  @override
  String get calligraphyPracticeSubtitle =>
      'Let\'s improve our handwriting through simple calligraphy practice';

  @override
  String get infiniteWritingPracticeTitle => 'Infinite Writing Practice';

  @override
  String get infiniteWritingPracticeSubtitle =>
      'Write as much as you want on the manuscript paper';

  @override
  String get dialogTitleTooSmall => 'Too Small!';

  @override
  String get dialogContentTabletOnly =>
      'Studying is only possible on a tablet!';

  @override
  String get dialogTitleInProgress => 'Under Development';

  @override
  String get dialogContentInProgress =>
      'This feature is under development, please wait a little longer!';

  @override
  String get handwritingBasicsTitle => 'Handwriting Basics';

  @override
  String get handwritingBasicsSubtitle =>
      'Basic posture and concepts for good handwriting';

  @override
  String get myPageTitle => 'My Page';

  @override
  String get profileImageUpdateSuccess => 'Profile image updated successfully.';

  @override
  String get profileImageUpdateFailed => 'Upload failed: ';

  @override
  String get profileUpdateSuccess => 'Profile updated successfully.';

  @override
  String get profileUpdateCancelled => 'Profile update was canceled or failed.';

  @override
  String get logoutFailed => 'Logout failed: ';

  @override
  String get loading => 'Loading...';

  @override
  String get guest => 'Guest';

  @override
  String get ageIsJustANumber => 'Age is just a number for studying!';

  @override
  String get unknownUserType => 'Unknown user type.';

  @override
  String get logout => 'Logout';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get characterIntroductionTitle => 'Character Introduction';

  @override
  String get characterIntroductionSubtitle =>
      'Let me introduce you to the cute animal friends who will help you practice handwriting.';

  @override
  String get gomgomTitle => 'Gomgom';

  @override
  String get gomgomSubtitle => 'Gomgom likes each stroke to be soft as cotton.';

  @override
  String get totoTitle => 'Toto';

  @override
  String get totoSubtitle =>
      'Toto enjoys practicing writing with a cheerful, hopping rhythm.';

  @override
  String get daramTitle => 'Daram';

  @override
  String get daramSubtitle =>
      'Daram meticulously completes the writing as if collecting acorns with a small hand.';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get nickname => 'Nickname';

  @override
  String get birthdate => 'Birthdate: ';

  @override
  String get userType => 'User Type';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get myWritingCalendarTitle => 'My Writing Calendar';

  @override
  String yearMonth(int year, int month) {
    return '$year, $month';
  }

  @override
  String get allPractices => 'All Practices';

  @override
  String get totalPracticeTime => 'Total Practice Time';

  @override
  String get averageScore => 'Average Score';

  @override
  String get scoreUnit => ' pts';

  @override
  String get sessionCount => 'Sessions';

  @override
  String get sessionUnit => '';

  @override
  String get daySun => 'Sun';

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String dailySummary(String totalTime, String avgScore, int count) {
    return 'Total $totalTime • Avg $avgScore pts • $count sessions';
  }

  @override
  String get noPracticeData => 'No practice data for this day.';

  @override
  String practiceSummary(int duration, int score) {
    return 'Practice ${duration}min • $score pts';
  }

  @override
  String get viewDetails => 'View Details (to be connected)';

  @override
  String get myRecordTitle => 'My Records';

  @override
  String get myRecordDescription =>
      'Check out my practice records in various ways!';

  @override
  String get writingScoreStatsTitle => 'Writing Score Statistics';

  @override
  String get writingScoreStatsSubtitle =>
      'Shall we check the writing score I practiced as statistics?';

  @override
  String get myWritingCalendarCardTitle => 'My Own Writing Calendar';

  @override
  String get myWritingCalendarCardSubtitle =>
      'Check the letters you practiced every day on the calendar';

  @override
  String get createPhotocardTitle => 'Create a Writing Photocard';

  @override
  String get createPhotocardSubtitle =>
      'Leave a sentence with a photo to commemorate today';

  @override
  String get chapter1 => '~Easy Letter Practice without Batchim~';

  @override
  String get chapter2 => '~Letter Practice without Batchim~';

  @override
  String get chapter3 => '~Easy Letter Practice with Batchim~';

  @override
  String get chapter4 => '~Letter Practice with Batchim~';

  @override
  String get chapter5 => '~Speed-writing Practice\nwith Batchim~';

  @override
  String get chapter6 => '~Word Practice without Batchim~';

  @override
  String get chapter7 => '~Word Practice with Batchim~';

  @override
  String get chapter8 => '~Additional Word Practice~';

  @override
  String get chapter9 => '~Speed-writing Word Practice~';

  @override
  String get chapter10 => '~Short Sentence Practice~';

  @override
  String get chapter11 => '~Long Sentence Practice~';

  @override
  String get help => 'Help';

  @override
  String get stepActivationRule => 'Step Activation Rule';

  @override
  String get stepActivationRuleDescription =>
      'You must successfully complete the previous step to activate the next step.\nBuild your skills step by step!';

  @override
  String get colorGuide => 'Color Guide';

  @override
  String get colorGuideActive => 'This is the step you can currently learn.';

  @override
  String get colorGuideInactive =>
      'This step is still locked. Please complete the previous step first.';

  @override
  String get imageButtonFunction => 'Image Button Function';

  @override
  String get imageButtonFunctionDescription =>
      'Press the animal teacher button at the end of each chapter to solve a special AI-recommended problem.';

  @override
  String get close => 'Close';

  @override
  String get loadingError => 'Error: ';

  @override
  String get helpButtonText =>
      'Press the help button to\ncheck the learning method!';

  @override
  String get helpButtonTextLandscape =>
      'Let me show you how to practice\nwith MyPen!';

  @override
  String get notification => 'Notification';

  @override
  String get cannotStudyYet => 'You can\'t study yet!';

  @override
  String get aiRecommendation => 'Solve AI-recommended problems!';

  @override
  String get missionText => 'Write the letters below!';

  @override
  String get error => 'Error';

  @override
  String get aiError =>
      'An error occurred while generating AI-recommended problems: ';

  @override
  String get ok => 'OK';

  @override
  String get practiceTask => 'Practice Task';

  @override
  String get startPractice => 'Start Practice!';

  @override
  String get failure => 'Failure😢';

  @override
  String get timeExpired =>
      'Time is over!\nTry to write a little faster next time~';

  @override
  String get tooManyStrokes =>
      'Too many strokes!\nTry to practice with the correct number of strokes.';

  @override
  String get notEnoughStrokes =>
      'Not enough strokes!\nTry to practice with the correct number of strokes.';

  @override
  String evaluationServerConnectionError(int statusCode) {
    return 'Could not connect to the evaluation server. (Code: $statusCode)';
  }

  @override
  String get evaluationSubmissionError =>
      'An error occurred while submitting for evaluation: ';

  @override
  String get penThickness => 'Pen thickness: ';

  @override
  String get eraseOneStroke => 'Erase one stroke';

  @override
  String get eraseAll => 'Erase all';

  @override
  String get submit => 'Submit';

  @override
  String get viewHint => 'View hint';

  @override
  String get targetCharacter => 'Target Character';

  @override
  String get score => 'Score';

  @override
  String get feedback => 'Feedback';

  @override
  String get noFeedback => 'No feedback';

  @override
  String get home => 'Home';

  @override
  String get freeStudy => 'Practice';

  @override
  String get history => 'History';

  @override
  String get myInfo => 'My Info';

  @override
  String get correctPencilGripTitle => 'How to Hold a Pencil Correctly';

  @override
  String get correctPencilGripContent =>
      '1. Gently hold the pencil with your thumb and index finger, and support it with your middle finger.\n2. Tilt the opposite end of the pencil slightly towards your shoulder.\n3. Keep your wrist relaxed and write as if drawing with your entire arm.\n4. Sitting up straight will prevent arm pain and help you write more beautifully.';

  @override
  String get learnWithVideo => 'Learn with Video';

  @override
  String get howAreLettersMadeTitle => 'How are Letters Made?';

  @override
  String get howAreLettersMadeContent =>
      'Hangul letters are formed by combining consonant friends and vowel friends, just like cool robots! When consonants and vowels meet, the letters we know appear with a \'짠!\'';

  @override
  String get consonantFriends => 'Consonant Friends';

  @override
  String get consonantList => 'ㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅅ, ㅇ, ㅈ, ㅊ, ㅋ, ㅌ, ㅍ, ㅎ';

  @override
  String get vowelFriends => 'Vowel Friends';

  @override
  String get vowelList => 'ㅏ, ㅑ, ㅓ, ㅕ, ㅗ, ㅛ, ㅜ, ㅠ, ㅡ, ㅣ';

  @override
  String get firstStepOfWritingTitle =>
      'First Step of Writing: Drawing Lines (Strokes)';

  @override
  String get firstStepOfWritingContentPortrait =>
      'All writing begins with drawing lines. From now on, we\'ll call these lines \'strokes\'. If you can draw neat and pretty lines, you can write any letter well. Shall we play a game of writing by drawing various lines?';

  @override
  String get firstStepOfWritingContentLandscape =>
      'All writing begins with drawing lines. From now on, we\'ll call these lines \'strokes\'. If you can draw neat and pretty lines, you can write any letter well. Shall we play a game of writing by drawing various lines?';

  @override
  String get drawingVariousLines => 'Drawing Various Lines';

  @override
  String get drawingVariousLinesContentPortrait =>
      '1. Horizontal line (-): Straight from left to right! Like riding a slide.\n2. Vertical line (|): Straight from top to bottom! Like a waterfall.\n3. Diagonal line (ㅅ): Wobbly! Making interesting shapes.\n4. Circle (○): Round and round! Let\'s draw a pretty sun.';

  @override
  String get drawingVariousLinesContentLandscape =>
      '1. Horizontal line (-): Straight from left to right! Like riding a slide.\n2. Vertical line (ㅣ): Straight from top to bottom! Like a waterfall.\n3. Diagonal line (ㅅ): Wobbly! Making interesting shapes.\n4. Circle (ㅇ): Round and round! Let\'s draw a pretty sun.';

  @override
  String get takeYourTime => 'Take your time practicing!';

  @override
  String get consonantsAndVowelsDescription =>
      'Hold the shapes of consonants and vowels correctly,\nchoose the consonant or vowel you want to practice, and try writing the letters.';

  @override
  String get consonantsPractice => 'Consonant Practice';

  @override
  String get vowelsPractice => 'Vowel Practice';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get sentenceWritingDescription =>
      'Hold the shapes of consonants and vowels correctly, and maintain consistent size and spacing while writing a sentence you like.';

  @override
  String get shortSentencePractice => 'Short Sentence Practice:';

  @override
  String get longSentencePractice => 'Long Sentence Practice:';

  @override
  String get characterWords => 'Character Words';

  @override
  String get wordWritingDescription =>
      'Hold the shapes of consonants and vowels correctly,\nchoose the words you want to practice, and try writing the letters.';

  @override
  String get wordPractice => 'Word Practice:';

  @override
  String get userTypeChild => 'Child';

  @override
  String get userTypeAdult => 'Adult';

  @override
  String get userTypeForeign => 'Foreigner';

  @override
  String get feedbackDialogInstruction =>
      'Tap on a character to see detailed feedback for each character.';

  @override
  String get feedbackDialogTotalScore => 'Total Score';

  @override
  String get points => 'points';

  @override
  String get feedbackDialogSummary => 'Summary';

  @override
  String get feedbackDialogSummaryStage1 =>
      'Characters with poor AI recognition: ';

  @override
  String get feedbackDialogSummaryStage2 =>
      'Characters with inappropriate size: ';

  @override
  String get feedbackDialogSummaryStage3 =>
      'Characters with inappropriate stroke order: ';

  @override
  String get feedbackDialogSummaryStage4 =>
      'Characters with inappropriate consonants or vowels: ';

  @override
  String get aiwritingMission => 'Write the text below!';
}
