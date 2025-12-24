import SwiftUI
import WidgetKit

#if os(watchOS)
@main
struct PrismCalcWidgetBundleWatch: WidgetBundle {
    var body: some Widget {
        PrismCalcWatchWidget()
    }
}
#endif
