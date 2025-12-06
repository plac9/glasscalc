import SwiftUI

/// Main content view with animated gradient background
///
/// Provides the glassmorphism foundation layer that all views sit on.
/// Future: Will include tab bar for Pro features (Tip, Discount, Split, Convert)
public struct ContentView: View {
    @State private var animateGradient = false

    public init() {}

    public var body: some View {
        ZStack {
            // Animated gradient background
            backgroundGradient
                .ignoresSafeArea()

            // Calculator (default view)
            CalculatorView()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                animateGradient = true
            }
        }
        .preferredColorScheme(.dark) // Glass looks best on dark
    }

    @MainActor
    private var backgroundGradient: some View {
        LinearGradient(
            colors: GlassTheme.backgroundGradient,
            startPoint: animateGradient ? .topLeading : .bottomLeading,
            endPoint: animateGradient ? .bottomTrailing : .topTrailing
        )
        .overlay(
            // Subtle noise texture for depth
            Color.white.opacity(0.02)
                .blendMode(.overlay)
        )
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
