# Desmos Menubar Calculator

A macOS menubar app that displays a mini Desmos graphing calculator in a popover when clicked.

## Features

- 🧮 **Full Desmos Calculator** - Access the complete Desmos graphing calculator from your menubar
- ⚙️ **Customizable Window Size** - Resize the calculator window to your preference
- 💾 **State Persistence** - Choose whether to save your graphs or start fresh each time
- 🎯 **Easy Access** - Quick access via menubar icon, no dock icon clutter
- 🖱️ **Simple Controls** - Left-click to open/close, right-click for settings

## Requirements

- macOS 12.0 (Monterey) or later
- Apple Silicon (M1/M2/M3) or Intel Mac

## Installation

### Option 1: Download Pre-built Release

1. Go to the [Releases](https://github.com/Kristijonas-Adomaitis/Desmos_menubar/releases) page
2. Download the latest `DesmosMenubarApp-YYYYMMDD.zip` file
3. Extract the ZIP file
4. Move `DesmosMenubarApp.app` to your Applications folder
5. Right-click the app and select "Open" (macOS may require this the first time)
6. Click "Open" in the security dialog

### Option 2: Build from Source

1. Clone this repository:
   ```bash
   git clone https://github.com/Kristijonas-Adomaitis/Desmos_menubar.git
   cd Desmos_menubar
   ```

2. Build the app:
   ```bash
   chmod +x build_release.sh
   ./build_release.sh
   ```

3. The app will be created as `DesmosMenubarApp.app` in the project directory

## Usage

1. **Open Calculator**: Click the function icon (ƒ) in your menubar
2. **Close Calculator**: Click the menubar icon again
3. **Access Settings**: Right-click the menubar icon → "Settings..."
4. **Quit App**: Right-click the menubar icon → "Quit"

## Settings

### Window Size
- Click "Resize by Dragging..." to open a resizable preview window
- Drag the edges to adjust the size
- Close the preview window to save your preferred size

### State Persistence
- **Enabled** (default): Calculator remembers your graphs and equations when reopened
- **Disabled**: Calculator starts fresh each time you open it

## Building from Source

### Prerequisites
- macOS 12.0 or later
- Xcode Command Line Tools (install with `xcode-select --install`)
- Swift 5.9 or later

### Build Steps

```bash
# Clone the repository
git clone https://github.com/Kristijonas-Adomaitis/Desmos_menubar.git
cd Desmos_menubar

# Build the release
./build_release.sh

# Or build manually
swift build -c release
mkdir -p DesmosMenubarApp.app/Contents/MacOS
cp .build/release/DesmosMenubarApp DesmosMenubarApp.app/Contents/MacOS/
cp Info.plist DesmosMenubarApp.app/Contents/
```

## Project Structure

```
.
├── Sources/
│   └── DesmosMenubarApp/
│       ├── DesmosMenubarApp.swift    # Main app entry point
│       ├── DesmosCalculatorView.swift # Calculator WebView wrapper
│       ├── AppSettings.swift         # Settings management
│       └── SettingsView.swift        # Settings UI
├── Info.plist                        # App configuration
├── Package.swift                      # Swift Package Manager config
├── build_release.sh                   # Release build script
└── README.md                          # This file
```

## Troubleshooting

### App won't open after download
- Right-click the app and select "Open"
- Go to System Settings → Privacy & Security → Allow the app to run
- You may need to remove the quarantine attribute:
  ```bash
  xattr -d com.apple.quarantine DesmosMenubarApp.app
  ```

### Calculator not loading
- Check your internet connection (Desmos loads from the web)
- Ensure macOS allows network connections for the app

### Menubar icon not appearing
- Check if the app is running: `ps aux | grep DesmosMenubarApp`
- Restart the app
- Check System Settings → Privacy & Security → Accessibility (if needed)

## License

[Add your license here - MIT, GPL, etc.]

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- Built with [Desmos](https://www.desmos.com/) calculator
- Uses SwiftUI and AppKit for macOS integration
