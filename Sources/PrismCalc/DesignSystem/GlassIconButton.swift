import SwiftUI

/// Glassmorphic button with SF Symbol and iOS 18 symbol effects
///
/// Supports SF Symbol 6 animation effects:
/// - `.bounce` - Bounce on tap
/// - `.wiggle` - Wiggle motion
/// - `.breathe` - Gentle breathing
/// - `.rotate` - Rotation effect
public struct GlassIconButton: View {
    public enum Style {
        case primary     // Accent colored fill
        case secondary   // Material with tint
        case plain       // Plain material
        case destructive // Red accent
    }

    public enum SymbolAnimation {
        case bounce
        case wiggle
        case breathe
        case rotate
        case pulse
        case none
    }

    let icon: String
    let style: Style
    let size: CGFloat
    let symbolAnimation: SymbolAnimation
    let accessibilityLabel: String
    let action: () -> Void

    @State private var isPressed = false
    @State private var animationTrigger = false
    @ScaledMetric(relativeTo: .title3) private var iconScale: CGFloat = 1.0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityIncreaseContrast) private var increaseContrast

    public init(
        icon: String,
        style: Style = .secondary,
        size: CGFloat = 44,
        symbolAnimation: SymbolAnimation = .bounce,
        accessibilityLabel: String,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.style = style
        self.size = size
        self.symbolAnimation = symbolAnimation
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }

    public var body: some View {
        Button {
            animationTrigger.toggle()
            triggerHaptic()
            action()
        } label: {
            iconView
                .font(.system(size: scaledIconSize, weight: .medium))
                .foregroundStyle(foregroundColor)
                .frame(width: scaledSize, height: scaledSize)
                .background(backgroundView)
                .shadow(color: Color.black.opacity(GlassTheme.glassShadowOpacityPrimary), radius: 6, y: 3)
                .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.isButton)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: animationTrigger)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            if reduceMotion {
                isPressed = pressing
            } else {
                withAnimation(GlassTheme.buttonSpring) {
                    isPressed = pressing
                }
            }
        }, perform: {})
    }

    /// Icon with SF Symbol animation effects (respects reduce motion)
    @ViewBuilder
    private var iconView: some View {
        // When reduce motion is enabled, skip all symbol effects
        if reduceMotion {
            Image(systemName: icon)
        } else {
            switch symbolAnimation {
            case .bounce:
                Image(systemName: icon)
                    .symbolEffect(.bounce, value: animationTrigger)
            case .wiggle:
                Image(systemName: icon)
                    .symbolEffect(.wiggle, value: animationTrigger)
            case .breathe:
                Image(systemName: icon)
                    .symbolEffect(.breathe, value: animationTrigger)
            case .rotate:
                Image(systemName: icon)
                    .symbolEffect(.rotate, value: animationTrigger)
            case .pulse:
                Image(systemName: icon)
                    .symbolEffect(.pulse, value: animationTrigger)
            case .none:
                Image(systemName: icon)
            }
        }
    }

    @MainActor
    private var foregroundColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return GlassTheme.primary
        case .plain:
            return GlassTheme.text
        case .destructive:
            return .white
        }
    }

    @ViewBuilder
    private var glassBackground: some View {
        GlassTheme.glassCapsuleBackground(material: .thinMaterial, reduceTransparency: reduceTransparency)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            Circle()
                .fill(GlassTheme.primary.opacity(0.9))
                .overlay(
                    Circle()
                        .stroke(
                            GlassTheme.glassBorderGradient(
                                reduceTransparency: reduceTransparency,
                                increaseContrast: increaseContrast
                            ),
                            lineWidth: GlassTheme.glassBorderLineWidth(
                                reduceTransparency: reduceTransparency,
                                increaseContrast: increaseContrast
                            )
                        )
                )
        case .destructive:
            Circle()
                .fill(GlassTheme.error.opacity(0.9))
                .overlay(
                    Circle()
                        .stroke(
                            GlassTheme.glassBorderGradient(
                                reduceTransparency: reduceTransparency,
                                increaseContrast: increaseContrast
                            ),
                            lineWidth: GlassTheme.glassBorderLineWidth(
                                reduceTransparency: reduceTransparency,
                                increaseContrast: increaseContrast
                            )
                        )
                )
        case .secondary, .plain:
            glassBackground
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            GlassTheme.glassBorderGradient(
                                reduceTransparency: reduceTransparency,
                                increaseContrast: increaseContrast
                            ),
                            lineWidth: GlassTheme.glassBorderLineWidth(
                                reduceTransparency: reduceTransparency,
                                increaseContrast: increaseContrast
                            )
                        )
                )
        }
    }

    @MainActor
    private var backgroundFill: some ShapeStyle {
        switch style {
        case .primary:
            return AnyShapeStyle(GlassTheme.primary.opacity(0.9))
        case .secondary:
            return AnyShapeStyle(Material.thinMaterial)
        case .plain:
            return AnyShapeStyle(Material.ultraThinMaterial)
        case .destructive:
            return AnyShapeStyle(GlassTheme.error.opacity(0.9))
        }
    }

    private func triggerHaptic() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }

    private var scaledSize: CGFloat {
        size * iconScale
    }

    private var scaledIconSize: CGFloat {
        size * 0.45 * iconScale
    }
}

