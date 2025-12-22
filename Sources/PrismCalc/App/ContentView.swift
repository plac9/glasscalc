import SwiftUI
#if os(iOS)
import UIKit
#endif

/// Main content view with iOS 18 floating tab bar and animated mesh gradient background
public struct ContentView: View {
    @State private var selectedTab: TabIdentifier = .calculator
    @AppStorage("tabCustomization") private var tabCustomization: TabViewCustomization
    @AppStorage("selectedTheme") private var selectedThemeName: String = GlassTheme.Theme.aurora.rawValue
    @AppStorage(AccessibilityTheme.highContrastKey) private var highContrastUI: Bool = false
    @State private var didApplyDebugTab = false

    private static let debugSelectedTabKey = "debug_selectedTab"

    /// Current theme derived from stored name, forces re-render when changed
    private var currentTheme: GlassTheme.Theme {
        GlassTheme.Theme(rawValue: selectedThemeName) ?? .aurora
    }

    public init() {
        // Make TabView background transparent to show mesh gradient
        #if os(iOS)
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        #endif
    }

    /// Tab identifiers for navigation
    /// Limited to 5 tabs to avoid system "More" overflow (which lacks themed background)
    public enum TabIdentifier: String, CaseIterable, Hashable {
        case calculator = "Calculator"
        case tip = "Tip"
        case split = "Split"
        case discount = "Discount"
        case more = "More"

        var icon: String {
            switch self {
            case .calculator: return "plus.forwardslash.minus"
            case .tip: return "dollarsign.circle"
            case .split: return "person.2"
            case .discount: return "tag"
            case .more: return "ellipsis.circle"
            }
        }

        var isPro: Bool {
            switch self {
            case .calculator, .more: return false
            case .tip, .discount, .split: return true
            }
        }
    }

    public var body: some View {
        tabContent
            // Force full re-render when theme changes by using theme as view identity
            .id("\(currentTheme.rawValue)-\(highContrastUI)")
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

    /// Tab content using iOS 18's new Tab API
    /// Limited to 5 tabs to fit on iPhone tab bar without system "More" overflow
    /// Order: Calculator → Pro features (Tip, Split, Discount) → More (Convert, History, Settings)
    @ViewBuilder
    private var tabContent: some View {
        TabView(selection: $selectedTab) {
            // Calculator - primary feature (locked, cannot be moved or hidden)
            Tab("Calculator", systemImage: TabIdentifier.calculator.icon, value: .calculator) {
                ThemedContent {
                    CalculatorView()
                }
            }
            .customizationID("tab.calculator")
            #if os(iOS)
            .customizationBehavior(.disabled, for: .sidebar, .tabBar)
            #endif
            .accessibilityIdentifier("tab-calculator")

            // Tip - Pro feature (most common after basic calc)
            Tab("Tip", systemImage: TabIdentifier.tip.icon, value: .tip) {
                ThemedContent {
                    ProGatedView(featureName: "Tip Calculator", featureIcon: TabIdentifier.tip.icon) {
                        TipCalculatorView()
                    }
                }
            }
            .customizationID("tab.tip")
            .accessibilityIdentifier("tab-tip")

            // Split - Pro feature (common dining scenario)
            Tab("Split", systemImage: TabIdentifier.split.icon, value: .split) {
                ThemedContent {
                    ProGatedView(featureName: "Split Bill", featureIcon: TabIdentifier.split.icon) {
                        SplitBillView()
                    }
                }
            }
            .customizationID("tab.split")
            .accessibilityIdentifier("tab-split")

            // Discount - Pro feature
            Tab("Discount", systemImage: TabIdentifier.discount.icon, value: .discount) {
                ThemedContent {
                    ProGatedView(featureName: "Discount Calculator", featureIcon: TabIdentifier.discount.icon) {
                        DiscountCalculatorView()
                    }
                }
            }
            .customizationID("tab.discount")
            .accessibilityIdentifier("tab-discount")

            // More - contains Convert, History, Settings with themed navigation
            // MoreView has its own embedded ThemedMeshBackground to work with NavigationStack
            Tab("More", systemImage: TabIdentifier.more.icon, value: .more) {
                MoreView()
            }
            .customizationID("tab.more")
            .accessibilityIdentifier("tab-more")
        }
        .tabViewCustomization($tabCustomization)
        #if os(iOS)
        .toolbarBackgroundVisibility(.hidden, for: .tabBar)
        #endif
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

// MARK: - Themed Content Wrapper

/// Wraps content with the themed mesh gradient background
struct ThemedContent<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            ThemedMeshBackground()
                .ignoresSafeArea()
            content()
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
