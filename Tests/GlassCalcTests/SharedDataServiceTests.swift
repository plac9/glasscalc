import Testing
import Foundation
@testable import GlassCalc

/// Tests for SharedDataService (app-widget communication)
@Suite("Shared Data Service")
struct SharedDataServiceTests {

    // Note: These tests use the shared UserDefaults for the app group
    // In a real test environment, you might want to use dependency injection

    // MARK: - Last Calculation

    @Test("Save and retrieve last result")
    func testSaveLastResult() {
        let service = SharedDataService.shared
        service.saveLastCalculation(result: "42", expression: "6 × 7")

        #expect(service.getLastResult() == "42")
        #expect(service.getLastExpression() == "6 × 7")
    }

    @Test("Default last result is 0")
    func testDefaultLastResult() {
        // Clear and test default
        let service = SharedDataService.shared
        service.clearHistory()

        #expect(service.getLastResult() == "0")
        #expect(service.getLastExpression() == "")
    }

    // MARK: - Recent History

    @Test("Save and retrieve history items")
    func testSaveHistory() {
        let service = SharedDataService.shared
        let items = [
            WidgetHistoryItem(type: "Calc", result: "42", details: "6 × 7", icon: "plus.forwardslash.minus"),
            WidgetHistoryItem(type: "Tip", result: "$23.60", details: "$20 + 18%", icon: "dollarsign.circle")
        ]

        service.saveRecentHistory(items)
        let retrieved = service.getRecentHistory()

        #expect(retrieved.count == 2)
        #expect(retrieved[0].result == "42")
        #expect(retrieved[1].type == "Tip")
    }

    @Test("Empty history returns empty array")
    func testEmptyHistory() {
        let service = SharedDataService.shared
        service.clearHistory()

        let history = service.getRecentHistory()
        #expect(history.isEmpty)
    }

    // MARK: - Clear History

    @Test("Clear history removes all data")
    func testClearHistory() {
        let service = SharedDataService.shared

        // Add some data
        service.saveLastCalculation(result: "100", expression: "50 + 50")
        service.saveRecentHistory([
            WidgetHistoryItem(type: "Calc", result: "100", details: "50 + 50", icon: "plus")
        ])

        // Clear
        service.clearHistory()

        // Verify cleared
        #expect(service.getLastResult() == "0")
        #expect(service.getLastExpression() == "")
        #expect(service.getRecentHistory().isEmpty)
    }
}

/// Tests for WidgetHistoryItem
@Suite("Widget History Item")
struct WidgetHistoryItemTests {

    @Test("Create history item with all properties")
    func testCreateHistoryItem() {
        let item = WidgetHistoryItem(
            type: "Calculator",
            result: "42",
            details: "6 × 7",
            icon: "plus.forwardslash.minus"
        )

        #expect(item.type == "Calculator")
        #expect(item.result == "42")
        #expect(item.details == "6 × 7")
        #expect(item.icon == "plus.forwardslash.minus")
    }

    @Test("History item has unique ID")
    func testHistoryItemUniqueId() {
        let item1 = WidgetHistoryItem(type: "A", result: "1", details: "d", icon: "i")
        let item2 = WidgetHistoryItem(type: "A", result: "1", details: "d", icon: "i")

        #expect(item1.id != item2.id)
    }

    @Test("History item is Codable")
    func testHistoryItemCodable() throws {
        let item = WidgetHistoryItem(
            type: "Tip",
            result: "$23.60",
            details: "$20 + 18%",
            icon: "dollarsign.circle"
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(item)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(WidgetHistoryItem.self, from: data)

        #expect(decoded.type == item.type)
        #expect(decoded.result == item.result)
        #expect(decoded.details == item.details)
        #expect(decoded.icon == item.icon)
    }
}
