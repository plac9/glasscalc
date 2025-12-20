import XCTest

/// Automated screenshot capture for App Store submission
@MainActor
final class ScreenshotTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app?.terminate()
        app = nil
    }

    // MARK: - Screenshot Tests

    /// Capture all 10 App Store screenshots automatically
    func testCaptureAllScreenshots() throws {
        // Screenshot 1-4: Free Tier
        captureFreeTierScreenshots()

        // Screenshot 5-10: Pro Tier
        captureProTierScreenshots()
    }

    /// M5-T3: Capture calculator screenshot for all 6 themes to establish baseline
    func testCaptureAllThemes() throws {
        let themes = ["Aurora", "CalmingBlues", "ForestEarth", "SoftTranquil", "BlueGreenHarmony", "Midnight"]

        for theme in themes {
            captureScreenshotOnTab(
                name: "Theme_\(theme)_Calculator",
                tab: "Calculator",
                pro: true,
                theme: theme,
                populateData: true
            ) {
                self.tapCalculatorButtons(["4", "2"])
            }

            captureScreenshotOnTab(
                name: "Theme_\(theme)_Tip",
                tab: "Tip",
                pro: true,
                theme: theme,
                populateData: true
            )
        }
    }

    // MARK: - Free Tier Screenshots

    private func captureFreeTierScreenshots() {
        // 1. Calculator - Hero shot
        captureScreenshotOnTab(
            name: "01_Calculator_Free",
            tab: "Calculator",
            pro: false,
            theme: "Aurora",
            populateData: true
        ) {
            self.tapCalculatorButtons(["1", "2", "3", "4", "decimal", "5", "6"])
        }

        // 2. History - Free tier (10 items + upgrade banner)
        captureScreenshotOnTab(
            name: "02_History_Free",
            tab: "History",
            pro: false,
            theme: "Aurora",
            populateData: true
        )

        // 3. Paywall - Tip Calculator
        captureScreenshotOnTab(
            name: "03_Paywall_Tip",
            tab: "Tip",
            pro: false,
            theme: "Aurora",
            populateData: false
        )

        // 4. Settings - Themes (Aurora unlocked, others locked)
        captureScreenshotOnTab(
            name: "04_Themes_Free",
            tab: "Settings",
            pro: false,
            theme: "Aurora",
            populateData: false
        )
    }

    // MARK: - Pro Tier Screenshots

    private func captureProTierScreenshots() {
        // 5. Tip Calculator - PRO
        captureScreenshotOnTab(
            name: "05_Tip_Calculator_Pro",
            tab: "Tip",
            pro: true,
            theme: "Aurora",
            populateData: true
        )

        // 6. Discount Calculator - PRO
        captureScreenshotOnTab(
            name: "06_Discount_Calculator_Pro",
            tab: "Discount",
            pro: true,
            theme: "Aurora",
            populateData: true
        )

        // 7. Split Bill - PRO
        captureScreenshotOnTab(
            name: "07_Split_Bill_Pro",
            tab: "Split",
            pro: true,
            theme: "Aurora",
            populateData: true
        )

        // 8. Unit Converter - PRO
        captureScreenshotOnTab(
            name: "08_Unit_Converter_Pro",
            tab: "Convert",
            pro: true,
            theme: "Aurora",
            populateData: true
        )

        // 9. History - PRO (unlimited)
        captureScreenshotOnTab(
            name: "09_History_Pro",
            tab: "History",
            pro: true,
            theme: "Aurora",
            populateData: true
        )

        // 10. Calculator with result
        captureScreenshotOnTab(
            name: "10_Calculator_Result_Pro",
            tab: "Calculator",
            pro: true,
            theme: "Aurora",
            populateData: true
        ) {
            self.tapCalculatorButtons(["9", "9", "9", "decimal", "9", "9"])
        }
    }

    // MARK: - Helper Methods

    private func setupApp(
        pro: Bool,
        theme: String,
        populateData: Bool = false,
        selectedTab: String? = nil
    ) {
        app.terminate()
        app.launchArguments = [
            "SCREENSHOT_MODE",
            "-AppleLanguages", "(en)",
            "-AppleLocale", "en_US"
        ]

        if pro {
            app.launchArguments.append("SIMULATE_PRO")
        } else {
            app.launchArguments.append("RESET_PURCHASES")
        }

        app.launchArguments.append("PRESET_THEME:\(theme)")

        if populateData {
            app.launchArguments.append("POPULATE_DATA")
        }

        if let selectedTab {
            app.launchArguments.append("SELECT_TAB:\(selectedTab)")
        }

        app.launch()
        sleep(2) // Wait for app to fully load
    }
    private func captureScreenshotOnTab(
        name: String,
        tab: String,
        pro: Bool,
        theme: String,
        populateData: Bool,
        afterLaunch: (() -> Void)? = nil
    ) {
        setupApp(pro: pro, theme: theme, populateData: populateData, selectedTab: tab)
        sleep(1)
        afterLaunch?()
        sleep(1)
        captureScreenshot(name)
    }

    private func tapCalculatorButtons(_ buttons: [String]) {
        for button in buttons {
            let identifier = "calculator-button-\(button)"
            let buttonElement = app.buttons[identifier]

            if buttonElement.waitForExistence(timeout: 3) {
                buttonElement.tap()
                usleep(100000) // 0.1 second between taps
            } else {
                XCTFail("Calculator button '\(button)' not found (tried: \(identifier))")
            }
        }
    }

    private func captureScreenshot(_ name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)

        print("📸 Captured screenshot: \(name)")
    }
}
