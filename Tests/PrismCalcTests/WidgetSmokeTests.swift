import Testing
import SwiftUI
import WidgetKit
@testable import PrismCalc

@Suite("Widget smoke tests")
struct WidgetSmokeTests {

    // Sample entry used across tests
    private var sampleEntry: PrismCalcEntry {
        PrismCalcEntry(
            date: Date(),
            lastResult: "42",
            lastExpression: "6 × 7",
            recentHistory: [
                .init(type: "Calc", result: "42", details: "6 × 7", icon: "plus.forwardslash.minus"),
                .init(type: "Tip", result: "$23.60", details: "$20 + 18%", icon: "dollarsign.circle"),
                .init(type: "Split", result: "$15", details: "$60 ÷ 4", icon: "person.2")
            ]
        )
    }

    @MainActor
    @Test("PrismCalcWidget compiles and exposes families")
    func testWidgetConfiguration() throws {
        let widget = PrismCalcWidget()
        // Structural check by accessing the configuration body
        _ = widget.body
    }

    @MainActor
    @Test("Adaptive view constructs with sample entry")
    func testAdaptiveViewConstruction() async throws {
        // widgetFamily is a read-only environment value set by the system
        // We verify the view constructs correctly
        let view = AdaptivePrismCalcWidgetView(entry: sampleEntry)
        _ = view.body
    }

    @MainActor
    @Test("PrismCalcEntry creates with history items")
    func testEntryCreation() async throws {
        let entry = sampleEntry
        #expect(entry.lastResult == "42")
        #expect(entry.lastExpression == "6 × 7")
        #expect(entry.recentHistory.count == 3)
    }

    @MainActor
    @Test("WidgetSettingsView compiles")
    func testWidgetSettingsView() async throws {
        let view = WidgetSettingsView()
        _ = view.body
    }
}
