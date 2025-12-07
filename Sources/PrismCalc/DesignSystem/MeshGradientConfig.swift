import SwiftUI

/// Configuration for iOS 18 MeshGradient backgrounds
/// Each theme defines a 3x3 grid of control points and colors
/// for organic, flowing gradient animations
@available(iOS 18.0, *)
public struct MeshGradientConfig: Sendable {
    /// Grid dimensions (always 3x3 for our themes)
    public let width: Int
    public let height: Int

    /// Base control points for the mesh grid (9 points for 3x3)
    /// Points are in normalized coordinates [0,1]
    public let basePoints: [SIMD2<Float>]

    /// Colors for each control point (must match point count)
    public let colors: [Color]

    /// Animation amplitude for interior points (0 = no animation)
    public let animationAmplitude: Float

    /// Animation speed multiplier (1.0 = normal)
    public let animationSpeed: Float

    /// Initialize a mesh gradient configuration
    public init(
        width: Int = 3,
        height: Int = 3,
        basePoints: [SIMD2<Float>],
        colors: [Color],
        animationAmplitude: Float = 0.08,
        animationSpeed: Float = 1.0
    ) {
        self.width = width
        self.height = height
        self.basePoints = basePoints
        self.colors = colors
        self.animationAmplitude = animationAmplitude
        self.animationSpeed = animationSpeed
    }

