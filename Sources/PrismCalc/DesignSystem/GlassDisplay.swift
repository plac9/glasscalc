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
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // Calculator display uses fixed sizes - should not scale with Dynamic Type
    // to ensure numbers always fit properly on screen
    private let baseDisplaySize: CGFloat = 64
    private let baseExpressionSize: CGFloat = 18

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
                // Expression breadcrumb - expanded to show full calculation
                // Uses horizontal scroll for very long expressions
                ScrollView(.horizontal, showsIndicators: false) {
                    Text(expression.isEmpty ? " " : expression)
                        .font(.system(size: expressionFontSize, weight: .medium, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(GlassTheme.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.trailing)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .frame(minHeight: expressionFontSize * 1.2)
                .opacity(expression.isEmpty ? 0 : 1)
                .defaultScrollAnchor(.trailing)

                // Main value
                Text(value)
                    .font(.system(size: displayFontSize, weight: .light, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(GlassTheme.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .contentTransition(reduceMotion ? .identity : .numericText())
                    .animation(reduceMotion ? nil : .easeInOut(duration: GlassTheme.animationQuick), value: value)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.vertical, isIPad ? GlassTheme.spacingLarge : GlassTheme.spacingSmall)
            .padding(.horizontal, isIPad ? GlassTheme.spacingMedium : GlassTheme.spacingSmall)
            .animation(reduceMotion ? nil : .easeInOut(duration: GlassTheme.animationQuick), value: expression.isEmpty)
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
        case 0...6: return baseDisplaySize * baseMultiplier
        case 7...9: return baseDisplaySize * 0.8 * baseMultiplier
        case 10...12: return baseDisplaySize * 0.68 * baseMultiplier
        default: return baseDisplaySize * 0.56 * baseMultiplier
        }
    }

    private var expressionFontSize: CGFloat {
        let baseMultiplier: CGFloat = isIPad ? 1.55 : 1.0
        return baseExpressionSize * baseMultiplier
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
            GlassDisplay(value: "123.45", expression: "100 + 23.45 =")
            GlassDisplay(value: "1,234,567,890", expression: "1,000,000 + 234,567,890 =")
            GlassDisplay(value: "115", expression: "100 + 15% =")
        }
        .padding()
    }
}
