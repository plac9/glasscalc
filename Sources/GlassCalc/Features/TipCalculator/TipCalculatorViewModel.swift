import SwiftUI
import Observation

/// Tip Calculator state management
@Observable
@MainActor
public final class TipCalculatorViewModel {

    // MARK: - Input State

    public var billAmount: String = ""
    public var tipPercentage: Double = 18
    public var numberOfPeople: Int = 1

    // MARK: - Computed Results

    public var billValue: Double {
        Double(billAmount.replacingOccurrences(of: ",", with: "")) ?? 0
    }

    public var tipAmount: Double {
        billValue * (tipPercentage / 100)
    }

    public var totalAmount: Double {
        billValue + tipAmount
    }

    public var perPersonAmount: Double {
        guard numberOfPeople > 0 else { return totalAmount }
        return totalAmount / Double(numberOfPeople)
    }

    public var tipPerPerson: Double {
        guard numberOfPeople > 0 else { return tipAmount }
        return tipAmount / Double(numberOfPeople)
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
        guard billAmount.count < 10 else { return }

        if digit == "." {
            guard !billAmount.contains(".") else { return }
            if billAmount.isEmpty {
                billAmount = "0."
                return
            }
        }

        billAmount += digit
    }

    public func backspace() {
        guard !billAmount.isEmpty else { return }
        billAmount.removeLast()
    }

    public func clear() {
        billAmount = ""
        tipPercentage = 18
        numberOfPeople = 1
    }

    public func incrementPeople() {
        guard numberOfPeople < 99 else { return }
        numberOfPeople += 1
    }

    public func decrementPeople() {
        guard numberOfPeople > 1 else { return }
        numberOfPeople -= 1
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
