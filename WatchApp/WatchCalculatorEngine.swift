import Foundation

struct WatchCalculatorEngine {
    enum Operation: String, CaseIterable {
        case add = "+"
        case subtract = "-"
        case multiply = "x"
        case divide = "/"
    }

    static func calculate(_ lhs: Double, _ operation: Operation, _ rhs: Double) -> Double {
        switch operation {
        case .add: return lhs + rhs
        case .subtract: return lhs - rhs
        case .multiply: return lhs * rhs
        case .divide: return rhs != 0 ? lhs / rhs : .nan
        }
    }

    static func formatDisplay(_ value: Double) -> String {
        if value.isNaN || value.isInfinite {
            return "Error"
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.minimumFractionDigits = 0
        formatter.usesGroupingSeparator = false

        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }

    static func parseDisplay(_ display: String) -> Double {
        Double(display) ?? 0
    }
}
