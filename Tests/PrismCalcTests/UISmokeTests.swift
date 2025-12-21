import Testing
import SwiftUI
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
}
