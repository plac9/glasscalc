import SwiftUI
import WidgetKit

#if os(macOS)
@main
struct PrismCalcWidgetBundleMac: WidgetBundle {
    var body: some Widget {
        PrismCalcWidget()
    }
}
#endif
