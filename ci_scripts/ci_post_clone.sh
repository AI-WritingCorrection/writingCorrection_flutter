#!/bin/sh

# Fail on error
set -e

# 1. Install Flutter dependencies
echo "Running flutter pub get..."
flutter pub get

# 2. Go to the ios directory
cd ios

# 3. Install CocoaPods dependencies
# This is often redundant as `flutter pub get` runs it, but it's safe to run again.
echo "Running pod install..."
pod install

echo "Pre-build steps completed successfully."

# Return to root directory
cd ..

exit 0