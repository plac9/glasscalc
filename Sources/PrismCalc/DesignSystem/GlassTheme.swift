import SwiftUI

/// PrismCalc Design System - Full glassmorphism theme
///
/// Provides consistent styling across the app with:
/// - 6 color themes with dynamic gradients
/// - Material effects (.ultraThinMaterial, .regularMaterial, .thinMaterial)
/// - Typography and spacing constants
/// - Animation timings
/// - Accessibility support
public struct GlassTheme: Sendable {

    // MARK: - Theme Selection

    /// Available themes
    public enum Theme: String, CaseIterable, Identifiable, Sendable {
        case aurora = "Aurora"
        case calmingBlues = "Calming Blues"
        case forestEarth = "Forest Earth"
        case softTranquil = "Soft Tranquil"
        case blueGreenHarmony = "Blue-Green"
        case midnight = "Midnight"

        public var id: String { rawValue }

        public var isPro: Bool {
            self != .aurora
        }
    }

    /// Current active theme (will be user-configurable)
    @MainActor public static var currentTheme: Theme = .aurora

    // MARK: - Aurora Theme (Default - Strongest)

    public static let auroraPrimary = Color(
        light: Color(hex: "5B48CE"),  // Deeper purple for light mode
        dark: Color(hex: "7B68EE")    // Medium slate blue
    )
    public static let auroraSecondary = Color(
        light: Color(hex: "0098A0"),  // Deeper teal for light mode
        dark: Color(hex: "00CED1")    // Dark turquoise
    )

    public static var auroraGradient: [Color] {
        [
            Color(light: Color(red: 0.25, green: 0.35, blue: 0.75), dark: Color(red: 0.15, green: 0.30, blue: 0.85)),
            Color(light: Color(red: 0.45, green: 0.35, blue: 0.80), dark: Color(red: 0.48, green: 0.41, blue: 0.93)),
            Color(light: Color(red: 0.20, green: 0.25, blue: 0.55), dark: Color(red: 0.10, green: 0.15, blue: 0.45))
        ]
    }

    // MARK: - Calming Blues Theme

    public static let calmingBluesPrimary = Color(
        light: Color(hex: "3080A0"),  // Deeper ocean blue
        dark: Color(hex: "4DA8C8")
    )
    public static let calmingBluesSecondary = Color(
        light: Color(hex: "2870A0"),
        dark: Color(hex: "3898B8")
    )

    public static var calmingBluesGradient: [Color] {
        [
            Color(light: Color(red: 0.20, green: 0.50, blue: 0.65), dark: Color(red: 0.08, green: 0.40, blue: 0.55)),
            Color(light: Color(red: 0.28, green: 0.58, blue: 0.72), dark: Color(red: 0.15, green: 0.55, blue: 0.68)),
            Color(light: Color(red: 0.18, green: 0.45, blue: 0.60), dark: Color(red: 0.05, green: 0.30, blue: 0.45))
        ]
    }

    // MARK: - Forest Earth Theme

    public static let forestEarthPrimary = Color(
        light: Color(hex: "2E6040"),  // Deeper forest green
        dark: Color(hex: "4E785E")
    )
    public static let forestEarthSecondary = Color(
        light: Color(hex: "1A3B2C"),
        dark: Color(hex: "2A4B44")
    )

    public static var forestEarthGradient: [Color] {
        [
            Color(light: Color(red: 0.18, green: 0.45, blue: 0.30), dark: Color(red: 0.08, green: 0.35, blue: 0.22)),
            Color(light: Color(red: 0.25, green: 0.52, blue: 0.38), dark: Color(red: 0.15, green: 0.45, blue: 0.30)),
            Color(light: Color(red: 0.15, green: 0.38, blue: 0.25), dark: Color(red: 0.05, green: 0.25, blue: 0.15))
        ]
    }

    // MARK: - Soft Tranquil Theme (now Warm Amber/Coral)

    public static let softTranquilPrimary = Color(
        light: Color(hex: "D07050"),  // Warm coral
        dark: Color(hex: "C88060")
    )
    public static let softTranquilSecondary = Color(
        light: Color(hex: "B86048"),
        dark: Color(hex: "A87058")
    )

