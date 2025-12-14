import SwiftUI

/// Calculator display with glass background and animated text
///
/// Features:
/// - Auto-sizing text that shrinks for long numbers
/// - Expression line showing the calculation
/// - Animated transitions between values
/// - iPad-optimized typography and spacing
public struct GlassDisplay: View {
    let value: String
    let expression: String
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    public init(value: String, expression: String = "") {
        self.value = value
        self.expression = expression
    }

    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }

    public var body: some View {
        GlassCard(material: .ultraThinMaterial, cornerRadius: GlassTheme.cornerRadiusLarge) {
            VStack(alignment: .trailing, spacing: isIPad ? GlassTheme.spacingMedium : GlassTheme.spacingXS) {
                // Expression line (always takes up space, even when empty)
                Text(expression.isEmpty ? " " : expression)
                    .font(.system(size: isIPad ? 28 : 18, weight: .regular, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(GlassTheme.textTertiary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .opacity(expression.isEmpty ? 0 : 1)

                // Main value
                Text(value)
                    .font(.system(size: displayFontSize, weight: .light, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(GlassTheme.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: GlassTheme.animationQuick), value: value)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.vertical, isIPad ? GlassTheme.spacingLarge : GlassTheme.spacingSmall)
            .padding(.horizontal, isIPad ? GlassTheme.spacingMedium : GlassTheme.spacingSmall)
            .animation(.easeInOut(duration: GlassTheme.animationQuick), value: expression.isEmpty)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
        .accessibilityValue(value)
    }

    private var accessibilityDescription: String {
        if expression.isEmpty {
            return "Calculator display showing \(value)"
        } else {
            return "\(expression) equals \(value)"
        }
    }

    private var displayFontSize: CGFloat {
        let baseMultiplier: CGFloat = isIPad ? 1.5 : 1.0

        switch value.count {
        case 0...6: return 64 * baseMultiplier
        case 7...9: return 52 * baseMultiplier
        case 10...12: return 44 * baseMultiplier
        default: return 36 * baseMultiplier
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        LinearGradient(
            colors: GlassTheme.auroraGradient,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack(spacing: 20) {
            GlassDisplay(value: "0")
            GlassDisplay(value: "123.45", expression: "100 + 23.45")
            GlassDisplay(value: "1,234,567,890", expression: "Long number")
        }
        .padding()
    }
}
