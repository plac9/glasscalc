import Testing
import SwiftUI
import WidgetKit
@testable import PrismCalc

@Suite("UI smoke tests")
struct UISmokeTests {

    @MainActor
    @Test("ContentView compiles and provides body")
    func testContentView() async throws {
        let view = ContentView()
        _ = view.body
    }

    @MainActor
    @Test("UnitConverterView compiles and provides body")
    func testUnitConverterView() async throws {
        let view = UnitConverterView()
        _ = view.body
    }

    @MainActor
    @Test("DiscountCalculatorView compiles and provides body")
    func testDiscountCalculatorView() async throws {
        let view = DiscountCalculatorView()
        _ = view.body
    }

    @MainActor
    @Test("HistoryView compiles and provides body")
    func testHistoryView() async throws {
        let view = HistoryView()
        _ = view.body
    }

    @MainActor
    @Test("SettingsView compiles and provides body")
    func testSettingsView() async throws {
        let view = SettingsView()
        _ = view.body
    }

    @MainActor
    @Test("WidgetSettingsView compiles and provides body")
    func testWidgetSettingsView() async throws {
        let view = WidgetSettingsView()
        _ = view.body
    }

    // Control Center widgets (iOS 18+ only)
    #if os(iOS)
    @available(iOS 18.0, *)
    @Test("Control Center widgets types compile")
    func testControlCenterWidgets() throws {
        // Ensure types exist and can be constructed
        _ = PrismCalcControlWidget.kind
        _ = TipCalculatorControlWidget.kind
        _ = BillSplitControlWidget.kind
        _ = UnitConverterControlWidget.kind
        _ = DiscountControlWidget.kind
    }
    #endif
}
