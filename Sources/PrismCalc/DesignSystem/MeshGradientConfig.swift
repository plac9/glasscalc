import SwiftUI

/// Configuration for iOS 18 MeshGradient backgrounds
/// Each theme defines a 3x3 grid of control points and colors
/// with adaptive light/dark mode support
@available(iOS 18.0, *)
public struct MeshGradientConfig: Sendable {
    /// Grid dimensions (always 3x3 for our themes)
    public let width: Int
    public let height: Int

    /// Base control points for the mesh grid (9 points for 3x3)
    /// Points are in normalized coordinates [0,1]
    public let basePoints: [SIMD2<Float>]

    /// Colors for each control point - light mode (must match point count)
    public let lightColors: [Color]

    /// Colors for each control point - dark mode (must match point count)
    public let darkColors: [Color]

    /// Animation amplitude for interior points (0 = no animation)
    public let animationAmplitude: Float

    /// Animation speed multiplier (1.0 = normal)
    public let animationSpeed: Float

    /// Initialize a mesh gradient configuration with adaptive colors
    public init(
        width: Int = 3,
        height: Int = 3,
        basePoints: [SIMD2<Float>],
        lightColors: [Color],
        darkColors: [Color],
        animationAmplitude: Float = 0.08,
        animationSpeed: Float = 1.0
    ) {
        self.width = width
        self.height = height
        self.basePoints = basePoints
        self.lightColors = lightColors
        self.darkColors = darkColors
        self.animationAmplitude = animationAmplitude
        self.animationSpeed = animationSpeed
    }

    /// Get adaptive colors that respond to light/dark mode
    public var colors: [Color] {
        zip(lightColors, darkColors).map { light, dark in
            Color(light: light, dark: dark)
        }
    }

    /// Calculate animated points for a given time
    /// Edge points stay fixed, interior points oscillate
    public func animatedPoints(for time: TimeInterval) -> [SIMD2<Float>] {
        var points = basePoints
        let animTime = Float(time) * animationSpeed

        // Only animate interior points (indices 1, 3, 4, 5, 7 in a 3x3 grid)
        // Corners (0, 2, 6, 8) and edge midpoints need to stay fixed for stability

        // Top-middle (index 1)
        points[1].x += sin(animTime * 0.7) * animationAmplitude * 0.5
        points[1].y += cos(animTime * 0.5) * animationAmplitude * 0.3

        // Left-middle (index 3)
        points[3].x += cos(animTime * 0.6) * animationAmplitude * 0.3
        points[3].y += sin(animTime * 0.8) * animationAmplitude * 0.5

        // Center (index 4) - animates the most
        points[4].x += sin(animTime * 0.4) * animationAmplitude
        points[4].y += cos(animTime * 0.6) * animationAmplitude

        // Right-middle (index 5)
        points[5].x += cos(animTime * 0.5) * animationAmplitude * 0.3
        points[5].y += sin(animTime * 0.7) * animationAmplitude * 0.5

        // Bottom-middle (index 7)
        points[7].x += sin(animTime * 0.6) * animationAmplitude * 0.5
        points[7].y += cos(animTime * 0.4) * animationAmplitude * 0.3

        return points
    }
}

// MARK: - Theme-Specific Configurations

@available(iOS 18.0, *)
extension MeshGradientConfig {

    /// Standard 3x3 grid base points
    private static let standardBasePoints: [SIMD2<Float>] = [
        // Row 0 (top)
        SIMD2<Float>(0.0, 0.0), SIMD2<Float>(0.5, 0.0), SIMD2<Float>(1.0, 0.0),
        // Row 1 (middle)
        SIMD2<Float>(0.0, 0.5), SIMD2<Float>(0.5, 0.5), SIMD2<Float>(1.0, 0.5),
        // Row 2 (bottom)
        SIMD2<Float>(0.0, 1.0), SIMD2<Float>(0.5, 1.0), SIMD2<Float>(1.0, 1.0)
    ]

    // MARK: - Aurora (Default - Strongest Theme)
    // Rich, vibrant blues and purples with depth

