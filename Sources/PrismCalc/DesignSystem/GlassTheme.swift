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

    // MARK: - Aurora Theme (Default)

    public static let auroraPrimary = Color(hex: "7B68EE")      // Medium slate blue
    public static let auroraSecondary = Color(hex: "00CED1")    // Dark turquoise
    public static let auroraTertiary = Color(hex: "FF69B4")     // Hot pink accent

    public static var auroraGradient: [Color] {
        [
            Color.blue.opacity(0.4),
            Color.purple.opacity(0.3),
            Color.cyan.opacity(0.3)
        ]
    }

    // MARK: - Calming Blues Theme

    public static let calmingBluesPrimary = Color(hex: "83BCD4")
    public static let calmingBluesSecondary = Color(hex: "A4D1E0")

    public static var calmingBluesGradient: [Color] {
        [
            Color(hex: "83BCD4").opacity(0.4),
            Color(hex: "A4D1E0").opacity(0.3),
            Color(hex: "B1DEE0").opacity(0.3)
        ]
    }

    // MARK: - Forest Earth Theme

    public static let forestEarthPrimary = Color(hex: "4E785E")
    public static let forestEarthSecondary = Color(hex: "2A4B44")

    public static var forestEarthGradient: [Color] {
        [
            Color(hex: "4E785E").opacity(0.4),
            Color(hex: "2A4B44").opacity(0.3),
            Color(hex: "4C5C65").opacity(0.3)
        ]
    }

    // MARK: - Soft Tranquil Theme

    public static let softTranquilPrimary = Color(hex: "C5E3F6")
    public static let softTranquilSecondary = Color(hex: "D4F1F4")

    public static var softTranquilGradient: [Color] {
        [
            Color(hex: "C5E3F6").opacity(0.5),
            Color(hex: "D4F1F4").opacity(0.4),
            Color(hex: "E8F8F5").opacity(0.4)
        ]
    }

    // MARK: - Blue-Green Harmony Theme

    public static let blueGreenPrimary = Color(hex: "00CEC8")
    public static let blueGreenSecondary = Color(hex: "2E8B57")

    public static var blueGreenGradient: [Color] {
        [
            Color(hex: "00CEC8").opacity(0.4),
            Color(hex: "2E8B57").opacity(0.3),
            Color(hex: "20B2AA").opacity(0.3)
        ]
    }

    // MARK: - Midnight Theme

    public static let midnightPrimary = Color(hex: "6366F1")    // Indigo
    public static let midnightSecondary = Color(hex: "8B5CF6")  // Violet

    public static var midnightGradient: [Color] {
        [
            Color(hex: "1E1B4B").opacity(0.9),
            Color(hex: "312E81").opacity(0.7),
            Color(hex: "3730A3").opacity(0.5)
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
        Color(light: Color(hex: "1A1A1A"), dark: Color(hex: "F8F9FA"))
    }

    public static var textSecondary: Color {
        text.opacity(0.7)
    }

    public static var textTertiary: Color {
        text.opacity(0.5)
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
            .shadow(color: color.opacity(0.15), radius: 10, y: 5)
            .shadow(color: color.opacity(0.1), radius: 20, y: 10)
    }
}

// MARK: - Color Extension

extension Color {
    /// Initialize color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
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
