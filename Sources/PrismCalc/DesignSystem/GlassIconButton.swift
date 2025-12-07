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
        Button(action: {
            animationTrigger.toggle()
            triggerHaptic()
            action()
        }) {
            iconView
                .font(.system(size: size * 0.45, weight: .medium))
                .foregroundStyle(foregroundColor)
                .frame(width: size, height: size)
                .background(backgroundView)
                .shadow(color: Color.black.opacity(0.1), radius: 6, y: 3)
                .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.isButton)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: animationTrigger)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(GlassTheme.buttonSpring) {
                isPressed = pressing
            }
        }, perform: {})
    }

    /// Icon with SF Symbol animation effects
    @ViewBuilder
    private var iconView: some View {
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
    private var backgroundView: some View {
        Circle()
            .fill(backgroundFill)
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
        Button(action: {
            animationTrigger.toggle()
            action()
        }) {
            HStack(spacing: GlassTheme.spacingSmall) {
                iconView
                    .font(.system(size: 16, weight: .medium))

                Text(text)
                    .font(GlassTheme.captionFont)
            }
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, GlassTheme.spacingMedium)
            .padding(.vertical, GlassTheme.spacingSmall)
            .background(
                Capsule()
                    .fill(backgroundFill)
                    .overlay(
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 4, y: 2)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: animationTrigger)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            withAnimation(GlassTheme.buttonSpring) {
                isPressed = pressing
            }
        }, perform: {})
    }

    @ViewBuilder
    private var iconView: some View {
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
