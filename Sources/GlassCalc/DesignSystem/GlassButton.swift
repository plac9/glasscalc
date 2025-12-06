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
    let action: () -> Void

    @State private var isPressed = false

    public init(
        _ label: String,
        style: Style = .number,
        size: CGFloat = GlassTheme.buttonSize,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.style = style
        self.size = size
        self.action = action
    }

    public var body: some View {
        Button(action: {
            triggerHaptic()
            action()
        }) {
            Text(label)
                .font(.system(size: size * 0.4, weight: .medium, design: .rounded))
                .foregroundStyle(textColor)
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
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(GlassTheme.buttonSpring) {
                isPressed = pressing
            }
        }, perform: {})
    }

    private var textColor: Color {
        switch style {
        case .equals:
            return .white
        default:
            return GlassTheme.text
        }
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
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }
}

// MARK: - Wide Button (for zero)

public struct GlassWideButton: View {
    let label: String
    let action: () -> Void

    @State private var isPressed = false

    public init(_ label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }

    public var body: some View {
        Button(action: {
            triggerHaptic()
            action()
        }) {
            Text(label)
                .font(.system(size: GlassTheme.buttonSize * 0.4, weight: .medium, design: .rounded))
                .foregroundStyle(GlassTheme.text)
                .frame(
                    width: GlassTheme.buttonSize * 2 + GlassTheme.spacingSmall,
                    height: GlassTheme.buttonSize
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
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(GlassTheme.buttonSpring) {
                isPressed = pressing
            }
        }, perform: {})
    }

    private func triggerHaptic() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
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
