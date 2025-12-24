import SwiftUI

#if os(macOS)
/// PrismCalc macOS App Entry Point
@main
struct PrismCalcMacApp: App {
    var body: some Scene {
        PrismCalcApp.scene
    }
}
#endif
