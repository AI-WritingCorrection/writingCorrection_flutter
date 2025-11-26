import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// No description provided for @loginTitle.
  ///
  /// In ko, this message translates to:
  /// **'손글손글'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'AI 한글 손글씨 학습 서비스'**
  String get loginSubtitle;

  /// No description provided for @loginWithApple.
  ///
  /// In ko, this message translates to:
  /// **'Apple로 계속하기'**
  String get loginWithApple;

  /// No description provided for @loginWithGoogle.
  ///
  /// In ko, this message translates to:
  /// **'Google로 계속하기'**
  String get loginWithGoogle;

  /// No description provided for @loginWithKakao.
  ///
  /// In ko, this message translates to:
  /// **'카카오로 계속하기'**
  String get loginWithKakao;

  /// No description provided for @loginAsGuest.
  ///
  /// In ko, this message translates to:
  /// **'게스트로 먼저 체험'**
  String get loginAsGuest;

  /// No description provided for @termsAndConditions.
  ///
  /// In ko, this message translates to:
  /// **'로그인 시 이용약관 및 개인정보처리방침에 동의합니다.'**
  String get termsAndConditions;

  /// No description provided for @termsOfService.
  ///
  /// In ko, this message translates to:
  /// **'이용약관'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보처리방침'**
  String get privacyPolicy;

  /// No description provided for @studyTitle.
  ///
  /// In ko, this message translates to:
  /// **'손글씨 연습'**
  String get studyTitle;

  /// No description provided for @studyDescription.
  ///
  /// In ko, this message translates to:
  /// **'자음, 모음, 받침, 문장들을 올바르게 쓰는 연습법을 차근차근 알려드립니다.'**
  String get studyDescription;

  /// No description provided for @handwritingPostureTitle.
  ///
  /// In ko, this message translates to:
  /// **'손글씨 자세'**
  String get handwritingPostureTitle;

  /// No description provided for @handwritingPostureSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'손글씨를 잘 쓰기 위한 기본 자세와 도구'**
  String get handwritingPostureSubtitle;

  /// No description provided for @consonantsAndVowelsTitle.
  ///
  /// In ko, this message translates to:
  /// **'자음과 모음 쓰기'**
  String get consonantsAndVowelsTitle;

  /// No description provided for @consonantsAndVowelsSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'자음, 모음 등 기본 글자를 바르게 쓰는 연습'**
  String get consonantsAndVowelsSubtitle;

  /// No description provided for @wordWritingTitle.
  ///
  /// In ko, this message translates to:
  /// **'단어 쓰기'**
  String get wordWritingTitle;

  /// No description provided for @wordWritingSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'쌍자음, 겹받침 등 조금 더 복잡한 글자 연습'**
  String get wordWritingSubtitle;

  /// No description provided for @sentenceWritingTitle.
  ///
  /// In ko, this message translates to:
  /// **'문장 쓰기'**
  String get sentenceWritingTitle;

  /// No description provided for @sentenceWritingSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'문장 단위로 글씨를 또박또박 쓰는 연습'**
  String get sentenceWritingSubtitle;

  /// No description provided for @calligraphyPracticeTitle.
  ///
  /// In ko, this message translates to:
  /// **'캘리그라피 연습'**
  String get calligraphyPracticeTitle;

  /// No description provided for @calligraphyPracticeSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'간단한 캘리그라피 연습을 통해 글씨체를 살려봐요'**
  String get calligraphyPracticeSubtitle;

  /// No description provided for @infiniteWritingPracticeTitle.
  ///
  /// In ko, this message translates to:
  /// **'무한 글씨 연습'**
  String get infiniteWritingPracticeTitle;

  /// No description provided for @infiniteWritingPracticeSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'원하는 만큼 원고지에 글씨를 적어보세요'**
  String get infiniteWritingPracticeSubtitle;

  /// No description provided for @dialogTitleTooSmall.
  ///
  /// In ko, this message translates to:
  /// **'너무 작아!'**
  String get dialogTitleTooSmall;

  /// No description provided for @dialogContentTabletOnly.
  ///
  /// In ko, this message translates to:
  /// **'공부는 태블릿에서만 가능합니다!'**
  String get dialogContentTabletOnly;

  /// No description provided for @dialogTitleInProgress.
  ///
  /// In ko, this message translates to:
  /// **'개발 진행중'**
  String get dialogTitleInProgress;

  /// No description provided for @dialogContentInProgress.
  ///
  /// In ko, this message translates to:
  /// **'해당 기능은 개발중이니 조금만 기다려주세요!'**
  String get dialogContentInProgress;

  /// No description provided for @handwritingBasicsTitle.
  ///
  /// In ko, this message translates to:
  /// **'손글씨 기초'**
  String get handwritingBasicsTitle;

  /// No description provided for @handwritingBasicsSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'손글씨를 잘 쓰기 위한 기본 자세와 개념'**
  String get handwritingBasicsSubtitle;

  /// No description provided for @myPageTitle.
  ///
  /// In ko, this message translates to:
  /// **'내 정보'**
  String get myPageTitle;

  /// No description provided for @profileImageUpdateSuccess.
  ///
  /// In ko, this message translates to:
  /// **'프로필 이미지가 업데이트되었습니다.'**
  String get profileImageUpdateSuccess;

  /// No description provided for @profileImageUpdateFailed.
  ///
  /// In ko, this message translates to:
  /// **'업로드 실패: '**
  String get profileImageUpdateFailed;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In ko, this message translates to:
  /// **'프로필이 업데이트되었습니다.'**
  String get profileUpdateSuccess;

  /// No description provided for @profileUpdateCancelled.
  ///
  /// In ko, this message translates to:
  /// **'프로필 업데이트가 취소되었거나 실패했습니다.'**
  String get profileUpdateCancelled;

  /// No description provided for @logoutFailed.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃 실패: '**
  String get logoutFailed;

  /// No description provided for @loading.
  ///
  /// In ko, this message translates to:
  /// **'불러오는 중...'**
  String get loading;

  /// No description provided for @guest.
  ///
  /// In ko, this message translates to:
  /// **'게스트'**
  String get guest;

  /// No description provided for @ageIsJustANumber.
  ///
  /// In ko, this message translates to:
  /// **'나이는 공부에 상관없죠!'**
  String get ageIsJustANumber;

  /// No description provided for @unknownUserType.
  ///
  /// In ko, this message translates to:
  /// **'회원 유형을 알 수 없어요.'**
  String get unknownUserType;

  /// No description provided for @logout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get logout;

  /// No description provided for @editProfile.
  ///
  /// In ko, this message translates to:
  /// **'회원정보수정'**
  String get editProfile;

  /// No description provided for @characterIntroductionTitle.
  ///
  /// In ko, this message translates to:
  /// **'캐릭터 소개'**
  String get characterIntroductionTitle;

  /// No description provided for @characterIntroductionSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'손글씨 연습을 도와줄 귀여운 동물 친구들을 소개할게요.'**
  String get characterIntroductionSubtitle;

  /// No description provided for @gomgomTitle.
  ///
  /// In ko, this message translates to:
  /// **'곰곰'**
  String get gomgomTitle;

  /// No description provided for @gomgomSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'곰곰이는 부드러운 솜결 같은 한 획 한 획을 좋아해요.'**
  String get gomgomSubtitle;

  /// No description provided for @totoTitle.
  ///
  /// In ko, this message translates to:
  /// **'토토'**
  String get totoTitle;

  /// No description provided for @totoSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'토토는 껑충껑충 경쾌한 리듬으로 글씨 연습을 즐겨요.'**
  String get totoSubtitle;

  /// No description provided for @daramTitle.
  ///
  /// In ko, this message translates to:
  /// **'다람'**
  String get daramTitle;

  /// No description provided for @daramSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'다람이는 작은 손으로 도토리를 모으듯 꼼꼼하게 글씨를 완성시켜 준답니다.'**
  String get daramSubtitle;

  /// No description provided for @editProfileTitle.
  ///
  /// In ko, this message translates to:
  /// **'회원 정보 수정'**
  String get editProfileTitle;

  /// No description provided for @nickname.
  ///
  /// In ko, this message translates to:
  /// **'닉네임'**
  String get nickname;

  /// No description provided for @birthdate.
  ///
  /// In ko, this message translates to:
  /// **'생년월일: '**
  String get birthdate;

  /// No description provided for @userType.
  ///
  /// In ko, this message translates to:
  /// **'사용자 유형'**
  String get userType;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// No description provided for @myWritingCalendarTitle.
  ///
  /// In ko, this message translates to:
  /// **'나만의 글씨 달력'**
  String get myWritingCalendarTitle;

  /// No description provided for @yearMonth.
  ///
  /// In ko, this message translates to:
  /// **'{year}년 {month}월'**
  String yearMonth(int year, int month);

  /// No description provided for @allPractices.
  ///
  /// In ko, this message translates to:
  /// **'모든 연습'**
  String get allPractices;

  /// No description provided for @totalPracticeTime.
  ///
  /// In ko, this message translates to:
  /// **'총 연습시간'**
  String get totalPracticeTime;

  /// No description provided for @averageScore.
  ///
  /// In ko, this message translates to:
  /// **'평균 점수'**
  String get averageScore;

  /// No description provided for @scoreUnit.
  ///
  /// In ko, this message translates to:
  /// **'점'**
  String get scoreUnit;

  /// No description provided for @sessionCount.
  ///
  /// In ko, this message translates to:
  /// **'세션 수'**
  String get sessionCount;

  /// No description provided for @sessionUnit.
  ///
  /// In ko, this message translates to:
  /// **'회'**
  String get sessionUnit;

  /// No description provided for @daySun.
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get daySun;

  /// No description provided for @dayMon.
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In ko, this message translates to:
  /// **'화'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In ko, this message translates to:
  /// **'수'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In ko, this message translates to:
  /// **'목'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In ko, this message translates to:
  /// **'금'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In ko, this message translates to:
  /// **'토'**
  String get daySat;

  /// No description provided for @dailySummary.
  ///
  /// In ko, this message translates to:
  /// **'총 {totalTime} • 평균 {avgScore}점 • {count}회'**
  String dailySummary(String totalTime, String avgScore, int count);

  /// No description provided for @noPracticeData.
  ///
  /// In ko, this message translates to:
  /// **'이 날의 연습 기록이 없어요.'**
  String get noPracticeData;

  /// No description provided for @practiceSummary.
  ///
  /// In ko, this message translates to:
  /// **'연습 {duration}분 • {score}점'**
  String practiceSummary(int duration, int score);

  /// No description provided for @viewDetails.
  ///
  /// In ko, this message translates to:
  /// **'상세 보기(추후 연결)'**
  String get viewDetails;

  /// No description provided for @myRecordTitle.
  ///
  /// In ko, this message translates to:
  /// **'나의 기록'**
  String get myRecordTitle;

  /// No description provided for @myRecordDescription.
  ///
  /// In ko, this message translates to:
  /// **'나의 연습 기록들을 다양한 방법으로 확인해보세요!'**
  String get myRecordDescription;

  /// No description provided for @writingScoreStatsTitle.
  ///
  /// In ko, this message translates to:
  /// **'글씨 점수 통계'**
  String get writingScoreStatsTitle;

  /// No description provided for @writingScoreStatsSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'내가 연습한 글씨 점수를 통계로 확인해볼까요?'**
  String get writingScoreStatsSubtitle;

  /// No description provided for @myWritingCalendarCardTitle.
  ///
  /// In ko, this message translates to:
  /// **'나만의 글씨 달력'**
  String get myWritingCalendarCardTitle;

  /// No description provided for @myWritingCalendarCardSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'하루하루마다 연습한 글씨를 달력으로 확인해보세요'**
  String get myWritingCalendarCardSubtitle;

  /// No description provided for @createPhotocardTitle.
  ///
  /// In ko, this message translates to:
  /// **'글씨 포토카트 만들기'**
  String get createPhotocardTitle;

  /// No description provided for @createPhotocardSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'오늘을 기념하는 사진과 함께 문장 하나를 남겨보세요'**
  String get createPhotocardSubtitle;

  /// No description provided for @chapter1.
  ///
  /// In ko, this message translates to:
  /// **'~받침 없는 쉬운 글자 연습~'**
  String get chapter1;

  /// No description provided for @chapter2.
  ///
  /// In ko, this message translates to:
  /// **'~받침 없는 글자 연습~'**
  String get chapter2;

  /// No description provided for @chapter3.
  ///
  /// In ko, this message translates to:
  /// **'~받침 있는 쉬운 글자 연습~'**
  String get chapter3;

  /// No description provided for @chapter4.
  ///
  /// In ko, this message translates to:
  /// **'~받침 있는 글자 연습~'**
  String get chapter4;

  /// No description provided for @chapter5.
  ///
  /// In ko, this message translates to:
  /// **'~받침 있는 글자\n 빠르게 써보기~'**
  String get chapter5;

  /// No description provided for @chapter6.
  ///
  /// In ko, this message translates to:
  /// **'~받침 없는 낱말 연습~'**
  String get chapter6;

  /// No description provided for @chapter7.
  ///
  /// In ko, this message translates to:
  /// **'~받침 있는 낱말 연습~'**
  String get chapter7;

  /// No description provided for @chapter8.
  ///
  /// In ko, this message translates to:
  /// **'~낱말 추가 연습~'**
  String get chapter8;

  /// No description provided for @chapter9.
  ///
  /// In ko, this message translates to:
  /// **'~낱말을 빠르게 써보기~'**
  String get chapter9;

  /// No description provided for @chapter10.
  ///
  /// In ko, this message translates to:
  /// **'~짧은 문장 연습~'**
  String get chapter10;

  /// No description provided for @chapter11.
  ///
  /// In ko, this message translates to:
  /// **'~긴 문장 연습~'**
  String get chapter11;

  /// No description provided for @help.
  ///
  /// In ko, this message translates to:
  /// **'도움말'**
  String get help;

  /// No description provided for @stepActivationRule.
  ///
  /// In ko, this message translates to:
  /// **'스텝 활성화 규칙'**
  String get stepActivationRule;

  /// No description provided for @stepActivationRuleDescription.
  ///
  /// In ko, this message translates to:
  /// **'이전 단계를 성공적으로 완료해야 다음 단계가 활성화됩니다.\n차근차근 단계를 밟아가며 실력을 키워보세요!'**
  String get stepActivationRuleDescription;

  /// No description provided for @colorGuide.
  ///
  /// In ko, this message translates to:
  /// **'색상 안내'**
  String get colorGuide;

  /// No description provided for @colorGuideActive.
  ///
  /// In ko, this message translates to:
  /// **'현재 학습할 수 있는 단계입니다.'**
  String get colorGuideActive;

  /// No description provided for @colorGuideInactive.
  ///
  /// In ko, this message translates to:
  /// **'아직 잠겨있는 단계입니다. 이전 단계를 먼저 완료해주세요.'**
  String get colorGuideInactive;

  /// No description provided for @imageButtonFunction.
  ///
  /// In ko, this message translates to:
  /// **'이미지 버튼 기능'**
  String get imageButtonFunction;

  /// No description provided for @imageButtonFunctionDescription.
  ///
  /// In ko, this message translates to:
  /// **'각 챕터의 마지막에 있는 동물 선생님 버튼을 누르면, 특별한 AI 추천 문제를 풀어볼 수 있습니다.'**
  String get imageButtonFunctionDescription;

  /// No description provided for @close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// No description provided for @loadingError.
  ///
  /// In ko, this message translates to:
  /// **'에러: '**
  String get loadingError;

  /// No description provided for @helpButtonText.
  ///
  /// In ko, this message translates to:
  /// **'도움말 버튼을 눌러\n학습 방법을 확인하세요!'**
  String get helpButtonText;

  /// No description provided for @helpButtonTextLandscape.
  ///
  /// In ko, this message translates to:
  /// **'어떻게 손글손글을 통해\n 연습하는지 알려드릴게요!'**
  String get helpButtonTextLandscape;

  /// No description provided for @notification.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notification;

  /// No description provided for @cannotStudyYet.
  ///
  /// In ko, this message translates to:
  /// **'아직 공부할 수 없어요!'**
  String get cannotStudyYet;

  /// No description provided for @aiRecommendation.
  ///
  /// In ko, this message translates to:
  /// **'AI 추천 문제 풀기!'**
  String get aiRecommendation;

  /// No description provided for @missionText.
  ///
  /// In ko, this message translates to:
  /// **'밑의 글자를 작성해보세요!'**
  String get missionText;

  /// No description provided for @error.
  ///
  /// In ko, this message translates to:
  /// **'오류'**
  String get error;

  /// No description provided for @aiError.
  ///
  /// In ko, this message translates to:
  /// **'AI 추천 문제 생성 중 오류가 발생했습니다: '**
  String get aiError;

  /// No description provided for @ok.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get ok;

  /// No description provided for @practiceTask.
  ///
  /// In ko, this message translates to:
  /// **'연습 과제'**
  String get practiceTask;

  /// No description provided for @startPractice.
  ///
  /// In ko, this message translates to:
  /// **'연습 시작!'**
  String get startPractice;

  /// No description provided for @failure.
  ///
  /// In ko, this message translates to:
  /// **'실패😢'**
  String get failure;

  /// No description provided for @timeExpired.
  ///
  /// In ko, this message translates to:
  /// **'시간이 초과되었어요!\n다음에는 조금 더 빨리 써봐요~'**
  String get timeExpired;

  /// No description provided for @tooManyStrokes.
  ///
  /// In ko, this message translates to:
  /// **'획이 너무 많아요!\n획 수를 맞춰서 연습해보세요.'**
  String get tooManyStrokes;

  /// No description provided for @notEnoughStrokes.
  ///
  /// In ko, this message translates to:
  /// **'획이 부족해요!\n획 수를 맞춰서 연습해보세요.'**
  String get notEnoughStrokes;

  /// No description provided for @evaluationServerConnectionError.
  ///
  /// In ko, this message translates to:
  /// **'평가 서버에 접속할 수 없습니다. (코드: {statusCode})'**
  String evaluationServerConnectionError(int statusCode);

  /// No description provided for @evaluationSubmissionError.
  ///
  /// In ko, this message translates to:
  /// **'평가 전송 중 오류가 발생했습니다: '**
  String get evaluationSubmissionError;

  /// No description provided for @penThickness.
  ///
  /// In ko, this message translates to:
  /// **'펜 굵기: '**
  String get penThickness;

  /// No description provided for @eraseOneStroke.
  ///
  /// In ko, this message translates to:
  /// **'한 획 지우기'**
  String get eraseOneStroke;

  /// No description provided for @eraseAll.
  ///
  /// In ko, this message translates to:
  /// **'글씨 지우기'**
  String get eraseAll;

  /// No description provided for @submit.
  ///
  /// In ko, this message translates to:
  /// **'제출'**
  String get submit;

  /// No description provided for @viewHint.
  ///
  /// In ko, this message translates to:
  /// **'도움말 보기'**
  String get viewHint;

  /// No description provided for @targetCharacter.
  ///
  /// In ko, this message translates to:
  /// **'대상 글자'**
  String get targetCharacter;

  /// No description provided for @score.
  ///
  /// In ko, this message translates to:
  /// **'점수'**
  String get score;

  /// No description provided for @feedback.
  ///
  /// In ko, this message translates to:
  /// **'피드백'**
  String get feedback;

  /// No description provided for @noFeedback.
  ///
  /// In ko, this message translates to:
  /// **'피드백 없음'**
  String get noFeedback;

  /// No description provided for @home.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get home;

  /// No description provided for @freeStudy.
  ///
  /// In ko, this message translates to:
  /// **'자유 공부'**
  String get freeStudy;

  /// No description provided for @history.
  ///
  /// In ko, this message translates to:
  /// **'기록'**
  String get history;

  /// No description provided for @myInfo.
  ///
  /// In ko, this message translates to:
  /// **'내 정보'**
  String get myInfo;

  /// No description provided for @correctPencilGripTitle.
  ///
  /// In ko, this message translates to:
  /// **'연필 바르게 잡는 법'**
  String get correctPencilGripTitle;

  /// No description provided for @correctPencilGripContent.
  ///
  /// In ko, this message translates to:
  /// **'1. 엄지와 검지 손가락으로 연필을 살짝 잡고, 가운데 손가락으로 연필을 받쳐보세요.\n2. 연필의 뾰족한 반대쪽 끝이 어깨를 향하게 살짝 눕혀주세요.\n3. 손목은 편안하게 두고, 팔 전체로 그림을 그리듯 글씨를 써봐요.\n4. 허리를 꼿꼿하게 펴고 앉으면 팔이 아프지 않고 글씨를 더 예쁘게 쓸 수 있어요.'**
  String get correctPencilGripContent;

  /// No description provided for @learnWithVideo.
  ///
  /// In ko, this message translates to:
  /// **'영상으로 배우기'**
  String get learnWithVideo;

  /// No description provided for @howAreLettersMadeTitle.
  ///
  /// In ko, this message translates to:
  /// **'글자는 어떻게 만들어질까?'**
  String get howAreLettersMadeTitle;

  /// No description provided for @howAreLettersMadeContent.
  ///
  /// In ko, this message translates to:
  /// **'한글은 멋진 로봇처럼 자음 친구와 모음 친구가 합체해서 만들어져요! 자음과 모음이 만나면 우리가 아는 글자가 짠! 하고 나타난답니다.'**
  String get howAreLettersMadeContent;

  /// No description provided for @consonantFriends.
  ///
  /// In ko, this message translates to:
  /// **'자음 친구들'**
  String get consonantFriends;

  /// No description provided for @consonantList.
  ///
  /// In ko, this message translates to:
  /// **'ㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅅ, ㅇ, ㅈ, ㅊ, ㅋ, ㅌ, ㅍ, ㅎ'**
  String get consonantList;

  /// No description provided for @vowelFriends.
  ///
  /// In ko, this message translates to:
  /// **'모음 친구들'**
  String get vowelFriends;

  /// No description provided for @vowelList.
  ///
  /// In ko, this message translates to:
  /// **'ㅏ, ㅑ, ㅓ, ㅕ, ㅗ, ㅛ, ㅜ, ㅠ, ㅡ, ㅣ'**
  String get vowelList;

  /// No description provided for @firstStepOfWritingTitle.
  ///
  /// In ko, this message translates to:
  /// **'글씨의 첫걸음: 선 긋기(획)'**
  String get firstStepOfWritingTitle;

  /// No description provided for @firstStepOfWritingContentPortrait.
  ///
  /// In ko, this message translates to:
  /// **'모든 글씨는 선을 그리는 것에서 시작해요. 앞으로는 이 선을 \'획\'이라고 부를거예요.반듯반듯 예쁜 선을 그릴 수 있으면 어떤 글씨든 잘 쓸 수 있답니다. 여러 가지 선을 그리면서 글씨 쓰기 놀이를 해볼까요?'**
  String get firstStepOfWritingContentPortrait;

  /// No description provided for @firstStepOfWritingContentLandscape.
  ///
  /// In ko, this message translates to:
  /// **'모든 글씨는 선을 그리는 것에서 시작해요. 앞으로는 이 선을 \'획\'이라고 부를거예요. 반듯반듯 예쁜 선을 그릴 수 있으면 어떤 글씨든 잘 쓸 수 있답니다. 여러 가지 선을 그리면서 글씨 쓰기 놀이를 해볼까요?'**
  String get firstStepOfWritingContentLandscape;

  /// No description provided for @drawingVariousLines.
  ///
  /// In ko, this message translates to:
  /// **'여러 가지 선 그리기'**
  String get drawingVariousLines;

  /// No description provided for @drawingVariousLinesContentPortrait.
  ///
  /// In ko, this message translates to:
  /// **'1. 가로선(-): 왼쪽에서 오른쪽으로 쭉! 미끄럼틀을 타요.\n2. 세로선(|): 위에서 아래로 쭉! 폭포수가 떨어져요.\n3. 대각선(ㅅ): 삐뚤빼뚤! 재미있는 모양을 만들어요.\n4. 동그라미(○): 동글동글! 예쁜 해님을 그려봐요.'**
  String get drawingVariousLinesContentPortrait;

  /// No description provided for @drawingVariousLinesContentLandscape.
  ///
  /// In ko, this message translates to:
  /// **'1. 가로선(-): 왼쪽에서 오른쪽으로 쭉! 미끄럼틀을 타요.\n2. 세로선(ㅣ): 위에서 아래로 쭉! 폭포수가 떨어져요.\n3. 대각선(ㅅ): 삐뚤빼뚤! 재미있는 모양을 만들어요.\n4. 동그라미(ㅇ): 동글동글! 예쁜 해님을 그려봐요.'**
  String get drawingVariousLinesContentLandscape;

  /// No description provided for @takeYourTime.
  ///
  /// In ko, this message translates to:
  /// **'천천히 연습해보세요'**
  String get takeYourTime;

  /// No description provided for @consonantsAndVowelsDescription.
  ///
  /// In ko, this message translates to:
  /// **'자음과 모음의 모양을 올바르게 잡고,\n내가 연습하고 싶은 자음 또는 모음을 골라 글자를 써보세요.'**
  String get consonantsAndVowelsDescription;

  /// No description provided for @consonantsPractice.
  ///
  /// In ko, this message translates to:
  /// **'자음 연습'**
  String get consonantsPractice;

  /// No description provided for @vowelsPractice.
  ///
  /// In ko, this message translates to:
  /// **'모음 연습'**
  String get vowelsPractice;

  /// No description provided for @noDataAvailable.
  ///
  /// In ko, this message translates to:
  /// **'사용 가능한 데이터가 없습니다.'**
  String get noDataAvailable;

  /// No description provided for @sentenceWritingDescription.
  ///
  /// In ko, this message translates to:
  /// **'자음과 모음의 모양을 올바르게 잡고 글씨의 크기와 간격을 일정하게 맞춰\n내 마음에 드는 글을 써보세요.'**
  String get sentenceWritingDescription;

  /// No description provided for @shortSentencePractice.
  ///
  /// In ko, this message translates to:
  /// **'짧은 문장 연습:'**
  String get shortSentencePractice;

  /// No description provided for @longSentencePractice.
  ///
  /// In ko, this message translates to:
  /// **'긴 문장 연습:'**
  String get longSentencePractice;

  /// No description provided for @characterWords.
  ///
  /// In ko, this message translates to:
  /// **'글자 단어'**
  String get characterWords;

  /// No description provided for @wordWritingDescription.
  ///
  /// In ko, this message translates to:
  /// **'자음과 모음의 모양을 올바르게 잡고,\n내가 연습하고 싶은 단어를 골라 글자를 써보세요.'**
  String get wordWritingDescription;

  /// No description provided for @wordPractice.
  ///
  /// In ko, this message translates to:
  /// **'단어 연습:'**
  String get wordPractice;

  /// No description provided for @userTypeChild.
  ///
  /// In ko, this message translates to:
  /// **'어린이'**
  String get userTypeChild;

  /// No description provided for @userTypeAdult.
  ///
  /// In ko, this message translates to:
  /// **'성인'**
  String get userTypeAdult;

  /// No description provided for @userTypeForeign.
  ///
  /// In ko, this message translates to:
  /// **'외국인'**
  String get userTypeForeign;

  /// No description provided for @feedbackDialogInstruction.
  ///
  /// In ko, this message translates to:
  /// **'글자를 누르면 글자별 상세 피드백을 확인할 수 있어요.'**
  String get feedbackDialogInstruction;

  /// No description provided for @feedbackDialogTotalScore.
  ///
  /// In ko, this message translates to:
  /// **'총점'**
  String get feedbackDialogTotalScore;

  /// No description provided for @points.
  ///
  /// In ko, this message translates to:
  /// **'점'**
  String get points;

  /// No description provided for @feedbackDialogSummary.
  ///
  /// In ko, this message translates to:
  /// **'요약'**
  String get feedbackDialogSummary;

  /// No description provided for @feedbackDialogSummaryStage1.
  ///
  /// In ko, this message translates to:
  /// **'AI 글자 인식이 잘 안 된 글자: '**
  String get feedbackDialogSummaryStage1;

  /// No description provided for @feedbackDialogSummaryStage2.
  ///
  /// In ko, this message translates to:
  /// **'글자 크기가 적절하지 않은 글자: '**
  String get feedbackDialogSummaryStage2;

  /// No description provided for @feedbackDialogSummaryStage3.
  ///
  /// In ko, this message translates to:
  /// **'글자 획순이 적절하지 않은 글자: '**
  String get feedbackDialogSummaryStage3;

  /// No description provided for @feedbackDialogSummaryStage4.
  ///
  /// In ko, this message translates to:
  /// **'자음, 모음이 적절하지 않은 글자: '**
  String get feedbackDialogSummaryStage4;

  /// No description provided for @aiwritingMission.
  ///
  /// In ko, this message translates to:
  /// **'밑의 문제를 풀어보세요!'**
  String get aiwritingMission;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ko': return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
