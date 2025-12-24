import SwiftUI

#if os(iOS)
/// PrismCalc iOS App Entry Point
@main
struct PrismCalcMainApp: App {
    var body: some Scene {
        PrismCalcApp.scene
    }
}
#endif
