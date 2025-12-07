import SwiftUI

/// Animated mesh gradient background view for iOS 18+
/// Uses TimelineView for smooth, performant animations
@available(iOS 18.0, *)
public struct AnimatedMeshBackground: View {
    /// The mesh gradient configuration to display
    let config: MeshGradientConfig

    /// Whether to animate the mesh (respects reduce motion preference)
    let animated: Bool

    /// Start time for animation calculations
    @State private var startTime: Date = .now

    /// Environment for accessibility preferences
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(config: MeshGradientConfig, animated: Bool = true) {
        self.config = config
        self.animated = animated
    }

    public var body: some View {
        if animated && !reduceMotion {
            animatedMesh
        } else {
            staticMesh
        }
    }

    /// Animated mesh using TimelineView
    private var animatedMesh: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startTime)
            let points = config.animatedPoints(for: elapsed)

            MeshGradient(
                width: config.width,
                height: config.height,
                points: points,
                colors: config.colors,
                smoothsColors: true
            )
        }
        .onAppear {
            startTime = .now
        }
    }

    /// Static mesh for reduced motion or non-animated contexts
    private var staticMesh: some View {
        MeshGradient(
            width: config.width,
            height: config.height,
            points: config.basePoints,
            colors: config.colors,
            smoothsColors: true
        )
    }
}

// MARK: - Theme-Aware Convenience View

/// A mesh background that automatically uses the current theme
@available(iOS 18.0, *)
public struct ThemedMeshBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    public init() {}

    @MainActor
    public var body: some View {
        AnimatedMeshBackground(config: currentMeshConfig)
            .overlay(glassOverlay)
    }

    /// Get the mesh config for the current theme
    @MainActor
    private var currentMeshConfig: MeshGradientConfig {
        switch GlassTheme.currentTheme {
        case .aurora:
            return .aurora
        case .calmingBlues:
            return .calmingBlues
        case .forestEarth:
            return .forestEarth
        case .softTranquil:
            return .softTranquil
        case .blueGreenHarmony:
            return .blueGreenHarmony
        case .midnight:
            return .midnight
        }
    }

    /// Subtle overlay for glass effect enhancement
    private var glassOverlay: some View {
        Color.white.opacity(0.02)
            .blendMode(.overlay)
    }
}

// MARK: - Preview Provider

@available(iOS 18.0, *)
#Preview("Aurora Theme") {
    AnimatedMeshBackground(config: .aurora)
        .ignoresSafeArea()
}

@available(iOS 18.0, *)
#Preview("Midnight Theme") {
    AnimatedMeshBackground(config: .midnight)
        .ignoresSafeArea()
}

@available(iOS 18.0, *)
#Preview("Calming Blues") {
    AnimatedMeshBackground(config: .calmingBlues)
        .ignoresSafeArea()
}

@available(iOS 18.0, *)
#Preview("Forest Earth") {
    AnimatedMeshBackground(config: .forestEarth)
        .ignoresSafeArea()
}
