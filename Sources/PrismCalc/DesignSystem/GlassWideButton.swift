import SwiftUI
#if os(iOS)
import UIKit
#endif

// MARK: - Wide Button (for zero)

/// Glassmorphic wide button for the zero digit - spans two columns
public struct GlassWideButton: View {
    let label: String
    let accessibilityText: String
    let size: CGFloat
    let spacing: CGFloat
    let action: () -> Void

    #if os(iOS) && !targetEnvironment(macCatalyst)
    /// Shared generator to avoid reallocation on every tap
    private static let hapticGenerator: UIImpactFeedbackGenerator = {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()
    #endif

    @State private var isPressed = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.colorScheme) private var colorScheme
    @ScaledMetric(relativeTo: .title2) private var labelScale: CGFloat = 1.0

    private var isIncreasedContrast: Bool {
        if #available(iOS 17.0, macOS 14.0, *) {
            return colorSchemeContrast == .increased
        } else {
            #if os(iOS)
            return UIAccessibility.isDarkerSystemColorsEnabled
            #else
            return false
            #endif
        }
    }

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
        Button {
            triggerHaptic()
            action()
        } label: {
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
                    GlassTheme.glassCapsuleBackground(material: .thinMaterial, reduceTransparency: reduceTransparency)
                        .overlay(
                            Capsule()
                                .strokeBorder(
                                    GlassTheme.glassBorderGradient(
                                        reduceTransparency: reduceTransparency,
                                        increaseContrast: isIncreasedContrast
                                    ),
                                    lineWidth: GlassTheme.glassBorderLineWidth(
                                        reduceTransparency: reduceTransparency,
                                        increaseContrast: isIncreasedContrast
                                    )
                                )
                                .blendMode(GlassTheme.glassBorderBlendMode(for: colorScheme))
                        )
                )
                .shadow(color: Color.black.opacity(GlassTheme.glassShadowOpacityPrimary), radius: 8, y: 4)
                .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(WideButtonStyle(isPressed: $isPressed, reduceMotion: reduceMotion))
        .accessibilityLabel(accessibilityText)
        .accessibilityAddTraits(.isButton)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: isPressed)
        .contentShape(Rectangle())
        #if os(iOS)
        .hoverEffect(.highlight)
        #endif
    }

    private func triggerHaptic() {
        #if os(iOS) && !targetEnvironment(macCatalyst)
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
private struct WideButtonStyle: ButtonStyle {
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

        GlassWideButton("0") {}
            .padding()
    }
}
