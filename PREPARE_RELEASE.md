# Preparing Your Release

Follow these steps to prepare and publish your release on GitHub:

## Step 1: Update and Commit Files

```bash
# Add all changes
git add .

# Commit the changes
git commit -m "Prepare for initial release"

# Push to GitHub (if not already pushed)
git push origin main
```

## Step 2: Build the Release

```bash
# Make sure the build script is executable
chmod +x build_release.sh

# Build the release
./build_release.sh
```

This will create a file like `DesmosMenubarApp-YYYYMMDD.zip` that's ready for distribution.

## Step 3: Test the Release

Before uploading, test the built app:

```bash
# Test the app bundle
open DesmosMenubarApp.app

# Or test the extracted ZIP
unzip -q DesmosMenubarApp-*.zip
open DesmosMenubarApp.app
```

Make sure:
- ✅ Calculator opens when clicking menubar icon
- ✅ Settings window opens
- ✅ Resize functionality works
- ✅ State persistence works
- ✅ First launch hint appears

## Step 4: Create GitHub Release

1. **Go to your repository**: https://github.com/Kristijonas-Adomaitis/Desmos_menubar

2. **Click "Releases"** → **"Create a new release"**

3. **Fill in the release details**:
   - **Tag version**: `v1.0.0` (create new tag)
   - **Release title**: `Desmos Menubar Calculator v1.0.0`
   - **Description**: Copy from below or write your own

4. **Upload the ZIP file**:
   - Drag and drop `DesmosMenubarApp-YYYYMMDD.zip` into the "Attach binaries" area

5. **Publish**: Click "Publish release"

## Release Notes Template

```markdown
## What's New

- Initial release of Desmos Menubar Calculator
- Full Desmos graphing calculator integration
- Customizable window size via drag-to-resize
- Optional state persistence (save graphs or start fresh)
- First launch welcome hint
- Clean menubar-only interface

## Installation

1. Download `DesmosMenubarApp-YYYYMMDD.zip`
2. Extract the ZIP file
3. Move `DesmosMenubarApp.app` to your Applications folder
4. Right-click the app and select "Open" (first time only)
5. Click "Open" in the security dialog if prompted
6. Click the function icon (ƒ) in your menubar to start using!

## Requirements

- macOS 12.0 (Monterey) or later
- Apple Silicon (M1/M2/M3) or Intel Mac

## Usage

- **Open Calculator**: Click the menubar icon
- **Close Calculator**: Click the menubar icon again
- **Settings**: Right-click the menubar icon → "Settings..."
- **Quit**: Right-click the menubar icon → "Quit"

## Troubleshooting

If the app won't open after download:
- Right-click the app and select "Open"
- Go to System Settings → Privacy & Security → Allow the app to run
- Or run: `xattr -d com.apple.quarantine DesmosMenubarApp.app`
```

## Quick Commands Summary

```bash
# 1. Commit changes
git add . && git commit -m "Prepare for release" && git push

# 2. Build release
./build_release.sh

# 3. Test it
open DesmosMenubarApp.app

# 4. Then go to GitHub and create the release manually
```
