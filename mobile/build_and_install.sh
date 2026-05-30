#!/usr/bin/env bash

set -e

echo "=================================="
echo "   TOUCHDECK RELEASE BUILD"
echo "=================================="

APP_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$APP_DIR"

echo "[1/4] Cleaning project..."
flutter clean

echo "[2/4] Getting dependencies..."
flutter pub get

echo "[3/4] Building RELEASE APK..."
flutter build apk --release

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

if [ ! -f "$APK_PATH" ]; then
  echo "ERROR: APK not found: $APK_PATH"
  exit 1
fi

echo "[4/4] Installing RELEASE APK..."

# install release explicitly
flutter install --release

echo "DONE"