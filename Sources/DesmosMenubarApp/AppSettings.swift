import Foundation
import Combine

class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    private let defaults = UserDefaults.standard
    
    // Window size settings
    @Published var windowWidth: Double {
        didSet {
            defaults.set(windowWidth, forKey: "windowWidth")
        }
    }
    
    @Published var windowHeight: Double {
        didSet {
            defaults.set(windowHeight, forKey: "windowHeight")
        }
    }
    
    // State persistence setting
    @Published var persistState: Bool {
        didSet {
            defaults.set(persistState, forKey: "persistState")
        }
    }
    
    private init() {
        // Load defaults or use initial values
        self.windowWidth = defaults.object(forKey: "windowWidth") as? Double ?? 400.0
        self.windowHeight = defaults.object(forKey: "windowHeight") as? Double ?? 500.0
        self.persistState = defaults.object(forKey: "persistState") as? Bool ?? true
    }
    
    var windowSize: NSSize {
        NSSize(width: windowWidth, height: windowHeight)
    }
}
