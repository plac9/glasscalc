import SwiftUI
import Foundation

/// Animated mesh gradient background view for iOS 18+
/// Uses TimelineView for smooth, performant animations
@available(iOS 18.0, *)
public struct AnimatedMeshBackground: View {
    /// The mesh gradient configuration to display
    let config: MeshGradientConfig

    /// Whether to animate the mesh (respects reduce motion preference)
    let animated: Bool

    /// Optional override for animation frame interval
    let frameInterval: Double?

    /// Start time for animation calculations
    @State private var startTime: Date = .now

    /// Environment for accessibility preferences
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Environment for color scheme to enable adaptive colors
    @Environment(\.colorScheme) private var colorScheme

    public init(config: MeshGradientConfig, animated: Bool = true, frameInterval: Double? = nil) {
        self.config = config
        self.animated = animated
        self.frameInterval = frameInterval
    }

    /// Get colors based on current color scheme
    private var currentColors: [Color] {
        colorScheme == .dark ? config.darkColors : config.lightColors
    }

    private var defaultFrameInterval: Double {
        #if os(iOS)
        return ProcessInfo.processInfo.isLowPowerModeEnabled ? (1.0 / 20.0) : (1.0 / 30.0)
        #else
        return 1.0 / 30.0
        #endif
    }

    private var effectiveFrameInterval: Double {
        frameInterval ?? defaultFrameInterval
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
        TimelineView(.animation(minimumInterval: effectiveFrameInterval)) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startTime)
            let points = config.animatedPoints(for: elapsed)

            MeshGradient(
                width: config.width,
                height: config.height,
                points: points,
                colors: currentColors,
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
            colors: currentColors,
            smoothsColors: true
        )
    }
}

// MARK: - Theme-Aware Convenience View

/// A mesh background that automatically uses the current theme
@available(iOS 18.0, *)
public struct ThemedMeshBackground: View {
    let animated: Bool
    let frameInterval: Double?
    @Environment(\.colorScheme) private var colorScheme

    public init(animated: Bool = true, frameInterval: Double? = nil) {
        self.animated = animated
        self.frameInterval = frameInterval
    }

    @MainActor
    public var body: some View {
        AnimatedMeshBackground(
            config: currentMeshConfig,
            animated: animated,
            frameInterval: frameInterval
        )
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
