import SwiftUI
import AppKit

struct SettingsView: View {
    @ObservedObject var settings = AppSettings.shared
    @Environment(\.dismiss) var dismiss
    var appDelegate: AppDelegate?
    
    init(appDelegate: AppDelegate? = nil) {
        self.appDelegate = appDelegate
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Desmos Calculator Settings")
                .font(.title2)
                .fontWeight(.bold)
            
            Divider()
            
            // Window Size Settings
            VStack(alignment: .leading, spacing: 12) {
                Text("Window Size")
                    .font(.headline)
                
                Button("Resize by Dragging...") {
                    // Try appDelegate parameter first, then shared, then notification
                    if let delegate = appDelegate {
                        delegate.openResizeWindow()
                    } else if let delegate = AppDelegate.shared {
                        delegate.openResizeWindow()
                    } else {
                        NotificationCenter.default.post(name: NSNotification.Name("OpenResizeWindow"), object: nil)
                    }
                }
                .buttonStyle(.bordered)
                
                Text("Current size: \(Int(settings.windowWidth)) × \(Int(settings.windowHeight)) px")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Click the button above to open a resizable window. Drag the edges to resize, then close to save.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Divider()
            
            // State Persistence Setting
            VStack(alignment: .leading, spacing: 12) {
                Text("State Persistence")
                    .font(.headline)
                
                Toggle("Save calculator state when closed", isOn: $settings.persistState)
                
                Text(settings.persistState ? 
                     "Calculator will remember your graphs and equations when reopened." :
                     "Calculator will start fresh each time you open it.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button("Done") {
                    if let window = NSApplication.shared.windows.first(where: { $0.title == "Desmos Calculator Settings" }) {
                        window.close()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
        .frame(width: 400, height: 250)
    }
}
