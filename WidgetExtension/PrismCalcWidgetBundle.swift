import SwiftUI
import WidgetKit

@main
struct PrismCalcWidgetBundle: WidgetBundle {
    var body: some Widget {
        // Home Screen widgets
        PrismCalcWidget()

        // Control Center widgets (iOS 18+)
        if #available(iOS 18.0, *) {
            PrismCalcControlWidget()
            TipCalculatorControlWidget()
            BillSplitControlWidget()
            UnitConverterControlWidget()
        }
    }
}
