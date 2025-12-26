import SwiftUI
import TipKit
#if os(macOS)
import AppKit
#endif

/// PrismCalc App Scene Configuration
///
/// A spectacular glassmorphic calculator for iOS.
/// Part of the LaClair Tech suite.
///
/// Usage in your iOS app:
/// ```swift
/// @main
/// struct MyApp: App {
///     var body: some Scene {
///         PrismCalcApp.scene
///     }
/// }
/// ```
@MainActor
public enum PrismCalcApp {
    private static var didHandleLaunchArguments = false
    #if os(macOS)
    private static let macWindowMinSize = CGSize(width: 320, height: 560)
    private static let macWindowDefaultSize = CGSize(width: 320, height: 560)
    #endif

    /// The main app scene
    public static var scene: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    TipKitConfiguration.configure()
                }
                .onAppear {
                    handleLaunchArgumentsIfNeeded()
                    #if os(macOS)
                    applyMacWindowSizing()
                    #endif
                }
                #if os(macOS)
                .frame(minWidth: macWindowMinSize.width, minHeight: macWindowMinSize.height)
                #endif
        }
        #if os(macOS)
        .defaultSize(width: macWindowDefaultSize.width, height: macWindowDefaultSize.height)
        .windowStyle(.hiddenTitleBar)
        #endif
    }

    /// Handle launch arguments for UI testing
    private static func handleLaunchArgumentsIfNeeded() {
        guard !didHandleLaunchArguments else { return }
        didHandleLaunchArguments = true
        handleLaunchArguments()
    }

    private static func handleLaunchArguments() {
        let arguments = ProcessInfo.processInfo.arguments

        // Screenshot mode - disable animations
        if arguments.contains("SCREENSHOT_MODE") {
            #if os(iOS)
            UIView.setAnimationsEnabled(false)
            #endif
        }

        // Simulate Pro purchase for testing
        if arguments.contains("SIMULATE_PRO") {
            UserDefaults.standard.set(true, forKey: "debug_simulatePro")
        }

        // Reset purchases for free tier testing
        if arguments.contains("RESET_PURCHASES") {
            UserDefaults.standard.removeObject(forKey: "debug_simulatePro")
        }

        // Set specific theme
        if let themeArg = arguments.first(where: { $0.hasPrefix("PRESET_THEME:") }) {
            let themeName = themeArg.replacingOccurrences(of: "PRESET_THEME:", with: "")
            if let theme = GlassTheme.Theme(rawValue: themeName) {
                GlassTheme.currentTheme = theme
            }
        }

        if let tabArg = arguments.first(where: { $0.hasPrefix("SELECT_TAB:") }) {
            let tabName = tabArg.replacingOccurrences(of: "SELECT_TAB:", with: "")
            UserDefaults.standard.set(tabName, forKey: "debug_selectedTab")
        }

        // Populate sample data
        if arguments.contains("POPULATE_DATA") {
            populateSampleData()
        }
    }

    #if os(macOS)
    private static func applyMacWindowSizing() {
        DispatchQueue.main.async {
            guard let window = NSApplication.shared.windows.first else { return }
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true
        }
    }
    #endif

    /// Populate sample history data for testing
    private static func populateSampleData() {
        let sampleEntries = [
            HistoryEntry(calculationType: .tip, result: "$15.00", details: "20% tip on $75.00"),
            HistoryEntry(calculationType: .discount, result: "$75.00", details: "25% off $100.00"),
            HistoryEntry(calculationType: .split, result: "$25.00", details: "$100.00 split 4 ways"),
            HistoryEntry(calculationType: .basic, result: "1,234.56", details: "1000 + 234.56"),
            HistoryEntry(calculationType: .tip, result: "$9.00", details: "18% tip on $50.00"),
            HistoryEntry(calculationType: .discount, result: "$42.50", details: "15% off $50.00"),
            HistoryEntry(calculationType: .split, result: "$16.67", details: "$50.00 split 3 ways"),
            HistoryEntry(calculationType: .basic, result: "567.89", details: "500 + 67.89"),
            HistoryEntry(calculationType: .tip, result: "$12.00", details: "20% tip on $60.00"),
            HistoryEntry(calculationType: .basic, result: "999.99", details: "900 + 99.99"),
            HistoryEntry(calculationType: .tip, result: "$7.50", details: "15% tip on $50.00"),
            HistoryEntry(calculationType: .discount, result: "$80.00", details: "20% off $100.00")
        ]

        for entry in sampleEntries {
            HistoryService.shared.save(entry)
        }
    }
}
