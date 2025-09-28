#!/bin/sh

# -----------------------------------------------------------------------------
# ci_post_clone.sh
#  - Runs right after Xcode Cloud checks out your repository
#  - Responsibilities:
#     1) Generate config files from secrets (no secret echo to logs)
#     2) Install Flutter SDK and dependencies
#     3) Prepare CocoaPods
# -----------------------------------------------------------------------------

set -euxo pipefail

# Go to repo root
cd "$CI_PRIMARY_REPOSITORY_PATH"

echo "--- Generating configuration files from Xcode Cloud secrets ---"

# .env
: "${KAKAO_JAVASCRIPT_APP_KEY:=}"; : "${KAKAO_NATIVE_APP_KEY:=}"
{
  echo "KAKAO_JAVASCRIPT_APP_KEY=$KAKAO_JAVASCRIPT_APP_KEY"
  echo "KAKAO_NATIVE_APP_KEY=$KAKAO_NATIVE_APP_KEY"
} > .env
chmod 600 .env

# Firebase / Google configs
: "${FIREBASE_JSON_BASE64:=}"
: "${GOOGLE_SERVICE_INFO_PLIST_IOS_BASE64:=}"
: "${GOOGLE_SERVICE_INFO_PLIST_MACOS_BASE64:=}"
: "${GOOGLE_SERVICES_JSON_BASE64:=}"
: "${FIREBASE_OPTIONS_DART_BASE64:=}"

[ -n "$FIREBASE_JSON_BASE64" ] && echo "$FIREBASE_JSON_BASE64" | base64 --decode > firebase.json && chmod 600 firebase.json || true
mkdir -p ios/Runner macos/Runner android/app lib
[ -n "$GOOGLE_SERVICE_INFO_PLIST_IOS_BASE64" ] && echo "$GOOGLE_SERVICE_INFO_PLIST_IOS_BASE64" | base64 --decode > ios/Runner/GoogleService-Info.plist && chmod 600 ios/Runner/GoogleService-Info.plist || true
[ -n "$GOOGLE_SERVICE_INFO_PLIST_MACOS_BASE64" ] && echo "$GOOGLE_SERVICE_INFO_PLIST_MACOS_BASE64" | base64 --decode > macos/Runner/GoogleService-Info.plist && chmod 600 macos/Runner/GoogleService-Info.plist || true
[ -n "$GOOGLE_SERVICES_JSON_BASE64" ] && echo "$GOOGLE_SERVICES_JSON_BASE64" | base64 --decode > android/app/google-services.json && chmod 600 android/app/google-services.json || true
[ -n "$FIREBASE_OPTIONS_DART_BASE64" ] && echo "$FIREBASE_OPTIONS_DART_BASE64" | base64 --decode > lib/firebase_options.dart || true

echo "--- Config files generated successfully. ---"

# Install Flutter
FLUTTER_VERSION="${FLUTTER_VERSION:-3.24.3}"
if ! command -v flutter >/dev/null 2>&1; then
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter"
  export PATH="$HOME/flutter/bin:$PATH"
else
  export PATH="$(dirname $(dirname $(command -v flutter)))/bin:$PATH"
fi

flutter --version
flutter precache --ios
flutter pub get

# CocoaPods
if ! command -v pod >/dev/null 2>&1; then
  HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods
fi

(
  cd ios
  pod repo update
  pod install
)

echo "ci_post_clone.sh completed."
