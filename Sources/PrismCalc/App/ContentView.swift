import SwiftUI
#if os(iOS)
import UIKit
#endif

/// Main content view with iOS 18 floating tab bar and animated mesh gradient background
public struct ContentView: View {
    @State private var selectedTab: TabIdentifier = .calculator
    @AppStorage("tabCustomization") private var tabCustomization: TabViewCustomization

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
        .preferredColorScheme(.dark)
    }

    /// Tab content using iOS 18's new Tab API with sidebarAdaptable style
    @ViewBuilder
    private var tabContent: some View {
        TabView(selection: $selectedTab) {
            // Calculator - primary feature
            Tab("Calculator", systemImage: TabIdentifier.calculator.icon, value: .calculator) {
                CalculatorView()
            }
            .customizationID("tab.calculator")

            // Tip - Pro feature
            Tab("Tip", systemImage: TabIdentifier.tip.icon, value: .tip) {
                ProGatedView(featureName: "Tip Calculator", featureIcon: TabIdentifier.tip.icon) {
                    TipCalculatorView()
                }
            }
            .customizationID("tab.tip")

            // Discount - Pro feature
            Tab("Discount", systemImage: TabIdentifier.discount.icon, value: .discount) {
                ProGatedView(featureName: "Discount Calculator", featureIcon: TabIdentifier.discount.icon) {
                    DiscountCalculatorView()
                }
            }
            .customizationID("tab.discount")

            // Split - Pro feature
            Tab("Split", systemImage: TabIdentifier.split.icon, value: .split) {
                ProGatedView(featureName: "Split Bill", featureIcon: TabIdentifier.split.icon) {
                    SplitBillView()
                }
            }
            .customizationID("tab.split")

            // Convert - Pro feature
            Tab("Convert", systemImage: TabIdentifier.convert.icon, value: .convert) {
                ProGatedView(featureName: "Unit Converter", featureIcon: TabIdentifier.convert.icon) {
                    UnitConverterView()
                }
            }
            .customizationID("tab.convert")

            // History - Free (last 10), Pro (unlimited)
            Tab("History", systemImage: TabIdentifier.history.icon, value: .history) {
                HistoryView()
            }
            .customizationID("tab.history")

            // Settings
            Tab("Settings", systemImage: TabIdentifier.settings.icon, value: .settings) {
                SettingsView()
            }
            .customizationID("tab.settings")
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabViewCustomization($tabCustomization)
        .tint(GlassTheme.primary)
        .sensoryFeedback(.selection, trigger: selectedTab)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
