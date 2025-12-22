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
    let accessibilityIdentifier: String?
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
        accessibilityIdentifier: String? = nil,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.style = style
        self.size = size
        self.accessibilityText = accessibilityLabel ?? Self.defaultAccessibilityLabel(for: label)
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    /// Returns default VoiceOver-friendly label for calculator button text.
    /// Internal for testability via @testable import.
    static func defaultAccessibilityLabel(for label: String) -> String {
        accessibilityLabels[label] ?? label
    }

    /// Dictionary mapping button labels to VoiceOver-friendly descriptions
    private static let accessibilityLabels: [String: String] = [
        "0": "Zero", "1": "One", "2": "Two", "3": "Three", "4": "Four",
        "5": "Five", "6": "Six", "7": "Seven", "8": "Eight", "9": "Nine",
        ".": "Decimal point", "+": "Plus", "-": "Minus", "x": "Multiply",
        "/": "Divide", "=": "Equals", "AC": "Clear all",
        "+/-": "Toggle positive negative", "%": "Percent"
    ]

    public var body: some View {
        Button {
            triggerHaptic()
            action()
        } label: {
            Text(label)
                .font(.system(size: buttonFontSize, weight: .medium, design: .rounded))
                .foregroundStyle(textColor)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .frame(width: size, height: size)
                .background(
                    GlassTheme.glassCircleBackground(material: style.material)
                        .overlay(
                            Circle()
                                .fill(overlayColor)
                        )
                        .overlay(
                            Circle()
                                .stroke(GlassTheme.glassBorderGradient, lineWidth: GlassTheme.glassBorderLineWidth)
                        )
                )
                .shadow(color: Color.black.opacity(GlassTheme.glassShadowOpacityPrimary), radius: 8, y: 4)
                .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(GlassButtonStyle(isPressed: $isPressed, reduceMotion: reduceMotion))
        .accessibilityLabel(accessibilityText)
        .accessibilityAddTraits(.isButton)
        .optionalAccessibilityIdentifier(accessibilityIdentifier)
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

// MARK: - Symbol Button (for icons like backspace)

/// Glassmorphic button with SF Symbol icon - matches GlassButton style
public struct GlassSymbolButton: View {
    let systemName: String
    let style: GlassButton.Style
    let size: CGFloat
    let accessibilityText: String
    let accessibilityIdentifier: String?
    let action: () -> Void

    #if os(iOS)
    private static let hapticGenerator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()
    #endif

    @State private var isPressed = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .title2) private var iconScale: CGFloat = 1.0

    public init(
        systemName: String,
        style: GlassButton.Style = .special,
        size: CGFloat = GlassTheme.buttonSize,
        accessibilityLabel: String,
        accessibilityIdentifier: String? = nil,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.style = style
        self.size = size
        self.accessibilityText = accessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button {
            triggerHaptic()
            action()
        } label: {
            Image(systemName: systemName)
                .font(.system(size: iconFontSize, weight: .medium))
                .foregroundStyle(textColor)
                .frame(width: size, height: size)
                .background(
                    GlassTheme.glassCircleBackground(material: style.material)
                        .overlay(
                            Circle()
                                .fill(overlayColor)
                        )
                        .overlay(
                            Circle()
                                .stroke(GlassTheme.glassBorderGradient, lineWidth: GlassTheme.glassBorderLineWidth)
                        )
                )
                .shadow(color: Color.black.opacity(GlassTheme.glassShadowOpacityPrimary), radius: 8, y: 4)
                .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(GlassButtonStyle(isPressed: $isPressed, reduceMotion: reduceMotion))
        .accessibilityLabel(accessibilityText)
        .accessibilityAddTraits(.isButton)
        .optionalAccessibilityIdentifier(accessibilityIdentifier)
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

    private var iconFontSize: CGFloat {
        size * 0.35 * iconScale
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

private struct OptionalAccessibilityIdentifier: ViewModifier {
    let identifier: String?

    func body(content: Content) -> some View {
        if let identifier, !identifier.isEmpty {
            content.accessibilityIdentifier(identifier)
        } else {
            content
        }
    }
}

private extension View {
    func optionalAccessibilityIdentifier(_ identifier: String?) -> some View {
        modifier(OptionalAccessibilityIdentifier(identifier: identifier))
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
            HStack(spacing: 12) {
                GlassButton("0", style: .number) {}
                GlassButton(".", style: .number) {}
            }
        }
        .padding()
    }
}
