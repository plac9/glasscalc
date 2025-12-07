import SwiftUI
import WidgetKit

@main
struct GlassCalcWidgetBundle: WidgetBundle {
    var body: some Widget {
        // Home Screen widgets
        GlassCalcWidget()

        // Control Center widgets (iOS 18+)
        if #available(iOS 18.0, *) {
            GlassCalcControlWidget()
            TipCalculatorControlWidget()
            BillSplitControlWidget()
            UnitConverterControlWidget()
        }
    }
}