    /// Calculate animated points for a given time
    /// Edge points stay fixed, interior points oscillate
    public func animatedPoints(for time: TimeInterval) -> [SIMD2<Float>] {
        var points = basePoints
        let t = Float(time) * animationSpeed

        // Only animate interior points (indices 1, 3, 4, 5, 7 in a 3x3 grid)
        // Corners (0, 2, 6, 8) and edge midpoints need to stay fixed for stability

        // Top-middle (index 1)
        points[1].x += sin(t * 0.7) * animationAmplitude * 0.5
        points[1].y += cos(t * 0.5) * animationAmplitude * 0.3

        // Left-middle (index 3)
        points[3].x += cos(t * 0.6) * animationAmplitude * 0.3
        points[3].y += sin(t * 0.8) * animationAmplitude * 0.5

        // Center (index 4) - animates the most
        points[4].x += sin(t * 0.4) * animationAmplitude
        points[4].y += cos(t * 0.6) * animationAmplitude

        // Right-middle (index 5)
        points[5].x += cos(t * 0.5) * animationAmplitude * 0.3
        points[5].y += sin(t * 0.7) * animationAmplitude * 0.5

        // Bottom-middle (index 7)
        points[7].x += sin(t * 0.6) * animationAmplitude * 0.5
        points[7].y += cos(t * 0.4) * animationAmplitude * 0.3

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

    /// Aurora theme - flowing blue/purple/cyan
    public static let aurora = MeshGradientConfig(
        basePoints: standardBasePoints,
        colors: [
            // Top row: cool blues
            Color(red: 0.3, green: 0.4, blue: 0.9),
            Color(red: 0.5, green: 0.3, blue: 0.8),
            Color(red: 0.2, green: 0.6, blue: 0.8),
            // Middle row: purples
            Color(red: 0.6, green: 0.3, blue: 0.7),
            Color(red: 0.48, green: 0.41, blue: 0.93), // #7B68EE
            Color(red: 0.3, green: 0.5, blue: 0.7),
            // Bottom row: faded
            Color(red: 0.2, green: 0.3, blue: 0.6),
            Color(red: 0.4, green: 0.25, blue: 0.6),
            Color(red: 0.15, green: 0.45, blue: 0.6)
        ],
        animationAmplitude: 0.08,
        animationSpeed: 0.8
    )

    /// Calming Blues theme - serene blue tones
    public static let calmingBlues = MeshGradientConfig(
        basePoints: standardBasePoints,
        colors: [
            // Top row
            Color(red: 0.51, green: 0.74, blue: 0.83), // #83BCD4
            Color(red: 0.55, green: 0.78, blue: 0.88),
            Color(red: 0.64, green: 0.82, blue: 0.88), // #A4D1E0
            // Middle row
            Color(red: 0.58, green: 0.80, blue: 0.90),
            Color(red: 0.69, green: 0.87, blue: 0.88), // #B1DEE0
            Color(red: 0.55, green: 0.75, blue: 0.85),
            // Bottom row
            Color(red: 0.45, green: 0.68, blue: 0.78),
            Color(red: 0.50, green: 0.72, blue: 0.82),
            Color(red: 0.48, green: 0.70, blue: 0.80)
        ],
        animationAmplitude: 0.06,
        animationSpeed: 0.6
    )

    /// Forest Earth theme - natural greens and earth tones
    public static let forestEarth = MeshGradientConfig(
        basePoints: standardBasePoints,
        colors: [
            // Top row
            Color(red: 0.31, green: 0.47, blue: 0.37), // #4E785E
            Color(red: 0.25, green: 0.40, blue: 0.32),
            Color(red: 0.16, green: 0.29, blue: 0.27), // #2A4B44
            // Middle row
            Color(red: 0.28, green: 0.42, blue: 0.34),
            Color(red: 0.30, green: 0.36, blue: 0.40), // #4C5C65
            Color(red: 0.22, green: 0.35, blue: 0.30),
            // Bottom row
            Color(red: 0.20, green: 0.33, blue: 0.28),
            Color(red: 0.24, green: 0.38, blue: 0.32),
            Color(red: 0.18, green: 0.30, blue: 0.26)
        ],
        animationAmplitude: 0.05,
        animationSpeed: 0.5
    )

    /// Soft Tranquil theme - light pastels
    public static let softTranquil = MeshGradientConfig(
        basePoints: standardBasePoints,
        colors: [
            // Top row - light blues
            Color(red: 0.77, green: 0.89, blue: 0.96), // #C5E3F6
            Color(red: 0.80, green: 0.92, blue: 0.97),
            Color(red: 0.83, green: 0.95, blue: 0.96), // #D4F1F4
            // Middle row
            Color(red: 0.85, green: 0.93, blue: 0.95),
            Color(red: 0.91, green: 0.97, blue: 0.96), // #E8F8F5
            Color(red: 0.82, green: 0.90, blue: 0.94),
            // Bottom row
            Color(red: 0.78, green: 0.88, blue: 0.93),
            Color(red: 0.81, green: 0.91, blue: 0.95),
            Color(red: 0.79, green: 0.89, blue: 0.94)
        ],
        animationAmplitude: 0.04,
        animationSpeed: 0.7
    )

    /// Blue-Green Harmony theme - turquoise gradation
    public static let blueGreenHarmony = MeshGradientConfig(
        basePoints: standardBasePoints,
        colors: [
            // Top row
            Color(red: 0.0, green: 0.81, blue: 0.78), // #00CEC8
            Color(red: 0.1, green: 0.75, blue: 0.70),
            Color(red: 0.18, green: 0.55, blue: 0.34), // #2E8B57
            // Middle row
            Color(red: 0.05, green: 0.70, blue: 0.65),
            Color(red: 0.13, green: 0.70, blue: 0.67), // #20B2AA
            Color(red: 0.15, green: 0.60, blue: 0.45),
            // Bottom row
            Color(red: 0.0, green: 0.65, blue: 0.60),
            Color(red: 0.10, green: 0.58, blue: 0.52),
            Color(red: 0.12, green: 0.50, blue: 0.40)
        ],
        animationAmplitude: 0.07,
        animationSpeed: 0.9
    )

    /// Midnight theme - deep indigos
    public static let midnight = MeshGradientConfig(
        basePoints: standardBasePoints,
        colors: [
            // Top row - darkest
            Color(red: 0.12, green: 0.11, blue: 0.29), // #1E1B4B
            Color(red: 0.15, green: 0.13, blue: 0.35),
            Color(red: 0.19, green: 0.18, blue: 0.51), // #312E81
            // Middle row
            Color(red: 0.17, green: 0.15, blue: 0.40),
            Color(red: 0.22, green: 0.19, blue: 0.64), // #3730A3
            Color(red: 0.20, green: 0.17, blue: 0.45),
            // Bottom row - slightly lighter
            Color(red: 0.14, green: 0.12, blue: 0.32),
            Color(red: 0.18, green: 0.16, blue: 0.38),
            Color(red: 0.16, green: 0.14, blue: 0.35)
        ],
        animationAmplitude: 0.06,
        animationSpeed: 0.4
    )
}
