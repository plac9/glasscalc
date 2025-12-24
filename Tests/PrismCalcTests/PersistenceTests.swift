import Testing
import Foundation
@testable import PrismCalc

/// Tests for UserDefaults persistence
@Suite("Persistence Tests")
struct PersistenceTests {

    // MARK: - Setup/Teardown

    private func makeTestDefaults(_ name: String) -> UserDefaults {
        let suiteName = "test.persistence.\(name)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }

    // MARK: - Zero Position Preference

    @Test("zeroOnRight default is false")
    func testZeroOnRightDefault() {
        let defaults = makeTestDefaults("zeroOnRight.default")
        let value = defaults.bool(forKey: "zeroOnRight")
        #expect(value == false)
    }

    @Test("zeroOnRight persists true")
    func testZeroOnRightPersistsTrue() {
        let defaults = makeTestDefaults("zeroOnRight.true")
        defaults.set(true, forKey: "zeroOnRight")
        let value = defaults.bool(forKey: "zeroOnRight")
        #expect(value == true)
    }

    @Test("zeroOnRight persists false")
    func testZeroOnRightPersistsFalse() {
        let defaults = makeTestDefaults("zeroOnRight.false")
        defaults.set(true, forKey: "zeroOnRight")
        defaults.set(false, forKey: "zeroOnRight")
        let value = defaults.bool(forKey: "zeroOnRight")
        #expect(value == false)
    }

    // MARK: - Tab Customization

    @Test("tabCustomization removal works")
    func testTabCustomizationRemoval() {
        let defaults = makeTestDefaults("tabCustomization")
        // Set a value
        defaults.set("test", forKey: "tabCustomization")
        // Remove it
        defaults.removeObject(forKey: "tabCustomization")
        // Verify it's gone
        let value = defaults.object(forKey: "tabCustomization")
        #expect(value == nil)
    }

    // MARK: - Shared Data Service

    @Test("SharedDataService stores last calculation")
    func testSharedDataServiceLastCalculation() {
        let testDefaults = UserDefaults(suiteName: "test.persistence")!
        testDefaults.removePersistentDomain(forName: "test.persistence")

        let service = SharedDataService(userDefaults: testDefaults, shouldReloadWidgets: false)
        service.saveLastCalculation(result: "42", expression: "6 × 7")

        #expect(service.getLastResult() == "42")
        #expect(service.getLastExpression() == "6 × 7")

        testDefaults.removePersistentDomain(forName: "test.persistence")
    }

    @Test("SharedDataService handles empty state")
    func testSharedDataServiceEmptyState() {
        let testDefaults = UserDefaults(suiteName: "test.persistence.empty")!
        testDefaults.removePersistentDomain(forName: "test.persistence.empty")

        let service = SharedDataService(userDefaults: testDefaults, shouldReloadWidgets: false)

        #expect(service.getLastResult() == "0")
        #expect(service.getLastExpression() == "")
        #expect(service.getRecentHistory().isEmpty)

        testDefaults.removePersistentDomain(forName: "test.persistence.empty")
    }

    @Test("SharedDataService history round-trip")
    func testSharedDataServiceHistoryRoundTrip() {
        let testDefaults = UserDefaults(suiteName: "test.persistence.history")!
        testDefaults.removePersistentDomain(forName: "test.persistence.history")

        let service = SharedDataService(userDefaults: testDefaults, shouldReloadWidgets: false)

        // Add a history item via saveRecentHistory
        let item = WidgetHistoryItem(
            type: "Tip",
            result: "$23.60",
            details: "$20 + 18%",
            icon: "dollarsign.circle"
        )
        service.saveRecentHistory([item])

        let history = service.getRecentHistory()
        #expect(history.count == 1)
        #expect(history.first?.type == "Tip")
        #expect(history.first?.result == "$23.60")
        #expect(history.first?.details == "$20 + 18%")
        #expect(history.first?.icon == "dollarsign.circle")

        testDefaults.removePersistentDomain(forName: "test.persistence.history")
    }

    @Test("SharedDataService clears history")
    func testSharedDataServiceClearsHistory() {
        let testDefaults = UserDefaults(suiteName: "test.persistence.clear")!
        testDefaults.removePersistentDomain(forName: "test.persistence.clear")

        let service = SharedDataService(userDefaults: testDefaults, shouldReloadWidgets: false)

        let item = WidgetHistoryItem(type: "Calc", result: "42", details: "6 × 7", icon: "equal")
        service.saveRecentHistory([item])
        #expect(service.getRecentHistory().count == 1)

        service.clearHistory()
        #expect(service.getRecentHistory().isEmpty)
        #expect(service.getLastResult() == "0")

        testDefaults.removePersistentDomain(forName: "test.persistence.clear")
    }
}
