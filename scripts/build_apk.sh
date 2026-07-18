#!/bin/bash
set -e

echo "================================================="
echo "  Building Aether Android Client with Flutter & R8"
echo "================================================="

# Ensure binaries are downloaded
bash scripts/download_aether_binaries.sh

echo "Fetching Flutter dependencies..."
flutter pub get

echo "Building R8 Optimized Android Release APK..."
flutter build apk --release --split-per-abi || flutter build apk --release

echo "================================================="
echo "  Build Completed Successfully!"
echo "  Release APK Location:"
ls -la build/app/outputs/flutter-apk/*.apk 2>/dev/null || true
echo "================================================="
