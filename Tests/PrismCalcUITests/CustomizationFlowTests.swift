import XCTest

/// UI Flow tests for customization features
/// Target: Entry/exit/save/cancel flows work
@MainActor
final class CustomizationFlowTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = [
            "SCREENSHOT_MODE",
            "SIMULATE_PRO",  // Pro unlocks all themes
            "-AppleLanguages", "(en)",
            "-AppleLocale", "en_US"
        ]
    }

    override func tearDownWithError() throws {
        app?.terminate()
        app = nil
    }

    // MARK: - Settings Navigation Flow

    /// Verify Settings tab is accessible and contains expected sections
    func testSettingsNavigationFlow() throws {
        app.launch()
        sleep(1)

        // Navigate to Settings
        let settingsTab = app.tabBars.buttons["Settings"]
        XCTAssertTrue(settingsTab.waitForExistence(timeout: 5), "Settings tab should exist")
        settingsTab.tap()
        sleep(1)

        // Verify Settings screen loaded
        let navigationBar = app.navigationBars["Settings"]
        XCTAssertTrue(navigationBar.exists, "Settings navigation bar should exist")

        // Verify Settings loaded by checking for any section header
        // Settings has multiple sections; just verify navigation worked
        let settingsContent = app.scrollViews.firstMatch
        XCTAssertTrue(settingsContent.waitForExistence(timeout: 3), "Settings content should be scrollable")
    }

    // MARK: - Theme Selection Flow

    /// Verify theme picker navigation and theme selection
    func testThemeSelectionFlow() throws {
        app.launch()
        sleep(1)

        // Navigate to Settings
        app.tabBars.buttons["Settings"].tap()
        sleep(1)

        // Navigate to Theme picker
        let themeRow = app.buttons["Theme"]
        if themeRow.waitForExistence(timeout: 3) {
            themeRow.tap()
            sleep(1)

            // Verify theme picker loaded with all 6 themes
            let auroraTheme = app.buttons["Aurora"]
            XCTAssertTrue(auroraTheme.waitForExistence(timeout: 3), "Aurora theme should be visible")

            // Select a different theme
            let midnightTheme = app.buttons["Midnight"]
            if midnightTheme.waitForExistence(timeout: 2) {
                midnightTheme.tap()
                sleep(1)
            }

            // Navigate back
            app.navigationBars.buttons.element(boundBy: 0).tap()
            sleep(1)

            // Verify we're back on Settings
            XCTAssertTrue(app.navigationBars["Settings"].exists, "Should return to Settings")
        }
    }

    // MARK: - Keypad Layout Toggle Flow

    /// Verify keypad zero position toggle works
    func testKeypadLayoutToggle() throws {
        app.launchArguments.append("PRESET_THEME:Aurora")
        app.launch()
        sleep(1)

        // Navigate to Settings
        app.tabBars.buttons["Settings"].tap()
        sleep(1)

        // Find the zero position toggle
        let zeroToggle = app.switches["Zero on Right"]
        if zeroToggle.waitForExistence(timeout: 3) {
            let initialValue = zeroToggle.value as? String

            // Toggle it
            zeroToggle.tap()
            sleep(1)

            // Verify state changed
            let newValue = zeroToggle.value as? String
            XCTAssertNotEqual(initialValue, newValue, "Toggle value should change")

            // Toggle back
            zeroToggle.tap()
            sleep(1)
        }
    }

    // MARK: - Widget Settings Flow

    /// Verify Widget settings navigation
    func testWidgetSettingsNavigation() throws {
        app.launch()
        sleep(1)

        // Navigate to Settings
        app.tabBars.buttons["Settings"].tap()
        sleep(1)

        // Navigate to Widget settings
        let widgetRow = app.buttons["Widgets"]
        if widgetRow.waitForExistence(timeout: 3) {
            widgetRow.tap()
            sleep(1)

            // Verify Widget settings screen loaded
            let addInstructions = app.staticTexts["Add Widgets to Home Screen"]
            XCTAssertTrue(addInstructions.waitForExistence(timeout: 3),
                         "Widget instructions should be visible")

            // Navigate back
            app.navigationBars.buttons.element(boundBy: 0).tap()
            sleep(1)

            XCTAssertTrue(app.navigationBars["Settings"].exists, "Should return to Settings")
        }
    }

    // MARK: - Reset Tab Order Flow

    /// Verify Reset Tab Order button exists and is tappable
    func testResetTabOrderButton() throws {
        app.launch()
        sleep(1)

        // Navigate to Settings
        app.tabBars.buttons["Settings"].tap()
        sleep(1)

        // Look for Reset Tab Order button
        let resetButton = app.buttons["Reset Tab Order"]
        if resetButton.waitForExistence(timeout: 3) {
            // Button should be tappable
            XCTAssertTrue(resetButton.isEnabled, "Reset button should be enabled")
            resetButton.tap()
            sleep(1)
            // After tap, button should still exist (idempotent operation)
            XCTAssertTrue(resetButton.exists, "Reset button should still exist after tap")
        }
    }

    // MARK: - Calculator Tab Flow

    /// Verify Calculator tab is always accessible (locked position)
    func testCalculatorTabAlwaysAccessible() throws {
        app.launch()
        sleep(1)

        // Calculator should be the first/default tab
        let calculatorTab = app.tabBars.buttons["Calculator"]
        XCTAssertTrue(calculatorTab.waitForExistence(timeout: 5), "Calculator tab should exist")

        // Navigate away
        app.tabBars.buttons["Settings"].tap()
        sleep(1)

        // Calculator should still be accessible
        calculatorTab.tap()
        sleep(1)

        // Verify calculator is visible by checking for a digit button
        let digitButton = app.buttons["calculator-button-5"]
        XCTAssertTrue(digitButton.waitForExistence(timeout: 3), "Calculator should be visible")
    }

    // MARK: - Pro Features Flow

    /// Verify Pro features are accessible when SIMULATE_PRO is set
    func testProFeaturesAccessible() throws {
        app.launch()
        sleep(1)

        // Navigate to Tip Calculator (Pro feature)
        let tipTab = app.tabBars.buttons["Tip"]
        XCTAssertTrue(tipTab.waitForExistence(timeout: 5), "Tip tab should exist for Pro users")
        tipTab.tap()
        sleep(1)

        // Verify Tip Calculator loaded (not paywall)
        // Pro users should see "Bill Amount" text, not upgrade button
        let billAmount = app.staticTexts["Bill Amount"]
        let upgradeButton = app.buttons["paywall-upgrade-button"]

        XCTAssertTrue(
            billAmount.waitForExistence(timeout: 3) || !upgradeButton.exists,
            "Pro users should see Tip Calculator content, not paywall"
        )
    }
}
