#!/bin/sh

# 오류 발생 시 즉시 스크립트 중단
set -e

# 스크립트 실행 위치를 복제된 저장소의 루트로 변경
cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.

echo "--- .env 파일 생성 시작 ---"

# KAKAO_JAVASCRIPT_APP_KEY 변수를 읽어 .env 파일에 쓰기 (파일 새로 생성)
echo "KAKAO_JAVASCRIPT_APP_KEY=$KAKAO_JAVASCRIPT_APP_KEY" > .env

# KAKAO_NATIVE_APP_KEY 변수를 읽어 .env 파일에 추가하기
echo "KAKAO_NATIVE_APP_KEY=$KAKAO_NATIVE_APP_KEY" >> .env

echo ".env 파일 생성 완료. 내용은 다음과 같습니다:"
cat .env # 생성된 파일 내용을 로그에 출력하여 확인 (비밀 값은 *****로 표시됨)

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
