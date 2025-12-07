import SwiftUI
import Observation

/// Split Bill state management - divide bills among friends
@Observable
@MainActor
public final class SplitBillViewModel {

    // MARK: - Input State

    private var _totalBill: String = ""
    public var totalBill: String {
        get { _totalBill }
        set {
            // Filter to only valid characters
            let filtered = newValue.filter { $0.isNumber || $0 == "." }
            // Limit to 10 characters
            let limited = String(filtered.prefix(10))
            // Prevent multiple decimals
            let parts = limited.split(separator: ".", omittingEmptySubsequences: false)
            if parts.count > 2 {
                _totalBill = String(parts[0]) + "." + String(parts[1])
            } else {
                _totalBill = limited
            }
        }
    }

    private var _numberOfPeople: Int = 2
    public var numberOfPeople: Int {
        get { _numberOfPeople }
        set {
            // Clamp to valid range 1-99
            _numberOfPeople = min(99, max(1, newValue))
        }
    }

    public var includeTip: Bool = true

    private var _tipPercentage: Double = 18
    public var tipPercentage: Double {
        get { _tipPercentage }
        set {
            // Clamp to valid percentage range 0-100
            _tipPercentage = min(100, max(0, newValue))
        }
    }

    // MARK: - Computed Results

    public var billValue: Double {
        let value = Double(totalBill.replacingOccurrences(of: ",", with: "")) ?? 0
        // Guard against overflow
        return value.isFinite ? value : 0
    }

    public var tipAmount: Double {
        let amount = includeTip ? billValue * (tipPercentage / 100) : 0
        return amount.isFinite ? amount : 0
    }

    public var grandTotal: Double {
        let total = billValue + tipAmount
        return total.isFinite ? total : 0
    }

    public var perPersonShare: Double {
        guard numberOfPeople > 0 else { return grandTotal }
        let share = grandTotal / Double(numberOfPeople)
        return share.isFinite ? share : 0
    }

    public var tipPerPerson: Double {
        guard numberOfPeople > 0 else { return tipAmount }
        let share = tipAmount / Double(numberOfPeople)
        return share.isFinite ? share : 0
    }

    // MARK: - Formatted Output

    public var formattedBill: String {
        formatCurrency(billValue)
    }

    public var formattedTip: String {
        formatCurrency(tipAmount)
    }

    public var formattedGrandTotal: String {
        formatCurrency(grandTotal)
    }

    public var formattedPerPerson: String {
        formatCurrency(perPersonShare)
    }

    // MARK: - Init

    public init() {}

    // MARK: - Actions

    public func inputDigit(_ digit: String) {
        guard _totalBill.count < 10 else { return }

        if digit == "." {
            guard !_totalBill.contains(".") else { return }
            if _totalBill.isEmpty {
                _totalBill = "0."
                return
            }
        }

        _totalBill += digit
    }

    public func backspace() {
        guard !_totalBill.isEmpty else { return }
        _totalBill.removeLast()
    }

    public func clear() {
        _totalBill = ""
        _numberOfPeople = 2
        includeTip = true
        _tipPercentage = 18
    }

    public func incrementPeople() {
        guard _numberOfPeople < 99 else { return }
        _numberOfPeople += 1
    }

    public func decrementPeople() {
        guard _numberOfPeople > 1 else { return }
        _numberOfPeople -= 1
    }

    public func toggleTip() {
        includeTip.toggle()
    }

    public func saveToHistory() {
        guard billValue > 0 else { return }
        HistoryService.shared.saveSplit(
            total: formattedGrandTotal,
            people: numberOfPeople,
            perPerson: formattedPerPerson
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
