import Foundation

/// Pure calculation engine - handles all math operations
///
/// Thread-safe and isolated from UI concerns.
/// Supports standard calculator operations with proper decimal handling.
public struct CalculatorEngine: Sendable {

    public enum Operation: String, Sendable {
        case add = "+"
        case subtract = "-"
        case multiply = "x"
        case divide = "/"
    }

    /// Perform binary operation
    public static func calculate(_ lhs: Double, _ operation: Operation, _ rhs: Double) -> Double {
        switch operation {
        case .add: return lhs + rhs
        case .subtract: return lhs - rhs
        case .multiply: return lhs * rhs
        case .divide: return rhs != 0 ? lhs / rhs : .nan
        }
    }

    /// Calculate percentage of a value
    public static func percentage(_ value: Double) -> Double {
        value / 100
    }

    /// Negate a value
    public static func negate(_ value: Double) -> Double {
        -value
    }

    /// Format number for display (handles large numbers, decimals)
    public static func formatDisplay(_ value: Double) -> String {
        if value.isNaN {
            return "Error"
        }

        if value.isInfinite {
            return "Error"
        }

        // Check if it's a whole number
        if value.truncatingRemainder(dividingBy: 1) == 0 && abs(value) < 1e15 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: value)) ?? "0"
        }

        // Decimal number
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        formatter.minimumFractionDigits = 0

        // Avoid scientific notation for reasonable numbers
        if abs(value) >= 1e-8 && abs(value) < 1e15 {
            return formatter.string(from: NSNumber(value: value)) ?? "0"
        }

        // Use scientific notation for very large/small numbers
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 4
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }

    /// Parse display string back to Double
    public static func parseDisplay(_ display: String) -> Double {
        let cleaned = display.replacingOccurrences(of: ",", with: "")
        return Double(cleaned) ?? 0
    }
}
