#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILD_ROOT="${BUILD_ROOT:-${RUNNER_TEMP:-/tmp}/stratix-device-build}"
DERIVED_DATA="${BUILD_ROOT}/DerivedData"
PAYLOAD_DIR="${BUILD_ROOT}/Payload"
APP_PATH="${DERIVED_DATA}/Build/Products/Release-appletvos/Stratix.app"
IPA_PATH="${BUILD_ROOT}/Stratix-tvOS-unsigned.ipa"

rm -rf "${BUILD_ROOT}"
mkdir -p "${BUILD_ROOT}" "${PAYLOAD_DIR}"

cd "${ROOT_DIR}"
xcodebuild \
  -workspace Stratix.xcworkspace \
  -scheme Stratix-ReleaseRun \
  -configuration Release \
  -sdk appletvos \
  -destination 'generic/platform=tvOS' \
  -derivedDataPath "${DERIVED_DATA}" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  DEVELOPMENT_TEAM= \
  build

test -d "${APP_PATH}"
test -f "${APP_PATH}/Info.plist"
/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "${APP_PATH}/Info.plist"
/usr/libexec/PlistBuddy -c 'Print :MinimumOSVersion' "${APP_PATH}/Info.plist" || true

cp -R "${APP_PATH}" "${PAYLOAD_DIR}/Stratix.app"
ditto -c -k --sequesterRsrc --keepParent "${PAYLOAD_DIR}" "${IPA_PATH}"

echo "IPA_PATH=${IPA_PATH}"
shasum -a 256 "${IPA_PATH}"
