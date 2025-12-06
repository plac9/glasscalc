import SwiftUI
import Observation

/// Unit Converter state management
@Observable
@MainActor
public final class UnitConverterViewModel {

    // MARK: - Categories

    public enum Category: String, CaseIterable, Identifiable {
        case length = "Length"
        case weight = "Weight"
        case temperature = "Temperature"
        case currency = "Currency"

        public var id: String { rawValue }

        public var icon: String {
            switch self {
            case .length: return "ruler"
            case .weight: return "scalemass"
            case .temperature: return "thermometer.medium"
            case .currency: return "dollarsign.circle"
            }
        }
    }

    // MARK: - State

    public var selectedCategory: Category = .length
    public var inputValue: String = ""
    public var fromUnit: String = ""
    public var toUnit: String = ""

    // Currency-specific
    public var currencies: [Currency] = []
    public var isLoadingCurrencies: Bool = false
    public var currencyError: String?

    // MARK: - Units by Category

    public var availableUnits: [String] {
        switch selectedCategory {
        case .length:
            return ["meters", "feet", "inches", "centimeters", "kilometers", "miles", "yards"]
        case .weight:
            return ["kilograms", "pounds", "ounces", "grams", "stones"]
        case .temperature:
            return ["celsius", "fahrenheit", "kelvin"]
        case .currency:
            return currencies.map { $0.code }
        }
    }

    // MARK: - Computed

    public var inputDouble: Double {
        Double(inputValue) ?? 0
    }

    public var convertedValue: Double {
        convert(inputDouble, from: fromUnit, to: toUnit)
    }

    public var formattedResult: String {
        if selectedCategory == .currency {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = toUnit
            formatter.maximumFractionDigits = 2
            return formatter.string(from: NSNumber(value: convertedValue)) ?? "0.00"
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 4
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: convertedValue)) ?? "0"
    }

    // MARK: - Init

    public init() {
        setDefaultUnits()
    }

    // MARK: - Actions

    public func selectCategory(_ category: Category) {
        selectedCategory = category
        setDefaultUnits()

        if category == .currency && currencies.isEmpty {
            Task { await loadCurrencies() }
        }
    }

    public func swapUnits() {
        let temp = fromUnit
        fromUnit = toUnit
        toUnit = temp
    }

    public func loadCurrencies() async {
        isLoadingCurrencies = true
        currencyError = nil

        do {
            currencies = try await CurrencyService.shared.availableCurrencies()
            if fromUnit.isEmpty { fromUnit = "USD" }
            if toUnit.isEmpty { toUnit = "EUR" }
        } catch {
            currencyError = error.localizedDescription
        }

        isLoadingCurrencies = false
    }

    // MARK: - Private

    private func setDefaultUnits() {
        switch selectedCategory {
        case .length:
            fromUnit = "meters"
            toUnit = "feet"
        case .weight:
            fromUnit = "kilograms"
            toUnit = "pounds"
        case .temperature:
            fromUnit = "celsius"
            toUnit = "fahrenheit"
        case .currency:
            fromUnit = "USD"
            toUnit = "EUR"
        }
    }

    private func convert(_ value: Double, from: String, to: String) -> Double {
        guard from != to else { return value }

        switch selectedCategory {
        case .length:
            return convertLength(value, from: from, to: to)
        case .weight:
            return convertWeight(value, from: from, to: to)
        case .temperature:
            return convertTemperature(value, from: from, to: to)
        case .currency:
            // Currency conversion happens async, return placeholder
            return value
        }
    }

    // MARK: - Conversion Functions

    private func convertLength(_ value: Double, from: String, to: String) -> Double {
        // Convert to meters first, then to target
        let toMeters: [String: Double] = [
            "meters": 1,
            "feet": 0.3048,
            "inches": 0.0254,
            "centimeters": 0.01,
            "kilometers": 1000,
            "miles": 1609.34,
            "yards": 0.9144
        ]

        guard let fromFactor = toMeters[from],
              let toFactor = toMeters[to] else { return value }

        let meters = value * fromFactor
        return meters / toFactor
    }

    private func convertWeight(_ value: Double, from: String, to: String) -> Double {
        // Convert to kilograms first
        let toKg: [String: Double] = [
            "kilograms": 1,
            "pounds": 0.453592,
            "ounces": 0.0283495,
            "grams": 0.001,
            "stones": 6.35029
        ]

        guard let fromFactor = toKg[from],
              let toFactor = toKg[to] else { return value }

        let kg = value * fromFactor
        return kg / toFactor
    }

    private func convertTemperature(_ value: Double, from: String, to: String) -> Double {
        // Convert to Celsius first
        var celsius: Double

        switch from {
        case "celsius":
            celsius = value
        case "fahrenheit":
            celsius = (value - 32) * 5 / 9
        case "kelvin":
            celsius = value - 273.15
        default:
            return value
        }

        // Convert from Celsius to target
        switch to {
        case "celsius":
            return celsius
        case "fahrenheit":
            return celsius * 9 / 5 + 32
        case "kelvin":
            return celsius + 273.15
        default:
            return value
        }
    }
}
