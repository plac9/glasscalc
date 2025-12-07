import SwiftUI
import Observation

/// Discount Calculator state management
@Observable
@MainActor
public final class DiscountCalculatorViewModel {

    // MARK: - Input State

    public var originalPrice: String = ""
    public var discountPercentage: Double = 20

    // MARK: - Computed Results

    public var priceValue: Double {
        Double(originalPrice.replacingOccurrences(of: ",", with: "")) ?? 0
    }

    public var discountAmount: Double {
        priceValue * (discountPercentage / 100)
    }

    public var finalPrice: Double {
        priceValue - discountAmount
    }

    // MARK: - Formatted Output

    public var formattedOriginal: String {
        formatCurrency(priceValue)
    }

    public var formattedDiscount: String {
        formatCurrency(discountAmount)
    }

    public var formattedFinal: String {
        formatCurrency(finalPrice)
    }

    // MARK: - Quick Discount Presets

    public let quickDiscounts: [Double] = [10, 20, 25, 50]

    // MARK: - Init

    public init() {}

    // MARK: - Actions

    public func inputDigit(_ digit: String) {
        guard originalPrice.count < 10 else { return }

        if digit == "." {
            guard !originalPrice.contains(".") else { return }
            if originalPrice.isEmpty {
                originalPrice = "0."
                return
            }
        }

        originalPrice += digit
    }

    public func backspace() {
        guard !originalPrice.isEmpty else { return }
        originalPrice.removeLast()
    }

    public func clear() {
        originalPrice = ""
        discountPercentage = 20
    }

    public func selectQuickDiscount(_ discount: Double) {
        discountPercentage = discount
    }

    public func saveToHistory() {
        guard priceValue > 0 else { return }
        HistoryService.shared.saveDiscount(
            original: formattedOriginal,
            discountPercent: Int(discountPercentage),
            final: formattedFinal,
            saved: formattedDiscount
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
