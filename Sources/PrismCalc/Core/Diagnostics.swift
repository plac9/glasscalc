import OSLog

/// Centralized loggers for PrismCalc diagnostics.
public enum Diagnostics {
    private static let subsystem = "com.laclairtech.prismcalc"

    public static let storeKit = Logger(subsystem: subsystem, category: "StoreKit")
}
