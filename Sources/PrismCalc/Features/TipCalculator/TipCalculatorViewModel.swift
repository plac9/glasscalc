import SwiftUI
import Observation

/// Tip Calculator state management
@Observable
@MainActor
public final class TipCalculatorViewModel {

    // MARK: - Input State

    private var _billAmount: String = ""
    public var billAmount: String {
        get { _billAmount }
        set {
            // Filter to only valid characters
            let filtered = newValue.filter { $0.isNumber || $0 == "." }
            // Limit to 10 characters
            let limited = String(filtered.prefix(10))
            // Prevent multiple decimals
            let parts = limited.split(separator: ".", omittingEmptySubsequences: false)
            if parts.count > 2 {
                _billAmount = String(parts[0]) + "." + String(parts[1])
            } else {
                _billAmount = limited
            }
        }
    }

    private var _tipPercentage: Double = 18
    public var tipPercentage: Double {
        get { _tipPercentage }
        set {
            // Clamp to valid percentage range 0-100
            _tipPercentage = min(100, max(0, newValue))
        }
    }

    private var _numberOfPeople: Int = 1
    public var numberOfPeople: Int {
        get { _numberOfPeople }
        set {
            // Clamp to valid range 1-99
            _numberOfPeople = min(99, max(1, newValue))
        }
    }

    // MARK: - Computed Results

    public var billValue: Double {
        let value = Double(billAmount.replacingOccurrences(of: ",", with: "")) ?? 0
        // Guard against overflow
        return value.isFinite ? value : 0
    }

    public var tipAmount: Double {
        let amount = billValue * (tipPercentage / 100)
        return amount.isFinite ? amount : 0
    }

    public var totalAmount: Double {
        let total = billValue + tipAmount
        return total.isFinite ? total : 0
    }

    public var perPersonAmount: Double {
        guard numberOfPeople > 0 else { return totalAmount }
        let share = totalAmount / Double(numberOfPeople)
        return share.isFinite ? share : 0
    }

    public var tipPerPerson: Double {
        guard numberOfPeople > 0 else { return tipAmount }
        let share = tipAmount / Double(numberOfPeople)
        return share.isFinite ? share : 0
    }

    // MARK: - Formatted Output

    public var formattedTip: String {
        formatCurrency(tipAmount)
    }

    public var formattedTotal: String {
        formatCurrency(totalAmount)
    }

    public var formattedPerPerson: String {
        formatCurrency(perPersonAmount)
    }

    public var formattedTipPerPerson: String {
        formatCurrency(tipPerPerson)
    }

    // MARK: - Quick Tip Presets

    public let quickTips: [Double] = [15, 18, 20, 25]

    // MARK: - Init

    public init() {}

    // MARK: - Actions

    public func inputDigit(_ digit: String) {
        // Limit to reasonable bill amount (10 digits)
        guard _billAmount.count < 10 else { return }

        if digit == "." {
            guard !_billAmount.contains(".") else { return }
            if _billAmount.isEmpty {
                _billAmount = "0."
                return
            }
        }

        _billAmount += digit
    }

    public func backspace() {
        guard !_billAmount.isEmpty else { return }
        _billAmount.removeLast()
    }

    public func clear() {
        _billAmount = ""
        _tipPercentage = 18
        _numberOfPeople = 1
    }

    public func incrementPeople() {
        guard _numberOfPeople < 99 else { return }
        _numberOfPeople += 1
    }

    public func decrementPeople() {
        guard _numberOfPeople > 1 else { return }
        _numberOfPeople -= 1
    }

    public func selectQuickTip(_ tip: Double) {
        tipPercentage = tip
    }

    public func saveToHistory() {
        guard billValue > 0 else { return }
        HistoryService.shared.saveTip(
            bill: formatCurrency(billValue),
            tipPercent: Int(tipPercentage),
            total: formattedTotal,
            perPerson: numberOfPeople > 1 ? formattedPerPerson : nil,
            people: numberOfPeople
        )
    }

    // MARK: - Formatting

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}