    public static var softTranquilGradient: [Color] {
        [
            Color(light: Color(red: 0.85, green: 0.60, blue: 0.45), dark: Color(red: 0.60, green: 0.35, blue: 0.25)),
            Color(light: Color(red: 0.78, green: 0.52, blue: 0.52), dark: Color(red: 0.52, green: 0.28, blue: 0.32)),
            Color(light: Color(red: 0.70, green: 0.50, blue: 0.48), dark: Color(red: 0.42, green: 0.22, blue: 0.25))
        ]
    }

    // MARK: - Blue-Green Harmony Theme

    public static let blueGreenPrimary = Color(
        light: Color(hex: "008888"),  // Deeper teal
        dark: Color(hex: "00B0A8")
    )
    public static let blueGreenSecondary = Color(
        light: Color(hex: "007070"),
        dark: Color(hex: "009890")
    )

    public static var blueGreenGradient: [Color] {
        [
            Color(light: Color(red: 0.0, green: 0.60, blue: 0.65), dark: Color(red: 0.0, green: 0.55, blue: 0.60)),
            Color(light: Color(red: 0.08, green: 0.52, blue: 0.58), dark: Color(red: 0.0, green: 0.45, blue: 0.52)),
            Color(light: Color(red: 0.0, green: 0.50, blue: 0.55), dark: Color(red: 0.0, green: 0.35, blue: 0.42))
        ]
    }

    // MARK: - Midnight Theme

    public static let midnightPrimary = Color(
        light: Color(hex: "5558D0"),  // Lighter indigo for light mode
        dark: Color(hex: "6366F1")    // Indigo
    )
    public static let midnightSecondary = Color(
        light: Color(hex: "7B5CE0"),
        dark: Color(hex: "8B5CF6")    // Violet
    )

    public static var midnightGradient: [Color] {
        [
            Color(light: Color(red: 0.35, green: 0.32, blue: 0.55), dark: Color(red: 0.08, green: 0.06, blue: 0.22)),
            Color(light: Color(red: 0.42, green: 0.38, blue: 0.68), dark: Color(red: 0.18, green: 0.15, blue: 0.45)),
            Color(light: Color(red: 0.32, green: 0.30, blue: 0.52), dark: Color(red: 0.06, green: 0.05, blue: 0.18))
        ]
    }

    // MARK: - Semantic Colors (Theme-Aware)

    @MainActor
    public static var primary: Color {
        switch currentTheme {
        case .aurora: return auroraPrimary
        case .calmingBlues: return calmingBluesPrimary
        case .forestEarth: return forestEarthPrimary
        case .softTranquil: return softTranquilPrimary
        case .blueGreenHarmony: return blueGreenPrimary
        case .midnight: return midnightPrimary
        }
    }

    @MainActor
    public static var secondary: Color {
        switch currentTheme {
        case .aurora: return auroraSecondary
        case .calmingBlues: return calmingBluesSecondary
        case .forestEarth: return forestEarthSecondary
        case .softTranquil: return softTranquilSecondary
        case .blueGreenHarmony: return blueGreenSecondary
        case .midnight: return midnightSecondary
        }
    }

    @MainActor
    public static var backgroundGradient: [Color] {
        switch currentTheme {
        case .aurora: return auroraGradient
        case .calmingBlues: return calmingBluesGradient
        case .forestEarth: return forestEarthGradient
        case .softTranquil: return softTranquilGradient
        case .blueGreenHarmony: return blueGreenGradient
        case .midnight: return midnightGradient
        }
    }

    // MARK: - Text Colors

    public static var text: Color {
        if AccessibilityTheme.isHighContrast {
            return Color(light: Color.black, dark: Color.white)
        } else {
            return Color(light: Color(hex: "1A1A1A"), dark: Color(hex: "F8F9FA"))
        }
    }

    public static var textSecondary: Color {
        AccessibilityTheme.isHighContrast ? text.opacity(0.85) : text.opacity(0.7)
    }

    public static var textTertiary: Color {
        AccessibilityTheme.isHighContrast ? text.opacity(0.7) : text.opacity(0.5)
    }

    // MARK: - Glass Effect Styling

