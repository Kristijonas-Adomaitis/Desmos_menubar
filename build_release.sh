#!/bin/bash

# Build script for creating a distributable release of Desmos Menubar Calculator

set -e

echo "Building Desmos Menubar Calculator..."
echo ""

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf .build
rm -rf DesmosMenubarApp.app

# Build the app
echo "Building Swift package..."
swift build -c release

# Create app bundle structure
echo "Creating app bundle..."
mkdir -p DesmosMenubarApp.app/Contents/MacOS
mkdir -p DesmosMenubarApp.app/Contents/Resources

# Copy executable
echo "Copying executable..."
cp .build/release/DesmosMenubarApp DesmosMenubarApp.app/Contents/MacOS/

# Copy Info.plist
echo "Copying Info.plist..."
cp Info.plist DesmosMenubarApp.app/Contents/

# Update Info.plist with actual values
echo "Updating Info.plist..."
/usr/libexec/PlistBuddy -c "Set :CFBundleExecutable DesmosMenubarApp" DesmosMenubarApp.app/Contents/Info.plist 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier com.desmos.menubar" DesmosMenubarApp.app/Contents/Info.plist 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Set :CFBundleName DesmosMenubarApp" DesmosMenubarApp.app/Contents/Info.plist 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Set :CFBundlePackageType APPL" DesmosMenubarApp.app/Contents/Info.plist 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Set :LSMinimumSystemVersion 12.0" DesmosMenubarApp.app/Contents/Info.plist 2>/dev/null || true

# Code sign (ad-hoc signing for distribution)
echo "Code signing app..."
codesign --force --deep --sign - DesmosMenubarApp.app 2>/dev/null || {
    echo "Warning: Code signing failed, but continuing..."
}

# Create zip for distribution
echo "Creating distribution archive..."
VERSION=$(date +%Y%m%d)
zip -r "DesmosMenubarApp-${VERSION}.zip" DesmosMenubarApp.app -x "*.DS_Store" -x "__MACOSX/*"

echo ""
echo "✅ Build complete!"
echo ""
echo "Distribution file: DesmosMenubarApp-${VERSION}.zip"
echo ""
echo "To test the app:"
echo "  open DesmosMenubarApp.app"
echo ""
echo "To distribute:"
echo "  1. Upload DesmosMenubarApp-${VERSION}.zip to GitHub Releases"
echo "  2. Users can download and extract the .app file"
echo "  3. They may need to right-click and select 'Open' the first time (macOS security)"
