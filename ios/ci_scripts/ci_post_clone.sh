#!/bin/sh

# 오류 발생 시 즉시 스크립트 중단
set -e

# 스크립트 실행 위치를 복제된 저장소의 루트로 변경
cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.

# --------------------------------------------------------------------
# SECTION 1: Generate all necessary configuration files from secrets
# 1단계: Xcode Cloud 비밀 변수를 사용하여 모든 설정 파일 생성하기
# --------------------------------------------------------------------
echo "--- Generating configuration files from Xcode Cloud secrets ---"
echo "--- .env 파일 생성 시작 ---"

# KAKAO_JAVASCRIPT_APP_KEY 변수를 읽어 .env 파일에 쓰기 (파일 새로 생성)
echo "KAKAO_JAVASCRIPT_APP_KEY=$KAKAO_JAVASCRIPT_APP_KEY" > .env

# KAKAO_NATIVE_APP_KEY 변수를 읽어 .env 파일에 추가하기
echo "KAKAO_NATIVE_APP_KEY=$KAKAO_NATIVE_APP_KEY" >> .env

echo ".env 파일 생성 완료. 내용은 다음과 같습니다:"
cat .env # 생성된 파일 내용을 로그에 출력하여 확인 (비밀 값은 *****로 표시됨)

# 프로젝트 루트에 firebase.json 파일 생성
echo "Creating firebase.json..."
echo $FIREBASE_JSON_BASE64 | base64 --decode > firebase.json

# iOS용 GoogleService-Info.plist 파일 생성
echo "Creating GoogleService-Info.plist for iOS..."
mkdir -p ios/Runner # Create directory if it doesn't exist (폴더가 없으면 생성)
echo $GOOGLE_SERVICE_INFO_PLIST_IOS_BASE64 | base64 --decode > ios/Runner/GoogleService-Info.plist

# macOS용 GoogleService-Info.plist 파일 생성
echo "Creating GoogleService-Info.plist for macOS..."
mkdir -p macos/Runner # Create directory if it doesn't exist (폴더가 없으면 생성)
echo $GOOGLE_SERVICE_INFO_PLIST_MACOS_BASE64 | base64 --decode > macos/Runner/GoogleService-Info.plist

# 안드로이드용 google-services.json 파일 생성
echo "Creating google-services.json for Android..."
mkdir -p android/app # Create directory if it doesn't exist (폴더가 없으면 생성)
echo $GOOGLE_SERVICES_JSON_BASE64 | base64 --decode > android/app/google-services.json

# lib 폴더에 firebase_options.dart 파일 생성
echo "Creating firebase_options.dart..."
mkdir -p lib # Create directory if it doesn't exist (폴더가 없으면 생성)
echo $FIREBASE_OPTIONS_DART_BASE64 | base64 --decode > lib/firebase_options.dart

echo "--- All configuration files have been generated successfully. ---"


# git을 사용하여 Flutter 설치
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# iOS용 Flutter 아티팩트 설치
flutter precache --ios

# Flutter 의존성 설치 (이때 .env 파일을 읽음)
flutter pub get

# Homebrew를 사용하여 CocoaPods 설치
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic updates.
brew install cocoapods

# CocoaPods 의존성 설치
cd ios && pod install # run `pod install` in the `ios` directory.

# 성공적으로 종료
exit 0
