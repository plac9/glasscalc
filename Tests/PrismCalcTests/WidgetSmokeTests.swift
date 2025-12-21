import Testing
import SwiftUI
@testable import PrismCalc

@Suite("Widget smoke tests")
struct WidgetSmokeTests {

    @MainActor
    @Test("WidgetPreviewView constructs with sample entry")
    func testWidgetPreviewViewConstruction() async throws {
        let view = WidgetPreviewView(entry: .sample)
        _ = view.body
    }

    @MainActor
    @Test("WidgetPreviewEntry sample has expected values")
    func testWidgetPreviewEntrySample() async throws {
        let entry = WidgetPreviewEntry.sample
        #expect(entry.lastResult == "42")
        #expect(entry.lastExpression == "6 × 7")
        #expect(entry.recentHistory.count == 3)
    }

    @MainActor
    @Test("WidgetPreviewEntry creates with custom values")
    func testWidgetPreviewEntryCreation() async throws {
        let entry = WidgetPreviewEntry(
            date: Date(),
            lastResult: "100",
            lastExpression: "50 + 50",
            recentHistory: []
        )
        #expect(entry.lastResult == "100")
        #expect(entry.recentHistory.isEmpty)
    }

    @MainActor
    @Test("WidgetSettingsView compiles")
    func testWidgetSettingsView() async throws {
        let view = WidgetSettingsView()
        _ = view.body
    }
}
