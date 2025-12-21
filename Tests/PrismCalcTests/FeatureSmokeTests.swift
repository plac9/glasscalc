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
}
