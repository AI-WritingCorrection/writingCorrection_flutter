#!/bin/sh

# -----------------------------------------------------------------------------
# ci_pre_xcodebuild.sh
#  - Runs just before Xcode's archive step in Xcode Cloud.
#  - Responsibilities:
#     1) Apply versioning (build number / marketing version)
#     2) Prepare Flutter iOS build artifacts (no codesign)
#  - Inputs (set as Xcode Cloud environment variables / secrets):
#     AUTO_BUMP_BUILD (default: true)
#     MARKETING_VERSION (optional, e.g. 1.2.0)
#     FLAVOR (optional, e.g. prod)
#     DART_DEFINE_ARGS (optional, e.g. "--dart-define=API_BASE=https://... --dart-define=SENTRY_DSN=...")
# -----------------------------------------------------------------------------

set -euxo pipefail

# Move to repository root checked out by Xcode Cloud
cd "$CI_PRIMARY_REPOSITORY_PATH"

# Ensure Flutter is on PATH (installed in ci_post_clone)
if ! command -v flutter >/dev/null 2>&1; then
  export PATH="$HOME/flutter/bin:$PATH"
fi

# 1) Versioning ---------------------------------------------------------------
AUTO_BUMP_BUILD="${AUTO_BUMP_BUILD:-true}"

if [ "$AUTO_BUMP_BUILD" = "true" ]; then
  BUILD_NUMBER="${CI_BUILD_NUMBER:-1}"
  (
    cd ios
    # Set the project build number to Xcode Cloud's CI build number
    xcrun agvtool new-version -all "$BUILD_NUMBER"
  )
fi

if [ -n "${MARKETING_VERSION:-}" ]; then
  (
    cd ios
    # Set the marketing version (e.g., 1.2.0)
    xcrun agvtool new-marketing-version "$MARKETING_VERSION"
  )
fi

# Generate localization files
flutter gen-l10n

# 2) Prepare Flutter iOS outputs (no codesign) --------------------------------
FLAVOR_ARG=""
if [ -n "${FLAVOR:-}" ]; then
  FLAVOR_ARG="--flavor \"$FLAVOR\""
fi

DART_DEFINE_ARGS="${DART_DEFINE_ARGS:-}"

# Build the iOS app without codesigning so Xcode can archive afterward
# shellcheck disable=SC2086
sh -lc "flutter build ios --release --no-codesign $FLAVOR_ARG $DART_DEFINE_ARGS"

echo "ci_pre_xcodebuild.sh complete. Xcode will now archive the prepared iOS project."