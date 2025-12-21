import Testing
import SwiftUI
@testable import PrismCalc

@Suite("Feature smoke tests")
struct FeatureSmokeTests {

    @MainActor
    @Test("CalculatorView compiles and provides body")
    func testCalculatorView() async throws {
        let view = CalculatorView()
        _ = view.body
    }

    @MainActor
    @Test("TipCalculatorView compiles and provides body")
    func testTipCalculatorView() async throws {
        let view = TipCalculatorView()
        _ = view.body
    }

    @MainActor
    @Test("SplitBillView compiles and provides body")
    func testSplitBillView() async throws {
        let view = SplitBillView()
        _ = view.body
    }

    // Platform guard sanity check for Control Center widgets
    #if os(iOS)
    @Test("Control Center widget availability is guarded")
    func testControlCenterAvailabilityGuards() throws {
        // This test simply ensures the types are conditionally available.
        // Accessing the static kind should compile for iOS when available.
        if #available(iOS 18.0, *) {
            _ = PrismCalcControlWidget.kind
            _ = TipCalculatorControlWidget.kind
            _ = BillSplitControlWidget.kind
            _ = UnitConverterControlWidget.kind
            _ = DiscountControlWidget.kind
        } else {
            // On earlier OS versions, just assert true to keep the test green.
            #expect(true)
        }
    }
    #endif
}
