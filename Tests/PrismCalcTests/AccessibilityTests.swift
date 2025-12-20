import Testing
import SwiftUI
@testable import PrismCalc

/// Tests for accessibility compliance
/// Target: No unlabeled interactive elements
@Suite("Accessibility Tests")
struct AccessibilityTests {

    // MARK: - GlassButton Default Labels

    @MainActor
    @Test("GlassButton provides default labels for digits")
    func testGlassButtonDigitLabels() {
        // Verify all digits have VoiceOver-friendly labels
        let expectedLabels = [
            "0": "Zero",
            "1": "One",
            "2": "Two",
            "3": "Three",
            "4": "Four",
            "5": "Five",
            "6": "Six",
            "7": "Seven",
            "8": "Eight",
            "9": "Nine"
        ]

        for (digit, expectedLabel) in expectedLabels {
            let label = GlassButton.defaultAccessibilityLabel(for: digit)
            #expect(label == expectedLabel, "Digit \(digit) should have label '\(expectedLabel)', got '\(label)'")
        }
    }

    @MainActor
    @Test("GlassButton provides default labels for operators")
    func testGlassButtonOperatorLabels() {
        let expectedLabels = [
            "+": "Plus",
            "-": "Minus",
            "x": "Multiply",
            "/": "Divide",
            "=": "Equals",
            ".": "Decimal point"
        ]

        for (op, expectedLabel) in expectedLabels {
            let label = GlassButton.defaultAccessibilityLabel(for: op)
            #expect(label == expectedLabel, "Operator '\(op)' should have label '\(expectedLabel)', got '\(label)'")
        }
    }

    @MainActor
    @Test("GlassButton provides default labels for special buttons")
    func testGlassButtonSpecialLabels() {
        let expectedLabels = [
            "AC": "Clear all",
            "+/-": "Toggle positive negative",
            "%": "Percent"
        ]

        for (special, expectedLabel) in expectedLabels {
            let label = GlassButton.defaultAccessibilityLabel(for: special)
            #expect(label == expectedLabel, "Special button '\(special)' should have label '\(expectedLabel)', got '\(label)'")
        }
    }

    @MainActor
    @Test("GlassButton falls back to label for unknown input")
    func testGlassButtonUnknownFallback() {
        // Unknown labels should return the label itself
        let unknownInputs = ["?", "unknown", "test"]
        for input in unknownInputs {
            let label = GlassButton.defaultAccessibilityLabel(for: input)
            #expect(label == input, "Unknown input '\(input)' should fall back to itself")
        }
    }

    // MARK: - Calculator Engine Accessibility

    @Test("CalculatorEngine.formatDisplay produces VoiceOver-friendly output")
    func testCalculatorDisplayFormat() {
        // Verify display text is readable
        let formatted = CalculatorEngine.formatDisplay(1234567)
        #expect(formatted == "1,234,567")
        // Comma-separated numbers are readable by VoiceOver

        let error = CalculatorEngine.formatDisplay(.nan)
        #expect(error == "Error")
        // "Error" is clear and understandable
    }

    // MARK: - Theme Accessibility

    @Test("All themes have distinguishable names")
    func testThemeNamesDistinguishable() {
        let names = GlassTheme.Theme.allCases.map { $0.rawValue }
        let uniqueNames = Set(names)
        #expect(uniqueNames.count == names.count, "Each theme should have a unique name for accessibility")

        // Verify names are not empty
        for theme in GlassTheme.Theme.allCases {
            #expect(!theme.rawValue.isEmpty, "Theme name should not be empty")
        }
    }

    // MARK: - Touch Target Size

    @Test("Button sizes meet minimum 44pt touch target")
    func testMinimumTouchTargets() {
        // Apple HIG requires 44x44pt minimum for touch targets
        let minimumSize: CGFloat = 44

        #expect(GlassTheme.buttonSizeCompact >= minimumSize,
                "Compact button size (\(GlassTheme.buttonSizeCompact)) should be >= 44pt")
        #expect(GlassTheme.buttonSize >= minimumSize,
                "Standard button size (\(GlassTheme.buttonSize)) should be >= 44pt")
        #expect(GlassTheme.buttonSizeLarge >= minimumSize,
                "Large button size (\(GlassTheme.buttonSizeLarge)) should be >= 44pt")
    }

    // MARK: - Spacing for Readability

    @Test("Spacing values provide adequate separation")
    func testSpacingForReadability() {
        // Verify spacing is adequate for touch targets and readability
        #expect(GlassTheme.spacingSmall >= 8, "Small spacing should be at least 8pt")
        #expect(GlassTheme.spacingMedium >= 12, "Medium spacing should be at least 12pt")
        #expect(GlassTheme.spacingLarge >= 20, "Large spacing should be at least 20pt")
    }

    // MARK: - Color Contrast (Conceptual)

    @Test("All themes have gradient colors defined")
    func testThemeColorsDefined() {
        // While we can't test contrast programmatically without rendering,
        // we can verify the gradient properties are defined
        // (GlassTheme.auroraGradient, etc. are static and theme-switched)
        let gradients: [[Color]] = [
            GlassTheme.auroraGradient,
            GlassTheme.calmingBluesGradient,
            GlassTheme.forestEarthGradient,
            GlassTheme.softTranquilGradient,
            GlassTheme.blueGreenGradient,
            GlassTheme.midnightGradient
        ]

        for (index, gradient) in gradients.enumerated() {
            let themeName = GlassTheme.Theme.allCases[index].rawValue
            #expect(!gradient.isEmpty, "Theme \(themeName) should have gradient colors")
            #expect(gradient.count >= 2, "Theme \(themeName) should have at least 2 gradient colors")
        }
    }

    // MARK: - Widget Accessibility

    @Test("Widget history items have accessible structure")
    func testWidgetHistoryItemAccessibility() {
        let item = WidgetHistoryItem(
            type: "Tip",
            result: "$23.60",
            details: "$20 + 18%",
            icon: "dollarsign.circle"
        )

        // Verify all fields are populated (VoiceOver can read them)
        #expect(!item.type.isEmpty)
        #expect(!item.result.isEmpty)
        #expect(!item.details.isEmpty)
        #expect(!item.icon.isEmpty)
    }

    // MARK: - History Entry Accessibility

    @Test("History entries have accessible content")
    func testHistoryEntryAccessibility() {
        let entry = HistoryEntry(
            calculationType: .basic,
            result: "42",
            details: "6 x 7 =",
            expression: "6 x 7",
            note: "The answer"
        )

        // Verify VoiceOver-critical fields
        #expect(!entry.result.isEmpty)
        #expect(!entry.details.isEmpty)
        #expect(entry.expression != nil && !entry.expression!.isEmpty)
        #expect(entry.note != nil)
    }

    // MARK: - Tip Calculator Accessibility Values

    @Test("Tip preset values are meaningful for accessibility")
    func testTipPresetAccessibility() {
        let presets: [Double] = [15, 18, 20, 25]
        for preset in presets {
            // Verify presets are whole numbers (easier to announce)
            #expect(preset == preset.rounded(), "Tip preset \(preset) should be a whole number")
            // Verify they're in reasonable range
            #expect(preset >= 0 && preset <= 100, "Tip preset should be 0-100%")
        }
    }
}