    public static let aurora = MeshGradientConfig(
        basePoints: standardBasePoints,
        lightColors: [
            // Top row: saturated blues
            Color(red: 0.25, green: 0.35, blue: 0.75),
            Color(red: 0.40, green: 0.30, blue: 0.70),
            Color(red: 0.20, green: 0.50, blue: 0.70),
            // Middle row: rich purples
            Color(red: 0.50, green: 0.28, blue: 0.65),
            Color(red: 0.45, green: 0.35, blue: 0.80),
            Color(red: 0.30, green: 0.45, blue: 0.65),
            // Bottom row: deep tones
            Color(red: 0.20, green: 0.25, blue: 0.55),
            Color(red: 0.35, green: 0.22, blue: 0.55),
            Color(red: 0.18, green: 0.38, blue: 0.55)
        ],
        darkColors: [
            // Top row: vibrant blues
            Color(red: 0.15, green: 0.30, blue: 0.85),
            Color(red: 0.45, green: 0.25, blue: 0.80),
            Color(red: 0.10, green: 0.55, blue: 0.75),
            // Middle row: electric purples
            Color(red: 0.55, green: 0.20, blue: 0.70),
            Color(red: 0.48, green: 0.41, blue: 0.93),
            Color(red: 0.20, green: 0.50, blue: 0.70),
            // Bottom row: deep anchors
            Color(red: 0.10, green: 0.15, blue: 0.45),
            Color(red: 0.30, green: 0.15, blue: 0.50),
            Color(red: 0.08, green: 0.35, blue: 0.50)
        ],
        animationAmplitude: 0.08,
        animationSpeed: 0.8
    )

    // MARK: - Calming Blues
    // Deep ocean teals - more saturated than before

    public static let calmingBlues = MeshGradientConfig(
        basePoints: standardBasePoints,
        lightColors: [
            // Top row: ocean blues
            Color(red: 0.20, green: 0.50, blue: 0.65),
            Color(red: 0.25, green: 0.55, blue: 0.70),
            Color(red: 0.30, green: 0.60, blue: 0.72),
            // Middle row: teal depths
            Color(red: 0.22, green: 0.52, blue: 0.68),
            Color(red: 0.28, green: 0.58, blue: 0.72),
            Color(red: 0.25, green: 0.55, blue: 0.68),
            // Bottom row: deeper anchors
            Color(red: 0.18, green: 0.45, blue: 0.60),
            Color(red: 0.22, green: 0.50, blue: 0.65),
            Color(red: 0.20, green: 0.48, blue: 0.62)
        ],
        darkColors: [
            // Top row: rich teals
            Color(red: 0.08, green: 0.40, blue: 0.55),
            Color(red: 0.12, green: 0.48, blue: 0.62),
            Color(red: 0.15, green: 0.52, blue: 0.65),
            // Middle row: deep ocean
            Color(red: 0.10, green: 0.45, blue: 0.58),
            Color(red: 0.15, green: 0.55, blue: 0.68),
            Color(red: 0.12, green: 0.50, blue: 0.60),
            // Bottom row: abyss
            Color(red: 0.05, green: 0.30, blue: 0.45),
            Color(red: 0.08, green: 0.38, blue: 0.52),
            Color(red: 0.06, green: 0.35, blue: 0.48)
        ],
        animationAmplitude: 0.06,
        animationSpeed: 0.6
    )

    // MARK: - Forest Earth
    // Rich emerald greens with earthy depth

    public static let forestEarth = MeshGradientConfig(
        basePoints: standardBasePoints,
        lightColors: [
            // Top row: forest canopy
            Color(red: 0.18, green: 0.45, blue: 0.30),
            Color(red: 0.22, green: 0.50, blue: 0.35),
            Color(red: 0.15, green: 0.40, blue: 0.28),
            // Middle row: deep forest
            Color(red: 0.20, green: 0.48, blue: 0.32),
            Color(red: 0.25, green: 0.52, blue: 0.38),
            Color(red: 0.18, green: 0.45, blue: 0.30),
            // Bottom row: earth tones
            Color(red: 0.15, green: 0.38, blue: 0.25),
            Color(red: 0.20, green: 0.42, blue: 0.28),
            Color(red: 0.12, green: 0.35, blue: 0.22)
        ],
        darkColors: [
            // Top row: emerald depths
            Color(red: 0.08, green: 0.35, blue: 0.22),
            Color(red: 0.12, green: 0.42, blue: 0.28),
            Color(red: 0.06, green: 0.32, blue: 0.20),
            // Middle row: forest floor
            Color(red: 0.10, green: 0.38, blue: 0.25),
            Color(red: 0.15, green: 0.45, blue: 0.30),
            Color(red: 0.08, green: 0.36, blue: 0.22),
            // Bottom row: deep earth
            Color(red: 0.05, green: 0.25, blue: 0.15),
            Color(red: 0.08, green: 0.30, blue: 0.18),
            Color(red: 0.04, green: 0.22, blue: 0.12)
        ],
        animationAmplitude: 0.05,
        animationSpeed: 0.5
    )

    // MARK: - Soft Tranquil
    // Warm amber and coral - sophisticated warmth instead of pale pastels

