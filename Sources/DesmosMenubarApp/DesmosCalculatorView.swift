import SwiftUI
import WebKit

struct DesmosCalculatorView: View {
    @ObservedObject var settings = AppSettings.shared
    @State private var showFirstLaunchHint = false
    
    var body: some View {
        ZStack {
            WebView(url: "https://www.desmos.com/calculator", persistState: settings.persistState)
                .frame(minWidth: settings.windowWidth, minHeight: settings.windowHeight)
            
            // First launch hint overlay
            if showFirstLaunchHint {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("💡")
                                    .font(.title2)
                                Text("Welcome!")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation {
                                        showFirstLaunchHint = false
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                                .buttonStyle(.plain)
                            }
                            
                            Text("Right-click the menu icon to access Settings or Quit.")
                                .font(.subheadline)
                            
                            Text("Left-click the icon to open/close the calculator.")
                                .font(.subheadline)
                        }
                        .padding()
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .onAppear {
            checkFirstLaunch()
        }
    }
    
    func checkFirstLaunch() {
        let defaults = UserDefaults.standard
        let hasLaunchedBefore = defaults.bool(forKey: "hasLaunchedBefore")
        
        if !hasLaunchedBefore {
            // Mark as launched
            defaults.set(true, forKey: "hasLaunchedBefore")
            
            // Show hint after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showFirstLaunchHint = true
                }
                
                // Auto-hide after 8 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                    withAnimation {
                        showFirstLaunchHint = false
                    }
                }
            }
        }
    }
}

struct WebView: NSViewRepresentable {
    let url: String
    let persistState: Bool
    
    func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        
        // Set up for state persistence if enabled
        if persistState {
            // Use a persistent data store to maintain state
            configuration.websiteDataStore = WKWebsiteDataStore.default()
        } else {
            // Use non-persistent data store to start fresh each time
            configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        }
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        
        // Load the Desmos calculator
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        // Note: Changing data store requires recreating the web view
        // For now, the setting takes effect on next app launch or popover recreation
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(persistState: persistState)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let persistState: Bool
        
        init(persistState: Bool) {
            self.persistState = persistState
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Allow all navigation
            decisionHandler(.allow)
        }
    }
}
