import SwiftUI
#if os(iOS)
import UIKit
#endif

/// Main content view with tab navigation and animated gradient background
public struct ContentView: View {
    @State private var selectedTab: Tab = .calculator
    @State private var animateGradient = false

    public init() {}

    public enum Tab: String, CaseIterable {
        case calculator = "Calculator"
        case tip = "Tip"
        case discount = "Discount"
        case split = "Split"
        case convert = "Convert"
        case history = "History"
        case settings = "Settings"

        var icon: String {
            switch self {
            case .calculator: return "plus.forwardslash.minus"
            case .tip: return "dollarsign.circle"
            case .discount: return "tag"
            case .split: return "person.2"
            case .convert: return "arrow.left.arrow.right"
            case .history: return "clock.arrow.circlepath"
            case .settings: return "gearshape"
            }
        }

        var isPro: Bool {
            switch self {
            case .calculator, .settings: return false
            case .tip, .discount, .split, .convert, .history: return true
            }
        }
    }

    public var body: some View {
        ZStack {
            // Animated gradient background
            backgroundGradient
                .ignoresSafeArea()

            // Tab Content
            TabView(selection: $selectedTab) {
                CalculatorView()
                    .tag(Tab.calculator)
                    .tabItem {
                        Label(Tab.calculator.rawValue, systemImage: Tab.calculator.icon)
                    }

                ProGatedView(featureName: "Tip Calculator", featureIcon: Tab.tip.icon) {
                    TipCalculatorView()
                }
                .tag(Tab.tip)
                .tabItem {
                    Label(Tab.tip.rawValue, systemImage: Tab.tip.icon)
                }

                ProGatedView(featureName: "Discount Calculator", featureIcon: Tab.discount.icon) {
                    DiscountCalculatorView()
                }
                .tag(Tab.discount)
                .tabItem {
                    Label(Tab.discount.rawValue, systemImage: Tab.discount.icon)
                }

                ProGatedView(featureName: "Split Bill", featureIcon: Tab.split.icon) {
                    SplitBillView()
                }
                .tag(Tab.split)
                .tabItem {
                    Label(Tab.split.rawValue, systemImage: Tab.split.icon)
                }

                ProGatedView(featureName: "Unit Converter", featureIcon: Tab.convert.icon) {
                    UnitConverterView()
                }
                .tag(Tab.convert)
                .tabItem {
                    Label(Tab.convert.rawValue, systemImage: Tab.convert.icon)
                }

                ProGatedView(featureName: "History", featureIcon: Tab.history.icon) {
                    HistoryView()
                }
                .tag(Tab.history)
                .tabItem {
                    Label(Tab.history.rawValue, systemImage: Tab.history.icon)
                }

                SettingsView()
                    .tag(Tab.settings)
                    .tabItem {
                        Label(Tab.settings.rawValue, systemImage: Tab.settings.icon)
                    }
            }
            .tint(GlassTheme.primary)
            .sensoryFeedback(.selection, trigger: selectedTab)
        }
        .onAppear {
            #if os(iOS)
            // Transparent tab bar background for glass effect
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            #endif

            // Start gradient animation
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                animateGradient = true
            }
        }
        .preferredColorScheme(.dark)
    }

    @MainActor
    private var backgroundGradient: some View {
        LinearGradient(
            colors: GlassTheme.backgroundGradient,
            startPoint: animateGradient ? .topLeading : .bottomLeading,
            endPoint: animateGradient ? .bottomTrailing : .topTrailing
        )
        .overlay(
            Color.white.opacity(0.02)
                .blendMode(.overlay)
        )
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