    public static let softTranquil = MeshGradientConfig(
        basePoints: standardBasePoints,
        lightColors: [
            // Top row: warm amber
            Color(red: 0.85, green: 0.60, blue: 0.45),
            Color(red: 0.80, green: 0.55, blue: 0.50),
            Color(red: 0.75, green: 0.50, blue: 0.55),
            // Middle row: coral blend
            Color(red: 0.82, green: 0.58, blue: 0.48),
            Color(red: 0.78, green: 0.52, blue: 0.52),
            Color(red: 0.72, green: 0.48, blue: 0.50),
            // Bottom row: dusty rose
            Color(red: 0.70, green: 0.50, blue: 0.48),
            Color(red: 0.75, green: 0.52, blue: 0.50),
            Color(red: 0.68, green: 0.48, blue: 0.48)
        ],
        darkColors: [
            // Top row: deep amber
            Color(red: 0.60, green: 0.35, blue: 0.25),
            Color(red: 0.55, green: 0.30, blue: 0.30),
            Color(red: 0.50, green: 0.28, blue: 0.35),
            // Middle row: rich coral
            Color(red: 0.58, green: 0.32, blue: 0.28),
            Color(red: 0.52, green: 0.28, blue: 0.32),
            Color(red: 0.48, green: 0.25, blue: 0.30),
            // Bottom row: deep rose
            Color(red: 0.42, green: 0.22, blue: 0.25),
            Color(red: 0.48, green: 0.25, blue: 0.28),
            Color(red: 0.40, green: 0.20, blue: 0.25)
        ],
        animationAmplitude: 0.04,
        animationSpeed: 0.7
    )

    // MARK: - Blue-Green Harmony
    // Vibrant teal and cyan - jewel tones

    public static let blueGreenHarmony = MeshGradientConfig(
        basePoints: standardBasePoints,
        lightColors: [
            // Top row: vivid cyan
            Color(red: 0.0, green: 0.60, blue: 0.65),
            Color(red: 0.05, green: 0.55, blue: 0.60),
            Color(red: 0.10, green: 0.50, blue: 0.55),
            // Middle row: teal blend
            Color(red: 0.02, green: 0.58, blue: 0.62),
            Color(red: 0.08, green: 0.52, blue: 0.58),
            Color(red: 0.12, green: 0.48, blue: 0.52),
            // Bottom row: deep aqua
            Color(red: 0.0, green: 0.50, blue: 0.55),
            Color(red: 0.05, green: 0.45, blue: 0.50),
            Color(red: 0.08, green: 0.42, blue: 0.48)
        ],
        darkColors: [
            // Top row: electric teal
            Color(red: 0.0, green: 0.55, blue: 0.60),
            Color(red: 0.0, green: 0.48, blue: 0.55),
            Color(red: 0.05, green: 0.42, blue: 0.50),
            // Middle row: deep cyan
            Color(red: 0.0, green: 0.50, blue: 0.55),
            Color(red: 0.0, green: 0.45, blue: 0.52),
            Color(red: 0.05, green: 0.40, blue: 0.48),
            // Bottom row: ocean depths
            Color(red: 0.0, green: 0.35, blue: 0.42),
            Color(red: 0.0, green: 0.32, blue: 0.40),
            Color(red: 0.02, green: 0.28, blue: 0.38)
        ],
        animationAmplitude: 0.07,
        animationSpeed: 0.9
    )

    // MARK: - Midnight
    // Deep indigo and violet - optimized for dark elegance

    public static let midnight = MeshGradientConfig(
        basePoints: standardBasePoints,
        lightColors: [
            // Top row: muted indigo (works in light mode)
            Color(red: 0.35, green: 0.32, blue: 0.55),
            Color(red: 0.40, green: 0.35, blue: 0.60),
            Color(red: 0.45, green: 0.38, blue: 0.65),
            // Middle row
            Color(red: 0.38, green: 0.34, blue: 0.58),
            Color(red: 0.42, green: 0.38, blue: 0.68),
            Color(red: 0.40, green: 0.36, blue: 0.62),
            // Bottom row
            Color(red: 0.32, green: 0.30, blue: 0.52),
            Color(red: 0.36, green: 0.32, blue: 0.55),
            Color(red: 0.34, green: 0.31, blue: 0.53)
        ],
        darkColors: [
            // Top row: deep space
            Color(red: 0.08, green: 0.06, blue: 0.22),
            Color(red: 0.12, green: 0.10, blue: 0.30),
            Color(red: 0.16, green: 0.14, blue: 0.38),
            // Middle row: nebula
            Color(red: 0.10, green: 0.08, blue: 0.28),
            Color(red: 0.18, green: 0.15, blue: 0.45),
            Color(red: 0.14, green: 0.12, blue: 0.35),
            // Bottom row: void
            Color(red: 0.06, green: 0.05, blue: 0.18),
            Color(red: 0.10, green: 0.08, blue: 0.25),
            Color(red: 0.08, green: 0.06, blue: 0.20)
        ],
        animationAmplitude: 0.06,
        animationSpeed: 0.4
    )
}
