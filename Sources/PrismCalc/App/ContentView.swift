import SwiftUI
#if os(iOS)
import UIKit
#endif

/// Main content view with iOS 18 floating tab bar and animated mesh gradient background
public struct ContentView: View {
    @State private var selectedTab: TabIdentifier = .calculator
    @AppStorage("tabCustomization") private var tabCustomization: TabViewCustomization
    @AppStorage("selectedTheme") private var selectedThemeName: String = GlassTheme.Theme.aurora.rawValue
    @State private var didApplyDebugTab = false

    private static let debugSelectedTabKey = "debug_selectedTab"

    /// Current theme derived from stored name, forces re-render when changed
    private var currentTheme: GlassTheme.Theme {
        GlassTheme.Theme(rawValue: selectedThemeName) ?? .aurora
    }

    public init() {}

    /// Tab identifiers for navigation
    public enum TabIdentifier: String, CaseIterable, Hashable {
        case calculator = "Calculator"
        case history = "History"
        case tip = "Tip"
        case discount = "Discount"
        case split = "Split"
        case convert = "Convert"
        case settings = "Settings"

        var icon: String {
            switch self {
            case .calculator: return "plus.forwardslash.minus"
            case .history: return "clock.arrow.circlepath"
            case .tip: return "dollarsign.circle"
            case .discount: return "tag"
            case .split: return "person.2"
            case .convert: return "arrow.left.arrow.right"
            case .settings: return "gearshape"
            }
        }

        var isPro: Bool {
            switch self {
            case .calculator, .settings, .history: return false
            case .tip, .discount, .split, .convert: return true
            }
        }
    }

    public var body: some View {
        ZStack {
            // Animated mesh gradient background (iOS 18+)
            ThemedMeshBackground()
                .ignoresSafeArea()

            // iOS 18 Tab-based navigation with floating tab bar
            tabContent
        }
        // Force full re-render when theme changes by using theme as view identity
        .id(currentTheme)
        .onAppear {
            applyDebugSelectedTabIfNeeded()
            syncTheme()
        }
        .onChange(of: selectedThemeName) { _, _ in
            syncTheme()
        }
    }

    /// Sync the static GlassTheme.currentTheme with stored value
    @MainActor
    private func syncTheme() {
        GlassTheme.currentTheme = currentTheme
    }

    /// Tab content using iOS 18's new Tab API with sidebarAdaptable style
    /// Order: Calculator (locked) → Pro features (Tip, Split, Discount, Convert) → History → Settings
    @ViewBuilder
    private var tabContent: some View {
        TabView(selection: $selectedTab) {
            // Calculator - primary feature (locked, cannot be moved or hidden)
            Tab("Calculator", systemImage: TabIdentifier.calculator.icon, value: .calculator) {
                CalculatorView()
            }
            .customizationID("tab.calculator")
            #if os(iOS)
            .customizationBehavior(.disabled, for: .sidebar, .tabBar)
            #endif
            .accessibilityIdentifier("tab-calculator")

            // Tip - Pro feature (most common after basic calc)
            Tab("Tip", systemImage: TabIdentifier.tip.icon, value: .tip) {
                ProGatedView(featureName: "Tip Calculator", featureIcon: TabIdentifier.tip.icon) {
                    TipCalculatorView()
                }
            }
            .customizationID("tab.tip")
            .accessibilityIdentifier("tab-tip")

            // Split - Pro feature (common dining scenario)
            Tab("Split", systemImage: TabIdentifier.split.icon, value: .split) {
                ProGatedView(featureName: "Split Bill", featureIcon: TabIdentifier.split.icon) {
                    SplitBillView()
                }
            }
            .customizationID("tab.split")
            .accessibilityIdentifier("tab-split")

            // Discount - Pro feature
            Tab("Discount", systemImage: TabIdentifier.discount.icon, value: .discount) {
                ProGatedView(featureName: "Discount Calculator", featureIcon: TabIdentifier.discount.icon) {
                    DiscountCalculatorView()
                }
            }
            .customizationID("tab.discount")
            .accessibilityIdentifier("tab-discount")

            // Convert - Pro feature
            Tab("Convert", systemImage: TabIdentifier.convert.icon, value: .convert) {
                ProGatedView(featureName: "Unit Converter", featureIcon: TabIdentifier.convert.icon) {
                    UnitConverterView()
                }
            }
            .customizationID("tab.convert")
            .accessibilityIdentifier("tab-convert")

            // History - reference view
            Tab("History", systemImage: TabIdentifier.history.icon, value: .history) {
                HistoryView()
            }
            .customizationID("tab.history")
            .accessibilityIdentifier("tab-history")

            // Settings - least frequently accessed
            Tab("Settings", systemImage: TabIdentifier.settings.icon, value: .settings) {
                SettingsView()
            }
            .customizationID("tab.settings")
            .accessibilityIdentifier("tab-settings")
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewCustomization($tabCustomization)
        .tint(GlassTheme.primary)
        .sensoryFeedback(.selection, trigger: selectedTab)
    }

    private func applyDebugSelectedTabIfNeeded() {
        guard !didApplyDebugTab else { return }
        didApplyDebugTab = true

        if let tabName = UserDefaults.standard.string(forKey: Self.debugSelectedTabKey),
           let tab = TabIdentifier(rawValue: tabName) {
            selectedTab = tab
        }
        UserDefaults.standard.removeObject(forKey: Self.debugSelectedTabKey)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
