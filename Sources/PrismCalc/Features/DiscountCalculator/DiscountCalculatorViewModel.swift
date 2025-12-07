import SwiftUI
import Observation

/// Discount Calculator state management
@Observable
@MainActor
public final class DiscountCalculatorViewModel {

    // MARK: - Input State

    private var _originalPrice: String = ""
    public var originalPrice: String {
        get { _originalPrice }
        set {
            // Filter to only valid characters
            let filtered = newValue.filter { $0.isNumber || $0 == "." }
            // Limit to 10 characters
            let limited = String(filtered.prefix(10))
            // Prevent multiple decimals
            let parts = limited.split(separator: ".", omittingEmptySubsequences: false)
            if parts.count > 2 {
                _originalPrice = String(parts[0]) + "." + String(parts[1])
            } else {
                _originalPrice = limited
            }
        }
    }

    private var _discountPercentage: Double = 20
    public var discountPercentage: Double {
        get { _discountPercentage }
        set {
            // Clamp to valid percentage range 0-100
            _discountPercentage = min(100, max(0, newValue))
        }
    }

    // MARK: - Computed Results

    public var priceValue: Double {
        let value = Double(originalPrice.replacingOccurrences(of: ",", with: "")) ?? 0
        // Guard against overflow
        return value.isFinite ? value : 0
    }

    public var discountAmount: Double {
        let amount = priceValue * (discountPercentage / 100)
        return amount.isFinite ? amount : 0
    }

    public var finalPrice: Double {
        let final = priceValue - discountAmount
        return final.isFinite ? final : 0
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
        guard _originalPrice.count < 10 else { return }

        if digit == "." {
            guard !_originalPrice.contains(".") else { return }
            if _originalPrice.isEmpty {
                _originalPrice = "0."
                return
            }
        }

        _originalPrice += digit
    }

    public func backspace() {
        guard !originalPrice.isEmpty else { return }
        originalPrice.removeLast()
    }

    public func clear() {
        _originalPrice = ""
        _discountPercentage = 20
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
