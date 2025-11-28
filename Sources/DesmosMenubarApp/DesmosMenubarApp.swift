import SwiftUI
import AppKit
import Combine

@main
struct DesmosMenubarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            SettingsView(appDelegate: appDelegate)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    static var shared: AppDelegate?
    
    var statusBarItem: NSStatusItem?
    var popover: NSPopover?
    var calculatorViewController: NSHostingController<DesmosCalculatorView>?
    var settingsObserver: AnyCancellable?
    var settingsWindow: NSWindow?
    var resizeWindow: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Store shared reference
        AppDelegate.shared = self
        
        // Hide dock icon
        NSApp.setActivationPolicy(.accessory)
        
        // Create status bar item
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem?.button {
            button.image = NSImage(systemSymbolName: "function", accessibilityDescription: "Desmos Calculator")
            
            // Handle clicks - left click toggles popover, right click shows menu
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.action = #selector(handleButtonClick(_:))
            button.target = self
        }
        
        // Check if first launch and show hint
        checkFirstLaunch()
        
        // Create popover with initial settings
        updatePopover()
        
        // Observe settings changes
        let widthPublisher = AppSettings.shared.$windowWidth
        let heightPublisher = AppSettings.shared.$windowHeight
        let persistStatePublisher = AppSettings.shared.$persistState
        
        settingsObserver = Publishers.CombineLatest3(widthPublisher, heightPublisher, persistStatePublisher)
            .sink { [weak self] _, _, _ in
                // If persistence changed, recreate popover; otherwise just update size
                if let self = self {
                    let wasShown = self.popover?.isShown ?? false
                    self.updatePopover()
                    if wasShown {
                        // Reopen if it was open
                        self.togglePopover(nil)
                    }
                }
            }
        
        // Listen for resize window notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleOpenResizeWindow),
            name: NSNotification.Name("OpenResizeWindow"),
            object: nil
        )
    }
    
    @objc func handleOpenResizeWindow() {
        openResizeWindow()
    }
    
    func checkFirstLaunch() {
        let defaults = UserDefaults.standard
        let hasLaunchedBefore = defaults.bool(forKey: "hasLaunchedBefore")
        
        if !hasLaunchedBefore {
            // Mark as launched
            defaults.set(true, forKey: "hasLaunchedBefore")
            
            // Show hint after a short delay to ensure UI is ready
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showFirstLaunchHint()
            }
        }
    }
    
    func showFirstLaunchHint() {
        // The hint will be shown in the calculator view itself
        // Just ensure the popover is shown
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.statusBarItem?.button != nil {
                self.togglePopover(nil)
            }
        }
    }
    
    func updatePopover() {
        let settings = AppSettings.shared
        let calculatorView = DesmosCalculatorView()
        calculatorViewController = NSHostingController(rootView: calculatorView)
        
        popover = NSPopover()
        popover?.contentSize = settings.windowSize
        popover?.behavior = .transient
        popover?.contentViewController = calculatorViewController
    }
    
    func updatePopoverSize() {
        guard let popover = popover else { return }
        let settings = AppSettings.shared
        popover.contentSize = settings.windowSize
        
        // Update the view controller's view size
        if let viewController = calculatorViewController {
            viewController.view.frame.size = settings.windowSize
        }
    }
    
    func recreatePopover() {
        let wasShown = popover?.isShown ?? false
        updatePopover()
        if wasShown {
            togglePopover(nil)
        }
    }
    
    @objc func handleButtonClick(_ sender: AnyObject?) {
        guard let event = NSApp.currentEvent,
              let button = statusBarItem?.button else { return }
        
        if event.type == .rightMouseUp {
            // Right click - show menu
            let menu = NSMenu()
            let settingsItem = NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ",")
            settingsItem.target = self
            menu.addItem(settingsItem)
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            menu.popUp(positioning: nil, at: NSPoint(x: 0, y: button.bounds.height), in: button)
        } else {
            // Left click - toggle popover
            togglePopover(sender)
        }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        guard let button = statusBarItem?.button else { return }
        
        if let popover = popover {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                // If persistState is false, recreate the webview for fresh start
                if !AppSettings.shared.persistState {
                    updatePopover()
                }
                // Update size before showing
                updatePopoverSize()
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
    @objc func openSettings() {
        if settingsWindow == nil {
            let settingsView = SettingsView(appDelegate: self)
            let hostingController = NSHostingController(rootView: settingsView)
            
            settingsWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: false
            )
            settingsWindow?.title = "Desmos Calculator Settings"
            settingsWindow?.contentViewController = hostingController
            settingsWindow?.center()
            settingsWindow?.isReleasedWhenClosed = false
        }
        
        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func openResizeWindow() {
        print("openResizeWindow() called")
        
        // Close existing resize window if open
        if let existingWindow = resizeWindow {
            existingWindow.close()
            resizeWindow = nil
        }
        
        let settings = AppSettings.shared
        print("Creating resize window with size: \(settings.windowWidth) x \(settings.windowHeight)")
        
        let calculatorView = DesmosCalculatorView()
        let hostingController = NSHostingController(rootView: calculatorView)
        
        resizeWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: settings.windowWidth, height: settings.windowHeight),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        resizeWindow?.title = "Resize Calculator Window - Drag edges to resize, close when done"
        resizeWindow?.contentViewController = hostingController
        resizeWindow?.center()
        resizeWindow?.isReleasedWhenClosed = false
        resizeWindow?.minSize = NSSize(width: 300, height: 300)
        
        // Save size when window is resized
        resizeWindow?.delegate = self
        
        print("Showing resize window")
        resizeWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

extension AppDelegate: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        if let window = notification.object as? NSWindow, window == resizeWindow {
            // Save the final size
            let size = window.frame.size
            AppSettings.shared.windowWidth = size.width
            AppSettings.shared.windowHeight = size.height
            resizeWindow = nil
        }
    }
    
    func windowDidResize(_ notification: Notification) {
        // Window resize tracking - size is saved on close
    }
}
