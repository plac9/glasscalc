import Testing
import Foundation
@testable import PrismCalc

/// Tests for UserDefaults persistence
@Suite("Persistence Tests")
struct PersistenceTests {

    // MARK: - Setup/Teardown

    private func cleanupUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "zeroOnRight")
        UserDefaults.standard.removeObject(forKey: "tabCustomization")
    }

    // MARK: - Zero Position Preference

    @Test("zeroOnRight default is false")
    func testZeroOnRightDefault() {
        cleanupUserDefaults()
        let value = UserDefaults.standard.bool(forKey: "zeroOnRight")
        #expect(value == false)
    }

    @Test("zeroOnRight persists true")
    func testZeroOnRightPersistsTrue() {
        cleanupUserDefaults()
        UserDefaults.standard.set(true, forKey: "zeroOnRight")
        let value = UserDefaults.standard.bool(forKey: "zeroOnRight")
        #expect(value == true)
        cleanupUserDefaults()
    }

    @Test("zeroOnRight persists false")
    func testZeroOnRightPersistsFalse() {
        cleanupUserDefaults()
        UserDefaults.standard.set(true, forKey: "zeroOnRight")
        UserDefaults.standard.set(false, forKey: "zeroOnRight")
        let value = UserDefaults.standard.bool(forKey: "zeroOnRight")
        #expect(value == false)
        cleanupUserDefaults()
    }

    // MARK: - Tab Customization

    @Test("tabCustomization removal works")
    func testTabCustomizationRemoval() {
        // Set a value
        UserDefaults.standard.set("test", forKey: "tabCustomization")
        // Remove it
        UserDefaults.standard.removeObject(forKey: "tabCustomization")
        // Verify it's gone
        let value = UserDefaults.standard.object(forKey: "tabCustomization")
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