    public static var glassBorderGradient: LinearGradient {
        let startOpacity = AccessibilityTheme.isHighContrast ? 0.55 : 0.3
        let endOpacity = AccessibilityTheme.isHighContrast ? 0.25 : 0.1
        return LinearGradient(
            colors: [
                Color.white.opacity(startOpacity),
                Color.white.opacity(endOpacity)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    public static var glassBorderLineWidth: CGFloat {
        AccessibilityTheme.isHighContrast ? 1.5 : 1
    }

    public static var glassShadowOpacityPrimary: Double {
        AccessibilityTheme.isHighContrast ? 0.18 : 0.1
    }

    public static var glassShadowOpacitySecondary: Double {
        AccessibilityTheme.isHighContrast ? 0.1 : 0.05
    }

    // MARK: - Functional Colors

    public static let success = Color(hex: "10B981")
    public static let warning = Color(hex: "F59E0B")
    public static let error = Color(hex: "EF4444")

    // MARK: - Typography

    public static let displayFont = Font.system(.largeTitle, design: .rounded, weight: .bold)
    public static let titleFont = Font.system(.title, design: .rounded, weight: .semibold)
    public static let headlineFont = Font.system(.title3, design: .rounded, weight: .medium)
    public static let bodyFont = Font.system(.body, design: .rounded)
    public static let captionFont = Font.system(.callout, design: .rounded)
    public static let monoFont = Font.system(.title2, design: .monospaced, weight: .medium)

    // MARK: - Spacing

    public static let spacingXS: CGFloat = 4
    public static let spacingSmall: CGFloat = 8
    public static let spacingMedium: CGFloat = 16
    public static let spacingLarge: CGFloat = 24
    public static let spacingXL: CGFloat = 32

    // MARK: - Corner Radius

    public static let cornerRadiusSmall: CGFloat = 12
    public static let cornerRadiusMedium: CGFloat = 16
    public static let cornerRadiusLarge: CGFloat = 24
    public static let cornerRadiusXL: CGFloat = 32

    // MARK: - Button Sizes

    public static let buttonSize: CGFloat = 72
    public static let buttonSizeCompact: CGFloat = 60
    public static let buttonSizeLarge: CGFloat = 84

    // MARK: - Animation

    public static let animationQuick: Double = 0.15
    public static let animationStandard: Double = 0.25
    public static let animationSlow: Double = 0.4

    public static var springAnimation: Animation {
        .spring(response: 0.3, dampingFraction: 0.7)
    }

    public static var buttonSpring: Animation {
        .spring(response: 0.2, dampingFraction: 0.6)
    }

    /// Conditional spring animation that respects reduce motion preference
    public static func conditionalSpring(_ reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : springAnimation
    }

    /// Conditional button spring animation that respects reduce motion preference
    public static func conditionalButtonSpring(_ reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : buttonSpring
    }

    /// Conditional quick animation that respects reduce motion preference
    public static func conditionalQuickAnimation(_ reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : .easeInOut(duration: animationQuick)
    }

    // MARK: - MeshGradient (iOS 18+)

    /// Get the mesh gradient configuration for the current theme
    @available(iOS 18.0, *)
    @MainActor
    public static var meshConfig: MeshGradientConfig {
        switch currentTheme {
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

    // MARK: - Shadows

    public static func glassShadow(for color: Color = .black) -> some View {
        Color.clear
            .shadow(color: color.opacity(glassShadowOpacityPrimary), radius: 10, y: 5)
            .shadow(color: color.opacity(glassShadowOpacitySecondary), radius: 20, y: 10)
    }
}

// MARK: - Glass Effect Helpers

public extension GlassTheme {
    @ViewBuilder
    static func glassCardBackground(cornerRadius: CGFloat, material: Material) -> some View {
        #if os(iOS)
        if #available(iOS 18.0, *) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.clear)
                .glassEffect(.regular)
        } else {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(material)
        }
        #else
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(material)
        #endif
    }

    @ViewBuilder
    static func glassCircleBackground(material: Material) -> some View {
        #if os(iOS)
        if #available(iOS 18.0, *) {
            Circle()
                .fill(Color.clear)
                .glassEffect(.regular)
        } else {
            Circle()
                .fill(material)
        }
        #else
        Circle()
            .fill(material)
        #endif
    }

    @ViewBuilder
    static func glassCapsuleBackground(material: Material) -> some View {
        #if os(iOS)
        if #available(iOS 18.0, *) {
            Capsule()
                .fill(Color.clear)
                .glassEffect(.regular)
        } else {
            Capsule()
                .fill(material)
        }
        #else
        Capsule()
            .fill(material)
        #endif
    }
}

// MARK: - Color Extension

extension Color {
    /// Initialize color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }

    /// Create adaptive color for light and dark modes
    init(light: Color, dark: Color) {
        #if os(iOS)
        self = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #else
        self = light
        #endif
    }
}
