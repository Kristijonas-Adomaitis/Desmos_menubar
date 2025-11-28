# Release Checklist

## Before Creating a Release

1. **Update Version Number**
   - Update version in `Info.plist` if needed
   - Consider using semantic versioning (e.g., 1.0.0)

2. **Test the App**
   - Test on a clean macOS installation if possible
   - Verify all features work:
     - Calculator opens/closes
     - Settings window opens
     - Resize functionality works
     - State persistence works
     - First launch hint appears

3. **Build Release**
   ```bash
   ./build_release.sh
   ```

4. **Test the Built App**
   - Test the `.app` file directly
   - Test the `.zip` file after extraction
   - Verify it works on a different Mac if possible

## Creating GitHub Release

1. **Create a New Release on GitHub**
   - Go to your repository → Releases → "Draft a new release"
   - Tag version: `v1.0.0` (or appropriate version)
   - Release title: `Desmos Menubar Calculator v1.0.0`
   - Description: Copy from RELEASE_NOTES.md or write release notes

2. **Upload Files**
   - Upload the `DesmosMenubarApp-YYYYMMDD.zip` file
   - Optionally include source code as a separate zip

3. **Publish Release**
   - Click "Publish release"

## Release Notes Template

```markdown
## What's New

- Initial release of Desmos Menubar Calculator
- Full Desmos graphing calculator integration
- Customizable window size
- State persistence options
- First launch welcome hint

## Installation

1. Download `DesmosMenubarApp-YYYYMMDD.zip`
2. Extract the ZIP file
3. Move `DesmosMenubarApp.app` to Applications
4. Right-click and select "Open" (first time only)
5. Click the menubar icon to start using!

## Requirements

- macOS 12.0 or later
```
