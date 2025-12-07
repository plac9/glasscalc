import XCTest

/// Automated screenshot capture for App Store submission
final class ScreenshotTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["SCREENSHOT_MODE", "DISABLE_ANIMATIONS"]

        // Reset Pro status for free tier screenshots
        app.launchArguments.append("RESET_PURCHASES")

        setupSnapshot(app)
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Screenshot Tests

    func testCaptureAllScreenshots() throws {
        // Give app time to settle
        sleep(2)

        // 1. Calculator (Aurora theme) - FREE TIER
        snapshot("01_Calculator")
        sleep(1)

        // 2. History view with upgrade banner
        tapTab("History")
        sleep(1)
        snapshot("02_History_Free")

        // 3. Pro Paywall - Tip Calculator
        tapTab("Tip")
        sleep(1)
        snapshot("03_Paywall_Tip")

        // Close paywall
        if app.buttons["Close"].exists {
            app.buttons["Close"].tap()
        }
        sleep(1)

        // 4. Settings - Theme selection
        tapTab("Settings")
        sleep(1)
        snapshot("04_Themes")

        // Now simulate Pro purchase for Pro screenshots
        app.terminate()
        app.launchArguments.removeAll { $0 == "RESET_PURCHASES" }
        app.launchArguments.append("SIMULATE_PRO_PURCHASE")
        app.launch()
        sleep(2)

        // 5. Tip Calculator - PRO (Blue-Green theme)
        tapTab("Tip")
        sleep(1)
        snapshot("05_Tip_Calculator_Pro")

        // 6. Discount Calculator - PRO (Forest Earth theme)
        tapTab("Discount")
        sleep(1)
        snapshot("06_Discount_Calculator_Pro")

        // 7. Split Bill - PRO (Calming Blues theme)
        tapTab("Split")
        sleep(1)
        snapshot("07_Split_Bill_Pro")

        // 8. Unit Converter - PRO (Soft Tranquil theme)
        tapTab("Convert")
        sleep(1)
        snapshot("08_Unit_Converter_Pro")

        // 9. History - PRO (Midnight theme) - unlimited
        tapTab("History")
        sleep(1)
        snapshot("09_History_Pro")

        // 10. Calculator with calculation displayed
        tapTab("Calculator")
        sleep(1)

        // Perform calculation: 1234.56
        tapButton("1")
        tapButton("2")
        tapButton("3")
        tapButton("4")
        tapButton(".")
        tapButton("5")
        tapButton("6")
        sleep(1)
        snapshot("10_Calculator_Result")
    }

    // MARK: - Helper Methods

    private func tapTab(_ label: String) {
        let tabBar = app.tabBars
        let tab = tabBar.buttons[label]

        if tab.waitForExistence(timeout: 5) {
            tab.tap()
            sleep(1)
        } else {
            XCTFail("Tab '\(label)' not found")
        }
    }

    private func tapButton(_ label: String) {
        let button = app.buttons[label]

        if button.waitForExistence(timeout: 3) {
            button.tap()
        } else {
            XCTFail("Button '\(label)' not found")
        }
    }

    private func snapshot(_ name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

// MARK: - Snapshot Helper (Fastlane Integration)

func setupSnapshot(_ app: XCUIApplication) {
    Snapshot.setupSnapshot(app)
}

enum Snapshot {
    static func setupSnapshot(_ app: XCUIApplication) {
        app.launchArguments += ["-AppleLanguages", "(en)"]
        app.launchArguments += ["-AppleLocale", "en_US"]
    }
}
