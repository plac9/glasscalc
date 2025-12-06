import SwiftUI
import Observation

/// Split Bill state management - divide bills among friends
@Observable
@MainActor
public final class SplitBillViewModel {

    // MARK: - Input State

    public var totalBill: String = ""
    public var numberOfPeople: Int = 2
    public var includeTip: Bool = true
    public var tipPercentage: Double = 18

    // MARK: - Computed Results

    public var billValue: Double {
        Double(totalBill.replacingOccurrences(of: ",", with: "")) ?? 0
    }

    public var tipAmount: Double {
        includeTip ? billValue * (tipPercentage / 100) : 0
    }

    public var grandTotal: Double {
        billValue + tipAmount
    }

    public var perPersonShare: Double {
        guard numberOfPeople > 0 else { return grandTotal }
        return grandTotal / Double(numberOfPeople)
    }

    public var tipPerPerson: Double {
        guard numberOfPeople > 0 else { return tipAmount }
        return tipAmount / Double(numberOfPeople)
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
        guard totalBill.count < 10 else { return }

        if digit == "." {
            guard !totalBill.contains(".") else { return }
            if totalBill.isEmpty {
                totalBill = "0."
                return
            }
        }

        totalBill += digit
    }

    public func backspace() {
        guard !totalBill.isEmpty else { return }
        totalBill.removeLast()
    }

    public func clear() {
        totalBill = ""
        numberOfPeople = 2
        includeTip = true
        tipPercentage = 18
    }

    public func incrementPeople() {
        guard numberOfPeople < 99 else { return }
        numberOfPeople += 1
    }

    public func decrementPeople() {
        guard numberOfPeople > 1 else { return }
        numberOfPeople -= 1
    }

    public func toggleTip() {
        includeTip.toggle()
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
