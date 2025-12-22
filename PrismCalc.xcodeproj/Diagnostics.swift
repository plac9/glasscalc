import Foundation
import OSLog

public enum Diagnostics {
    public static let subsystem = Bundle.main.bundleIdentifier ?? "PrismCalc"

    public static let storeKit = Logger(subsystem: subsystem, category: "StoreKit")
    public static let ui = Logger(subsystem: subsystem, category: "UI")
    public static let performance = Logger(subsystem: subsystem, category: "Performance")
}
