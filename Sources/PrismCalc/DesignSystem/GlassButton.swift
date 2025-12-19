import SwiftUI

/// Glassmorphic button with haptic feedback and press animation
///
/// Supports different styles for calculator operations:
/// - `.number` - Standard digit buttons
/// - `.operation` - Math operations (+, -, *, /)
/// - `.special` - AC, +/-, %
/// - `.equals` - Equals button with accent color
public struct GlassButton: View {
    public enum Style {
        case number
        case operation
        case special
        case equals

        var material: Material {
            switch self {
            case .number: return .thinMaterial
            case .operation: return .regularMaterial
            case .special: return .ultraThinMaterial
            case .equals: return .regularMaterial
            }
        }
    }

    let label: String
    let style: Style
    let size: CGFloat
    let accessibilityText: String
    let action: () -> Void

    #if os(iOS)
    /// Shared generator to avoid reallocation on every tap
    private static let hapticGenerator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()
    #endif

    @State private var isPressed = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .title2) private var labelScale: CGFloat = 1.0

    public init(
        _ label: String,
        style: Style = .number,
        size: CGFloat = GlassTheme.buttonSize,
        accessibilityLabel: String? = nil,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.style = style
        self.size = size
        self.accessibilityText = accessibilityLabel ?? Self.defaultAccessibilityLabel(for: label)
        self.action = action
    }

    private static func defaultAccessibilityLabel(for label: String) -> String {
        switch label {
        case "0": return "Zero"
        case "1": return "One"
        case "2": return "Two"
        case "3": return "Three"
        case "4": return "Four"
        case "5": return "Five"
        case "6": return "Six"
        case "7": return "Seven"
        case "8": return "Eight"
        case "9": return "Nine"
        case ".": return "Decimal point"
        case "+": return "Plus"
        case "-": return "Minus"
        case "x": return "Multiply"
        case "/": return "Divide"
        case "=": return "Equals"
        case "AC": return "Clear all"
        case "+/-": return "Toggle positive negative"
        case "%": return "Percent"
        default: return label
        }
    }

    public var body: some View {
        Button(action: {
            triggerHaptic()
            action()
        }) {
            Text(label)
                .font(.system(size: buttonFontSize, weight: .medium, design: .rounded))
                .foregroundStyle(textColor)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(style.material)
                        .overlay(
                            Circle()
                                .fill(overlayColor)
                        )
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.4),
                                            Color.white.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 8, y: 4)
                .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(GlassButtonStyle(isPressed: $isPressed, reduceMotion: reduceMotion))
        .accessibilityLabel(accessibilityText)
        .accessibilityAddTraits(.isButton)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: isPressed)
        .contentShape(Rectangle())
        #if os(iOS)
        .hoverEffect(.highlight)
        #endif
    }

    private var textColor: Color {
        switch style {
        case .equals:
            return .white
        default:
            return GlassTheme.text
        }
    }

    private var buttonFontSize: CGFloat {
        size * 0.4 * labelScale
    }

    @MainActor
    private var overlayColor: Color {
        switch style {
        case .equals:
            return GlassTheme.primary.opacity(0.8)
        case .operation:
            return GlassTheme.secondary.opacity(0.2)
        default:
            return .clear
        }
    }

    private func triggerHaptic() {
        #if os(iOS)
        let generator = Self.hapticGenerator
        generator.impactOccurred()
        generator.prepare()
        #endif
    }
}

// MARK: - Wide Button (for zero)

public struct GlassWideButton: View {
    let label: String
    let accessibilityText: String
    let size: CGFloat
    let spacing: CGFloat
    let action: () -> Void

    #if os(iOS)
    /// Shared generator to avoid reallocation on every tap
    private static let hapticGenerator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()
    #endif

    @State private var isPressed = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .title2) private var labelScale: CGFloat = 1.0

    public init(
        _ label: String,
        size: CGFloat = GlassTheme.buttonSize,
        spacing: CGFloat = GlassTheme.spacingSmall,
        accessibilityLabel: String? = nil,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.accessibilityText = accessibilityLabel ?? (label == "0" ? "Zero" : label)
        self.size = size
        self.spacing = spacing
        self.action = action
    }

    public var body: some View {
        Button(action: {
            triggerHaptic()
            action()
        }) {
            Text(label)
                .font(.system(size: buttonFontSize, weight: .medium, design: .rounded))
                .foregroundStyle(GlassTheme.text)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .frame(
                    width: size * 2 + spacing,
                    height: size
                )
                .background(
                    Capsule()
                        .fill(.thinMaterial)
                        .overlay(
                            Capsule()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.4),
                                            Color.white.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 8, y: 4)
                .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(GlassButtonStyle(isPressed: $isPressed, reduceMotion: reduceMotion))
        .accessibilityLabel(accessibilityText)
        .accessibilityAddTraits(.isButton)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: isPressed)
        .contentShape(Rectangle())
        #if os(iOS)
        .hoverEffect(.highlight)
        #endif
    }

    private func triggerHaptic() {
        #if os(iOS)
        let generator = Self.hapticGenerator
        generator.impactOccurred()
        generator.prepare()
        #endif
    }

    private var buttonFontSize: CGFloat {
        size * 0.4 * labelScale
    }
}

// MARK: - Button Style

/// Custom button style that responds instantly to touch
private struct GlassButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    let reduceMotion: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, newValue in
                if reduceMotion {
                    isPressed = newValue
                } else {
                    withAnimation(GlassTheme.buttonSpring) {
                        isPressed = newValue
                    }
                }
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
            HStack(spacing: 12) {
                GlassButton("7", style: .number) {}
                GlassButton("8", style: .number) {}
                GlassButton("9", style: .number) {}
                GlassButton("+", style: .operation) {}
            }
            HStack(spacing: 12) {
                GlassButton("AC", style: .special) {}
                GlassButton("+/-", style: .special) {}
                GlassButton("%", style: .special) {}
                GlassButton("=", style: .equals) {}
            }
            GlassWideButton("0") {}
        }
        .padding()
    }
}
