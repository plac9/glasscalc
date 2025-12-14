import XCTest

/// Automated screenshot capture for App Store submission
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

    // MARK: - Free Tier Screenshots

    private func captureFreeTierScreenshots() {
        setupApp(pro: false, theme: "Aurora", populateData: true)

        // 1. Calculator - Hero shot
        sleep(2)
        tapCalculatorButtons(["1", "2", "3", "4", "decimal", "5", "6"])
        sleep(1)
        captureScreenshot("01_Calculator_Free")

        // 2. History - Free tier (10 items + upgrade banner)
        tapTab("History")
        sleep(1)
        captureScreenshot("02_History_Free")

        // 3. Paywall - Tip Calculator
        tapTab("Tip")
        sleep(1)
        captureScreenshot("03_Paywall_Tip")

        // 4. Settings - Themes (Aurora unlocked, others locked)
        tapTab("Settings")
        sleep(1)
        captureScreenshot("04_Themes_Free")
    }

    // MARK: - Pro Tier Screenshots

    private func captureProTierScreenshots() {
        setupApp(pro: true, theme: "Aurora", populateData: true)

        // 5. Tip Calculator - PRO
        tapTab("Tip")
        sleep(1)
        captureScreenshot("05_Tip_Calculator_Pro")

        // 6. Discount Calculator - PRO
        tapTab("Discount")
        sleep(1)
        captureScreenshot("06_Discount_Calculator_Pro")

        // 7. Split Bill - PRO
        tapTab("Split")
        sleep(1)
        captureScreenshot("07_Split_Bill_Pro")

        // 8. Unit Converter - PRO
        tapTab("Convert")
        sleep(1)
        captureScreenshot("08_Unit_Converter_Pro")

        // 9. History - PRO (unlimited)
        tapTab("History")
        sleep(1)
        captureScreenshot("09_History_Pro")

        // 10. Calculator with result
        tapTab("Calculator")
        sleep(1)
        tapCalculatorButtons(["9", "9", "9", "decimal", "9", "9"])
        sleep(1)
        captureScreenshot("10_Calculator_Result_Pro")
    }

    // MARK: - Helper Methods

    private func setupApp(pro: Bool, theme: String, populateData: Bool = false) {
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

        app.launch()
        sleep(2) // Wait for app to fully load
    }

    private func tapTab(_ identifier: String) {
        // iOS tab bar with "More" menu - try multiple query strategies
        let tabIdentifier = "tab-\(identifier.lowercased())"

        // Strategy 1: Direct button query with accessibility identifier
        let tab = app.buttons[tabIdentifier]
        if tab.waitForExistence(timeout: 2) {
            tab.tap()
            sleep(1)
            return
        }

        // Strategy 2: TabBar buttons by label
        let tabByLabel = app.tabBars.buttons[identifier]
        if tabByLabel.waitForExistence(timeout: 2) {
            tabByLabel.tap()
            sleep(1)
            return
        }

        // Strategy 3: Any button with matching label (direct)
        let anyButton = app.buttons[identifier]
        if anyButton.waitForExistence(timeout: 2) {
            anyButton.tap()
            sleep(1)
            return
        }

        // Strategy 4: Check if tab is in "More" menu
        // First check if we're already in More menu (table exists)
        if app.tables.firstMatch.exists {
            // Already in More menu, just look for the item
            let moreItem = app.tables.cells.containing(.staticText, identifier: identifier).firstMatch
            if moreItem.waitForExistence(timeout: 2) {
                moreItem.tap()
                sleep(1)
                return
            }

            // Try any cell with matching text
            let tableCells = app.tables.cells.allElementsBoundByIndex
            for cell in tableCells {
                if cell.staticTexts[identifier].exists {
                    cell.tap()
                    sleep(1)
                    return
                }
            }

            // Not found, go back and fail
            let backButton = app.navigationBars.buttons.firstMatch
            if backButton.exists {
                backButton.tap()
                sleep(1)
            }
        } else {
            // Not in More menu yet, try to open it
            // Use tab bar button specifically to avoid back button
            let moreButton = app.tabBars.buttons["More"]
            if moreButton.exists {
                moreButton.tap()
                sleep(1)

                // Try finding by cell
                let moreItem = app.tables.cells.containing(.staticText, identifier: identifier).firstMatch
                if moreItem.waitForExistence(timeout: 2) {
                    moreItem.tap()
                    sleep(1)
                    return
                }

                // Try any cell with matching text
                let tableCells = app.tables.cells.allElementsBoundByIndex
                for cell in tableCells {
                    if cell.staticTexts[identifier].exists {
                        cell.tap()
                        sleep(1)
                        return
                    }
                }

                // Go back if not found
                let backButton = app.navigationBars.buttons.firstMatch
                if backButton.exists {
                    backButton.tap()
                    sleep(1)
                }
            }
        }

        XCTFail("Tab '\(identifier)' not found after trying all strategies including More menu")
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
