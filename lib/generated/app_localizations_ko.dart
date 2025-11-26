// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get loginTitle => '손글손글';

  @override
  String get loginSubtitle => 'AI 한글 손글씨 학습 서비스';

  @override
  String get loginWithApple => 'Apple로 계속하기';

  @override
  String get loginWithGoogle => 'Google로 계속하기';

  @override
  String get loginWithKakao => '카카오로 계속하기';

  @override
  String get loginAsGuest => '게스트로 먼저 체험';

  @override
  String get termsAndConditions => '로그인 시 이용약관 및 개인정보처리방침에 동의합니다.';

  @override
  String get termsOfService => '이용약관';

  @override
  String get privacyPolicy => '개인정보처리방침';

  @override
  String get studyTitle => '손글씨 연습';

  @override
  String get studyDescription => '자음, 모음, 받침, 문장들을 올바르게 쓰는 연습법을 차근차근 알려드립니다.';

  @override
  String get handwritingPostureTitle => '손글씨 자세';

  @override
  String get handwritingPostureSubtitle => '손글씨를 잘 쓰기 위한 기본 자세와 도구';

  @override
  String get consonantsAndVowelsTitle => '자음과 모음 쓰기';

  @override
  String get consonantsAndVowelsSubtitle => '자음, 모음 등 기본 글자를 바르게 쓰는 연습';

  @override
  String get wordWritingTitle => '단어 쓰기';

  @override
  String get wordWritingSubtitle => '쌍자음, 겹받침 등 조금 더 복잡한 글자 연습';

  @override
  String get sentenceWritingTitle => '문장 쓰기';

  @override
  String get sentenceWritingSubtitle => '문장 단위로 글씨를 또박또박 쓰는 연습';

  @override
  String get calligraphyPracticeTitle => '캘리그라피 연습';

  @override
  String get calligraphyPracticeSubtitle => '간단한 캘리그라피 연습을 통해 글씨체를 살려봐요';

  @override
  String get infiniteWritingPracticeTitle => '무한 글씨 연습';

  @override
  String get infiniteWritingPracticeSubtitle => '원하는 만큼 원고지에 글씨를 적어보세요';

  @override
  String get dialogTitleTooSmall => '너무 작아!';

  @override
  String get dialogContentTabletOnly => '공부는 태블릿에서만 가능합니다!';

  @override
  String get dialogTitleInProgress => '개발 진행중';

  @override
  String get dialogContentInProgress => '해당 기능은 개발중이니 조금만 기다려주세요!';

  @override
  String get handwritingBasicsTitle => '손글씨 기초';

  @override
  String get handwritingBasicsSubtitle => '손글씨를 잘 쓰기 위한 기본 자세와 개념';

  @override
  String get myPageTitle => '내 정보';

  @override
  String get profileImageUpdateSuccess => '프로필 이미지가 업데이트되었습니다.';

  @override
  String get profileImageUpdateFailed => '업로드 실패: ';

  @override
  String get profileUpdateSuccess => '프로필이 업데이트되었습니다.';

  @override
  String get profileUpdateCancelled => '프로필 업데이트가 취소되었거나 실패했습니다.';

  @override
  String get logoutFailed => '로그아웃 실패: ';

  @override
  String get loading => '불러오는 중...';

  @override
  String get guest => '게스트';

  @override
  String get ageIsJustANumber => '나이는 공부에 상관없죠!';

  @override
  String get unknownUserType => '회원 유형을 알 수 없어요.';

  @override
  String get logout => '로그아웃';

  @override
  String get editProfile => '회원정보수정';

  @override
  String get characterIntroductionTitle => '캐릭터 소개';

  @override
  String get characterIntroductionSubtitle => '손글씨 연습을 도와줄 귀여운 동물 친구들을 소개할게요.';

  @override
  String get gomgomTitle => '곰곰';

  @override
  String get gomgomSubtitle => '곰곰이는 부드러운 솜결 같은 한 획 한 획을 좋아해요.';

  @override
  String get totoTitle => '토토';

  @override
  String get totoSubtitle => '토토는 껑충껑충 경쾌한 리듬으로 글씨 연습을 즐겨요.';

  @override
  String get daramTitle => '다람';

  @override
  String get daramSubtitle => '다람이는 작은 손으로 도토리를 모으듯 꼼꼼하게 글씨를 완성시켜 준답니다.';

  @override
  String get editProfileTitle => '회원 정보 수정';

  @override
  String get nickname => '닉네임';

  @override
  String get birthdate => '생년월일: ';

  @override
  String get userType => '사용자 유형';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get myWritingCalendarTitle => '나만의 글씨 달력';

  @override
  String yearMonth(int year, int month) {
    return '$year년 $month월';
  }

  @override
  String get allPractices => '모든 연습';

  @override
  String get totalPracticeTime => '총 연습시간';

  @override
  String get averageScore => '평균 점수';

  @override
  String get scoreUnit => '점';

  @override
  String get sessionCount => '세션 수';

  @override
  String get sessionUnit => '회';

  @override
  String get daySun => '일';

  @override
  String get dayMon => '월';

  @override
  String get dayTue => '화';

  @override
  String get dayWed => '수';

  @override
  String get dayThu => '목';

  @override
  String get dayFri => '금';

  @override
  String get daySat => '토';

  @override
  String dailySummary(String totalTime, String avgScore, int count) {
    return '총 $totalTime • 평균 $avgScore점 • $count회';
  }

  @override
  String get noPracticeData => '이 날의 연습 기록이 없어요.';

  @override
  String practiceSummary(int duration, int score) {
    return '연습 $duration분 • $score점';
  }

  @override
  String get viewDetails => '상세 보기(추후 연결)';

  @override
  String get myRecordTitle => '나의 기록';

  @override
  String get myRecordDescription => '나의 연습 기록들을 다양한 방법으로 확인해보세요!';

  @override
  String get writingScoreStatsTitle => '글씨 점수 통계';

  @override
  String get writingScoreStatsSubtitle => '내가 연습한 글씨 점수를 통계로 확인해볼까요?';

  @override
  String get myWritingCalendarCardTitle => '나만의 글씨 달력';

  @override
  String get myWritingCalendarCardSubtitle => '하루하루마다 연습한 글씨를 달력으로 확인해보세요';

  @override
  String get createPhotocardTitle => '글씨 포토카트 만들기';

  @override
  String get createPhotocardSubtitle => '오늘을 기념하는 사진과 함께 문장 하나를 남겨보세요';

  @override
  String get chapter1 => '~받침 없는 쉬운 글자 연습~';

  @override
  String get chapter2 => '~받침 없는 글자 연습~';

  @override
  String get chapter3 => '~받침 있는 쉬운 글자 연습~';

  @override
  String get chapter4 => '~받침 있는 글자 연습~';

  @override
  String get chapter5 => '~받침 있는 글자\n 빠르게 써보기~';

  @override
  String get chapter6 => '~받침 없는 낱말 연습~';

  @override
  String get chapter7 => '~받침 있는 낱말 연습~';

  @override
  String get chapter8 => '~낱말 추가 연습~';

  @override
  String get chapter9 => '~낱말을 빠르게 써보기~';

  @override
  String get chapter10 => '~짧은 문장 연습~';

  @override
  String get chapter11 => '~긴 문장 연습~';

  @override
  String get help => '도움말';

  @override
  String get stepActivationRule => '스텝 활성화 규칙';

  @override
  String get stepActivationRuleDescription => '이전 단계를 성공적으로 완료해야 다음 단계가 활성화됩니다.\n차근차근 단계를 밟아가며 실력을 키워보세요!';

  @override
  String get colorGuide => '색상 안내';

  @override
  String get colorGuideActive => '현재 학습할 수 있는 단계입니다.';

  @override
  String get colorGuideInactive => '아직 잠겨있는 단계입니다. 이전 단계를 먼저 완료해주세요.';

  @override
  String get imageButtonFunction => '이미지 버튼 기능';

  @override
  String get imageButtonFunctionDescription => '각 챕터의 마지막에 있는 동물 선생님 버튼을 누르면, 특별한 AI 추천 문제를 풀어볼 수 있습니다.';

  @override
  String get close => '닫기';

  @override
  String get loadingError => '에러: ';

  @override
  String get helpButtonText => '도움말 버튼을 눌러\n학습 방법을 확인하세요!';

  @override
  String get helpButtonTextLandscape => '어떻게 손글손글을 통해\n 연습하는지 알려드릴게요!';

  @override
  String get notification => '알림';

  @override
  String get cannotStudyYet => '아직 공부할 수 없어요!';

  @override
  String get aiRecommendation => 'AI 추천 문제 풀기!';

  @override
  String get missionText => '밑의 글자를 작성해보세요!';

  @override
  String get error => '오류';

  @override
  String get aiError => 'AI 추천 문제 생성 중 오류가 발생했습니다: ';

  @override
  String get ok => '확인';

  @override
  String get practiceTask => '연습 과제';

  @override
  String get startPractice => '연습 시작!';

  @override
  String get failure => '실패😢';

  @override
  String get timeExpired => '시간이 초과되었어요!\n다음에는 조금 더 빨리 써봐요~';

  @override
  String get tooManyStrokes => '획이 너무 많아요!\n획 수를 맞춰서 연습해보세요.';

  @override
  String get notEnoughStrokes => '획이 부족해요!\n획 수를 맞춰서 연습해보세요.';

  @override
  String evaluationServerConnectionError(int statusCode) {
    return '평가 서버에 접속할 수 없습니다. (코드: $statusCode)';
  }

  @override
  String get evaluationSubmissionError => '평가 전송 중 오류가 발생했습니다: ';

  @override
  String get penThickness => '펜 굵기: ';

  @override
  String get eraseOneStroke => '한 획 지우기';

  @override
  String get eraseAll => '글씨 지우기';

  @override
  String get submit => '제출';

  @override
  String get viewHint => '도움말 보기';

  @override
  String get targetCharacter => '대상 글자';

  @override
  String get score => '점수';

  @override
  String get feedback => '피드백';

  @override
  String get noFeedback => '피드백 없음';

  @override
  String get home => '홈';

  @override
  String get freeStudy => '자유 공부';

  @override
  String get history => '기록';

  @override
  String get myInfo => '내 정보';

  @override
  String get correctPencilGripTitle => '연필 바르게 잡는 법';

  @override
  String get correctPencilGripContent => '1. 엄지와 검지 손가락으로 연필을 살짝 잡고, 가운데 손가락으로 연필을 받쳐보세요.\n2. 연필의 뾰족한 반대쪽 끝이 어깨를 향하게 살짝 눕혀주세요.\n3. 손목은 편안하게 두고, 팔 전체로 그림을 그리듯 글씨를 써봐요.\n4. 허리를 꼿꼿하게 펴고 앉으면 팔이 아프지 않고 글씨를 더 예쁘게 쓸 수 있어요.';

  @override
  String get learnWithVideo => '영상으로 배우기';

  @override
  String get howAreLettersMadeTitle => '글자는 어떻게 만들어질까?';

  @override
  String get howAreLettersMadeContent => '한글은 멋진 로봇처럼 자음 친구와 모음 친구가 합체해서 만들어져요! 자음과 모음이 만나면 우리가 아는 글자가 짠! 하고 나타난답니다.';

  @override
  String get consonantFriends => '자음 친구들';

  @override
  String get consonantList => 'ㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅅ, ㅇ, ㅈ, ㅊ, ㅋ, ㅌ, ㅍ, ㅎ';

  @override
  String get vowelFriends => '모음 친구들';

  @override
  String get vowelList => 'ㅏ, ㅑ, ㅓ, ㅕ, ㅗ, ㅛ, ㅜ, ㅠ, ㅡ, ㅣ';

  @override
  String get firstStepOfWritingTitle => '글씨의 첫걸음: 선 긋기(획)';

  @override
  String get firstStepOfWritingContentPortrait => '모든 글씨는 선을 그리는 것에서 시작해요. 앞으로는 이 선을 \'획\'이라고 부를거예요.반듯반듯 예쁜 선을 그릴 수 있으면 어떤 글씨든 잘 쓸 수 있답니다. 여러 가지 선을 그리면서 글씨 쓰기 놀이를 해볼까요?';

  @override
  String get firstStepOfWritingContentLandscape => '모든 글씨는 선을 그리는 것에서 시작해요. 앞으로는 이 선을 \'획\'이라고 부를거예요. 반듯반듯 예쁜 선을 그릴 수 있으면 어떤 글씨든 잘 쓸 수 있답니다. 여러 가지 선을 그리면서 글씨 쓰기 놀이를 해볼까요?';

  @override
  String get drawingVariousLines => '여러 가지 선 그리기';

  @override
  String get drawingVariousLinesContentPortrait => '1. 가로선(-): 왼쪽에서 오른쪽으로 쭉! 미끄럼틀을 타요.\n2. 세로선(|): 위에서 아래로 쭉! 폭포수가 떨어져요.\n3. 대각선(ㅅ): 삐뚤빼뚤! 재미있는 모양을 만들어요.\n4. 동그라미(○): 동글동글! 예쁜 해님을 그려봐요.';

  @override
  String get drawingVariousLinesContentLandscape => '1. 가로선(-): 왼쪽에서 오른쪽으로 쭉! 미끄럼틀을 타요.\n2. 세로선(ㅣ): 위에서 아래로 쭉! 폭포수가 떨어져요.\n3. 대각선(ㅅ): 삐뚤빼뚤! 재미있는 모양을 만들어요.\n4. 동그라미(ㅇ): 동글동글! 예쁜 해님을 그려봐요.';

  @override
  String get takeYourTime => '천천히 연습해보세요';

  @override
  String get consonantsAndVowelsDescription => '자음과 모음의 모양을 올바르게 잡고,\n내가 연습하고 싶은 자음 또는 모음을 골라 글자를 써보세요.';

  @override
  String get consonantsPractice => '자음 연습';

  @override
  String get vowelsPractice => '모음 연습';

  @override
  String get noDataAvailable => '사용 가능한 데이터가 없습니다.';

  @override
  String get sentenceWritingDescription => '자음과 모음의 모양을 올바르게 잡고 글씨의 크기와 간격을 일정하게 맞춰\n내 마음에 드는 글을 써보세요.';

  @override
  String get shortSentencePractice => '짧은 문장 연습:';

  @override
  String get longSentencePractice => '긴 문장 연습:';

  @override
  String get characterWords => '글자 단어';

  @override
  String get wordWritingDescription => '자음과 모음의 모양을 올바르게 잡고,\n내가 연습하고 싶은 단어를 골라 글자를 써보세요.';

  @override
  String get wordPractice => '단어 연습:';

  @override
  String get userTypeChild => '어린이';

  @override
  String get userTypeAdult => '성인';

  @override
  String get userTypeForeign => '외국인';

  @override
  String get feedbackDialogInstruction => '글자를 누르면 글자별 상세 피드백을 확인할 수 있어요.';

  @override
  String get feedbackDialogTotalScore => '총점';

  @override
  String get points => '점';

  @override
  String get feedbackDialogSummary => '요약';

  @override
  String get feedbackDialogSummaryStage1 => 'AI 글자 인식이 잘 안 된 글자: ';

  @override
  String get feedbackDialogSummaryStage2 => '글자 크기가 적절하지 않은 글자: ';

  @override
  String get feedbackDialogSummaryStage3 => '글자 획순이 적절하지 않은 글자: ';

  @override
  String get feedbackDialogSummaryStage4 => '자음, 모음이 적절하지 않은 글자: ';

  @override
  String get aiwritingMission => '밑의 문제를 풀어보세요!';
  
  @override
  // TODO: implement feedbackFormDescription
  String get feedbackFormDescription => "사용자 유형(어린이, 성인, 외국인)에 따라 피드백 양식이 달라져요.\n설명이 쉬워지거나, 영어로 바뀐답니다.";
}