// MARK: - Pill Button with Icon and Text

/// Pill-shaped button with icon and text, SF Symbol effects
public struct GlassPillButton: View {
    let icon: String
    let text: String
    let style: GlassIconButton.Style
    let symbolAnimation: GlassIconButton.SymbolAnimation
    let action: () -> Void

    @State private var animationTrigger = false
    @State private var isPressed = false
    @ScaledMetric(relativeTo: .subheadline) private var pillIconSize: CGFloat = 16
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityIncreaseContrast) private var increaseContrast

    public init(
        icon: String,
        text: String,
        style: GlassIconButton.Style = .secondary,
        symbolAnimation: GlassIconButton.SymbolAnimation = .bounce,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.text = text
        self.style = style
        self.symbolAnimation = symbolAnimation
        self.action = action
    }

    public var body: some View {
        Button {
            animationTrigger.toggle()
            action()
        } label: {
            HStack(spacing: GlassTheme.spacingSmall) {
                iconView
                    .font(.system(size: pillIconSize, weight: .medium))

                Text(text)
                    .font(GlassTheme.captionFont)
            }
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, GlassTheme.spacingMedium)
            .padding(.vertical, GlassTheme.spacingSmall)
            .background(
                Group {
                    if style == .secondary || style == .plain {
                        pillGlassBackground
                    } else {
                        Capsule().fill(backgroundFill)
                    }
                }
                .overlay(
                    Capsule()
                        .stroke(
                            GlassTheme.glassBorderGradient(
                                reduceTransparency: reduceTransparency,
                                increaseContrast: increaseContrast
                            ),
                            lineWidth: GlassTheme.glassBorderLineWidth(
                                reduceTransparency: reduceTransparency,
                                increaseContrast: increaseContrast
                            )
                        )
                )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 4, y: 2)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: animationTrigger)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            if reduceMotion {
                isPressed = pressing
            } else {
                withAnimation(GlassTheme.buttonSpring) {
                    isPressed = pressing
                }
            }
        }, perform: {})
    }

    /// Icon with SF Symbol animation effects (respects reduce motion)
    @ViewBuilder
    private var iconView: some View {
        // When reduce motion is enabled, skip all symbol effects
        if reduceMotion {
            Image(systemName: icon)
        } else {
            switch symbolAnimation {
            case .bounce:
                Image(systemName: icon)
                    .symbolEffect(.bounce, value: animationTrigger)
            case .wiggle:
                Image(systemName: icon)
                    .symbolEffect(.wiggle, value: animationTrigger)
            case .breathe:
                Image(systemName: icon)
                    .symbolEffect(.breathe, value: animationTrigger)
            case .rotate:
                Image(systemName: icon)
                    .symbolEffect(.rotate, value: animationTrigger)
            case .pulse:
                Image(systemName: icon)
                    .symbolEffect(.pulse, value: animationTrigger)
            case .none:
                Image(systemName: icon)
            }
        }
    }

    @MainActor
    private var foregroundColor: Color {
        switch style {
        case .primary, .destructive:
            return .white
        case .secondary:
            return GlassTheme.primary
        case .plain:
            return GlassTheme.text
        }
    }

    @ViewBuilder
    private var pillGlassBackground: some View {
        GlassTheme.glassCapsuleBackground(material: .thinMaterial, reduceTransparency: reduceTransparency)
    }

    @MainActor
    private var backgroundFill: some ShapeStyle {
        switch style {
        case .primary:
            return AnyShapeStyle(GlassTheme.primary.opacity(0.9))
        case .secondary:
            return AnyShapeStyle(Material.thinMaterial)
        case .plain:
            return AnyShapeStyle(Material.ultraThinMaterial)
        case .destructive:
            return AnyShapeStyle(GlassTheme.error.opacity(0.9))
        }
    }
}

// MARK: - Previews

#Preview("Icon Buttons") {
    ZStack {
        AnimatedMeshBackground(config: .aurora)
            .ignoresSafeArea()

        VStack(spacing: 24) {
            Text("SF Symbol 6 Effects")
                .font(GlassTheme.titleFont)
                .foregroundStyle(.white)

            HStack(spacing: 16) {
                GlassIconButton(
                    icon: "arrow.clockwise",
                    style: .secondary,
                    symbolAnimation: .rotate,
                    accessibilityLabel: "Refresh"
                ) {}

                GlassIconButton(
                    icon: "bell.fill",
                    style: .primary,
                    symbolAnimation: .wiggle,
                    accessibilityLabel: "Notifications"
                ) {}

                GlassIconButton(
                    icon: "heart.fill",
                    style: .plain,
                    symbolAnimation: .bounce,
                    accessibilityLabel: "Like"
                ) {}

                GlassIconButton(
                    icon: "trash",
                    style: .destructive,
                    symbolAnimation: .bounce,
                    accessibilityLabel: "Delete"
                ) {}
            }

            GlassPillButton(
                icon: "arrow.left.arrow.right",
                text: "Swap Units",
                style: .secondary,
                symbolAnimation: .rotate
            ) {}

            GlassPillButton(
                icon: "person.badge.plus",
                text: "Add Person",
                style: .primary,
                symbolAnimation: .wiggle
            ) {}
        }
        .padding()
    }
}
