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
        captureAppStoreScreenshots()
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

    // MARK: - App Store Screenshots

    private func captureAppStoreScreenshots() {
        // 1. Calculator - Hero shot
        captureScreenshotOnTab(
            name: "01_Calculator_Hero",
            tab: "Calculator",
            pro: true,
            theme: "Aurora",
            populateData: true
        ) {
            self.tapCalculatorButtons(["1", "2", "3", "4", "decimal", "5", "6"])
        }

        // 2. Tip Calculator
        captureScreenshotOnTab(
            name: "02_Tip_Calculator",
            tab: "Tip",
            pro: true,
            theme: "Aurora",
            populateData: true
        ) {
            self.typeValue("75", into: "Bill amount")
            self.tapButtonIfExists("20%")
            self.tapButtonIfExists("Done")
        }

        // 3. Split Bill
        captureScreenshotOnTab(
            name: "03_Split_Bill",
            tab: "Split",
            pro: true,
            theme: "Aurora",
            populateData: true
        ) {
            self.typeValue("120", into: "Total bill")
            self.tapButtonIfExists("Increase people")
            self.tapButtonIfExists("Increase people")
            self.tapButtonIfExists("Increase people")
            self.tapButtonIfExists("Done")
        }

        // 4. Discount Calculator
        captureScreenshotOnTab(
            name: "04_Discount",
            tab: "Discount",
            pro: true,
            theme: "Aurora",
            populateData: true
        ) {
            self.typeValue("120", into: "Original price")
            self.tapButtonIfExists("25%")
            self.tapButtonIfExists("Done")
        }

        // 5. Unit Converter
        captureScreenshotOnTab(
            name: "05_Unit_Converter",
            tab: "Convert",
            pro: true,
            theme: "Aurora",
            populateData: true
        ) {
            self.typeValue("5", into: "Input value")
            self.tapButtonIfExists("Done")
        }

        // 6. Themes (open picker on the Settings screen)
        captureScreenshotOnTab(
            name: "06_Themes",
            tab: "Settings",
            pro: true,
            theme: "Aurora",
            populateData: false
        ) {
            self.openThemePicker()
            self.tapButtonIfExists("Done")
        }

        // 7. History
        captureScreenshotOnTab(
            name: "07_History",
            tab: "History",
            pro: true,
            theme: "Aurora",
            populateData: true
        ) {
            self.dismissTipIfPresent()
            self.tapButtonIfExists("Done")
        }

        // 8. Widgets (open picker on the Settings screen)
        captureScreenshotOnTab(
            name: "08_Widgets",
            tab: "Settings",
            pro: true,
            theme: "Aurora",
            populateData: false
        ) {
            self.openSettingsRow("Widgets")
            self.tapButtonIfExists("Done")
        }

        // 9. App Icon (open picker on the Settings screen)
        captureScreenshotOnTab(
            name: "09_App_Icon",
            tab: "Settings",
            pro: true,
            theme: "Aurora",
            populateData: false
        ) {
            self.openSettingsRow("App Icon")
            self.tapButtonIfExists("Done")
        }

        // 10. Calculator with result
        captureScreenshotOnTab(
            name: "10_Calculator_Result",
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
        navigateTo(tab: tab)
        sleep(1)
        afterLaunch?()
        sleep(1)
        captureScreenshot(name)
    }

    private func navigateTo(tab: String) {
        if tapNavigationItem(named: tab, timeout: 3) {
            return
        }

        if tapNavigationItem(named: "More", timeout: 5) {
            XCTAssertTrue(
                tapNavigationItem(named: tab, timeout: 5),
                "\(tab) should exist in More"
            )
        }
    }

    private func tapNavigationItem(named label: String, timeout: TimeInterval) -> Bool {
        let tabBarButton = app.tabBars.buttons.matching(identifier: label).firstMatch
        if tabBarButton.waitForExistence(timeout: timeout) {
            tabBarButton.tap()
            return true
        }

        let sidebarButton = app.buttons.matching(identifier: label).firstMatch
        if sidebarButton.waitForExistence(timeout: timeout) {
            sidebarButton.tap()
            return true
        }

        let sidebarCell = app.cells.matching(identifier: label).firstMatch
        if sidebarCell.waitForExistence(timeout: timeout) {
            sidebarCell.tap()
            return true
        }

        return false
    }

    private func tapCalculatorButtons(_ buttons: [String]) {
        for button in buttons {
            let identifier = "calculator-button-\(button)"
            let buttonElement = app.buttons[identifier]

            if buttonElement.waitForExistence(timeout: 5) {
                buttonElement.tap()
                usleep(100000) // 0.1 second between taps
            } else {
                XCTFail("Calculator button '\(button)' not found (tried: \(identifier))")
            }
        }
    }

    private func typeValue(_ value: String, into fieldLabel: String) {
        let field = app.textFields[fieldLabel].firstMatch
        XCTAssertTrue(field.waitForExistence(timeout: 5), "Text field '\(fieldLabel)' not found")
        field.tap()
        field.typeText(value)
        dismissKeyboardIfPresent()
    }

    private func tapButtonIfExists(_ label: String, timeout: TimeInterval = 2) {
        let button = app.buttons[label].firstMatch
        if button.waitForExistence(timeout: timeout) {
            button.tap()
        }
    }

    private func dismissKeyboardIfPresent() {
        guard app.keyboards.count > 0 else { return }

        let doneButton = app.keyboards.buttons["Done"].firstMatch
        if doneButton.exists {
            doneButton.tap()
            return
        }

        let returnButton = app.keyboards.buttons["Return"].firstMatch
        if returnButton.exists {
            returnButton.tap()
            return
        }

        app.tap()
    }

    private func openThemePicker() {
        let predicate = NSPredicate(format: "label BEGINSWITH %@", "Theme, currently")
        let themeButton = app.buttons.matching(predicate).firstMatch
        if themeButton.waitForExistence(timeout: 5) {
            themeButton.tap()
            return
        }

        let themeCell = app.cells.matching(predicate).firstMatch
        XCTAssertTrue(themeCell.waitForExistence(timeout: 5), "Theme picker row not found")
        themeCell.tap()
    }

    private func openSettingsRow(_ label: String) {
        let button = app.buttons[label].firstMatch
        let cell = app.cells[label].firstMatch

        if button.waitForExistence(timeout: 2) {
            button.tap()
            return
        }

        if cell.waitForExistence(timeout: 2) {
            cell.tap()
            return
        }

        for _ in 0..<3 {
            app.swipeUp()
            if button.waitForExistence(timeout: 1) {
                button.tap()
                return
            }
            if cell.waitForExistence(timeout: 1) {
                cell.tap()
                return
            }
        }

        XCTFail("Settings row '\(label)' not found")
    }

    private func dismissTipIfPresent() {
        let gotItButton = app.buttons["Got It"].firstMatch
        if gotItButton.waitForExistence(timeout: 1) {
            gotItButton.tap()
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
