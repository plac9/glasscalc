import Testing
import SwiftUI
@testable import PrismCalc

/// Tests for theme propagation
@Suite("Theme Tests")
struct ThemeTests {

    // MARK: - Theme Enumeration

    @Test("All 6 themes are available")
    func testAllThemesAvailable() {
        let themes = GlassTheme.Theme.allCases
        #expect(themes.count == 6)
        #expect(themes.contains(.aurora))
        #expect(themes.contains(.calmingBlues))
        #expect(themes.contains(.forestEarth))
        #expect(themes.contains(.softTranquil))
        #expect(themes.contains(.blueGreenHarmony))
        #expect(themes.contains(.midnight))
    }

    @Test("Each theme has unique ID")
    func testThemesHaveUniqueIDs() {
        let themes = GlassTheme.Theme.allCases
        let ids = themes.map { $0.id }
        let uniqueIds = Set(ids)
        #expect(uniqueIds.count == themes.count)
    }

    @Test("Each theme has display name")
    func testThemesHaveDisplayNames() {
        for theme in GlassTheme.Theme.allCases {
            #expect(!theme.rawValue.isEmpty)
        }
    }

    // MARK: - Pro Status

    @Test("Aurora is free")
    func testAuroraIsFree() {
        #expect(GlassTheme.Theme.aurora.isPro == false)
    }

    @Test("Other themes are pro")
    func testOtherThemesArePro() {
        #expect(GlassTheme.Theme.calmingBlues.isPro == true)
        #expect(GlassTheme.Theme.forestEarth.isPro == true)
        #expect(GlassTheme.Theme.softTranquil.isPro == true)
        #expect(GlassTheme.Theme.blueGreenHarmony.isPro == true)
        #expect(GlassTheme.Theme.midnight.isPro == true)
    }

    // MARK: - Gradient Colors

    @Test("All themes have gradient colors")
    func testAllThemesHaveGradients() {
        #expect(!GlassTheme.auroraGradient.isEmpty)
        #expect(!GlassTheme.calmingBluesGradient.isEmpty)
        #expect(!GlassTheme.forestEarthGradient.isEmpty)
        #expect(!GlassTheme.softTranquilGradient.isEmpty)
        #expect(!GlassTheme.blueGreenGradient.isEmpty)
        #expect(!GlassTheme.midnightGradient.isEmpty)
    }

    @Test("Gradients have multiple colors")
    func testGradientsHaveMultipleColors() {
        #expect(GlassTheme.auroraGradient.count >= 2)
        #expect(GlassTheme.calmingBluesGradient.count >= 2)
        #expect(GlassTheme.forestEarthGradient.count >= 2)
        #expect(GlassTheme.softTranquilGradient.count >= 2)
        #expect(GlassTheme.blueGreenGradient.count >= 2)
        #expect(GlassTheme.midnightGradient.count >= 2)
    }

    // MARK: - Theme Switching

    @MainActor
    @Test("Current theme can be changed")
    func testCurrentThemeCanBeChanged() {
        let originalTheme = GlassTheme.currentTheme

        GlassTheme.currentTheme = .midnight
        #expect(GlassTheme.currentTheme == .midnight)

        GlassTheme.currentTheme = .forestEarth
        #expect(GlassTheme.currentTheme == .forestEarth)

        // Restore
        GlassTheme.currentTheme = originalTheme
    }

    // MARK: - Spacing Constants

    @Test("Spacing constants are positive")
    func testSpacingConstantsPositive() {
        #expect(GlassTheme.spacingXS > 0)
        #expect(GlassTheme.spacingSmall > 0)
        #expect(GlassTheme.spacingMedium > 0)
        #expect(GlassTheme.spacingLarge > 0)
        #expect(GlassTheme.spacingXL > 0)
    }

    @Test("Spacing increases progressively")
    func testSpacingProgressive() {
        #expect(GlassTheme.spacingXS < GlassTheme.spacingSmall)
        #expect(GlassTheme.spacingSmall < GlassTheme.spacingMedium)
        #expect(GlassTheme.spacingMedium < GlassTheme.spacingLarge)
        #expect(GlassTheme.spacingLarge < GlassTheme.spacingXL)
    }

    // MARK: - Corner Radius Constants

    @Test("Corner radius constants are positive")
    func testCornerRadiusPositive() {
        #expect(GlassTheme.cornerRadiusSmall > 0)
        #expect(GlassTheme.cornerRadiusMedium > 0)
        #expect(GlassTheme.cornerRadiusLarge > 0)
        #expect(GlassTheme.cornerRadiusXL > 0)
    }

    // MARK: - Button Size Constants

    @Test("Button sizes meet minimum touch target")
    func testButtonSizes() {
        #expect(GlassTheme.buttonSizeCompact >= 44) // Minimum touch target (Apple HIG)
        #expect(GlassTheme.buttonSize >= GlassTheme.buttonSizeCompact)
        #expect(GlassTheme.buttonSizeLarge >= GlassTheme.buttonSize)
    }
}
