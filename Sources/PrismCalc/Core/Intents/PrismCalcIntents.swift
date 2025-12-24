import AppIntents
import SwiftUI

// MARK: - Calculate Tip Intent

/// Siri: "Calculate 18% tip on $45"
struct CalculateTipIntent: AppIntent {
    static let title: LocalizedStringResource = "Calculate Tip"
    static let description = IntentDescription("Calculate the tip amount for a bill")

    @Parameter(title: "Bill Amount")
    var billAmount: Double

    @Parameter(title: "Tip Percentage", default: 18)
    var tipPercentage: Int

    static var parameterSummary: some ParameterSummary {
        Summary("Calculate \(\.$tipPercentage)% tip on $\(\.$billAmount)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        let tip = billAmount * Double(tipPercentage) / 100
        let total = billAmount + tip

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"

        let tipFormatted = formatter.string(from: NSNumber(value: tip)) ?? "$\(tip)"
        let totalFormatted = formatter.string(from: NSNumber(value: total)) ?? "$\(total)"

        let result = "Tip: \(tipFormatted), Total: \(totalFormatted)"

        return .result(
            value: result,
            dialog: "The tip is \(tipFormatted) and your total is \(totalFormatted)"
        )
    }
}

// MARK: - Split Bill Intent

/// Siri: "Split $120 between 4 people"
struct SplitBillIntent: AppIntent {
    static let title: LocalizedStringResource = "Split Bill"
    static let description = IntentDescription("Split a bill between multiple people")

    @Parameter(title: "Total Amount")
    var totalAmount: Double

    @Parameter(title: "Number of People", default: 2)
    var numberOfPeople: Int

    @Parameter(title: "Include Tip", default: true)
    var includeTip: Bool

    @Parameter(title: "Tip Percentage", default: 18)
    var tipPercentage: Int

    static var parameterSummary: some ParameterSummary {
        Summary("Split $\(\.$totalAmount) between \(\.$numberOfPeople) people")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        guard numberOfPeople > 0 else {
            throw SplitBillError.invalidPeopleCount
        }

        let tip = includeTip ? totalAmount * Double(tipPercentage) / 100 : 0
        let grandTotal = totalAmount + tip
        let perPerson = grandTotal / Double(numberOfPeople)

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"

        let perPersonFormatted = formatter.string(from: NSNumber(value: perPerson)) ?? "$\(perPerson)"

        let result = "\(perPersonFormatted) per person"

        return .result(
            value: result,
            dialog: "Each person pays \(perPersonFormatted)"
        )
    }

    enum SplitBillError: Swift.Error, CustomLocalizedStringResourceConvertible {
        case invalidPeopleCount

        var localizedStringResource: LocalizedStringResource {
            switch self {
            case .invalidPeopleCount:
                return "Number of people must be at least 1"
            }
        }
    }
}

// MARK: - Calculate Discount Intent

/// Siri: "What's 15% off $80"
struct CalculateDiscountIntent: AppIntent {
    static let title: LocalizedStringResource = "Calculate Discount"
    static let description = IntentDescription("Calculate the discounted price")

    @Parameter(title: "Original Price")
    var originalPrice: Double

    @Parameter(title: "Discount Percentage")
    var discountPercentage: Int

    static var parameterSummary: some ParameterSummary {
        Summary("Calculate \(\.$discountPercentage)% off $\(\.$originalPrice)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        let savings = originalPrice * Double(discountPercentage) / 100
        let finalPrice = originalPrice - savings

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"

        let savingsFormatted = formatter.string(from: NSNumber(value: savings)) ?? "$\(savings)"
        let finalFormatted = formatter.string(from: NSNumber(value: finalPrice)) ?? "$\(finalPrice)"

        let result = "Final: \(finalFormatted), Saved: \(savingsFormatted)"

        return .result(
            value: result,
            dialog: "You save \(savingsFormatted). The final price is \(finalFormatted)"
        )
    }
}

// MARK: - Convert Units Intent

/// Siri: "Convert 5 miles to kilometers"
struct ConvertUnitsIntent: AppIntent {
    static let title: LocalizedStringResource = "Convert Units"
    static let description = IntentDescription("Convert between measurement units")

    @Parameter(title: "Value")
    var value: Double

    @Parameter(title: "From Unit")
    var fromUnit: UnitType

    @Parameter(title: "To Unit")
    var toUnit: UnitType

    static var parameterSummary: some ParameterSummary {
        Summary("Convert \(\.$value) \(\.$fromUnit) to \(\.$toUnit)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        let result = convert(value, from: fromUnit, target: toUnit)

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 4

        let resultFormatted = formatter.string(from: NSNumber(value: result)) ?? "\(result)"
        let output = "\(resultFormatted) \(toUnit.rawValue)"

        return .result(
            value: output,
            dialog: "\(value) \(fromUnit.rawValue) is \(resultFormatted) \(toUnit.rawValue)"
        )
    }

    private func convert(_ value: Double, from: UnitType, target: UnitType) -> Double {
        // Handle same-unit case
        guard from != target else { return value }

        // Length conversions (via meters)
        let toMeters: [UnitType: Double] = [
            .meters: 1, .feet: 0.3048, .inches: 0.0254,
            .centimeters: 0.01, .kilometers: 1000, .miles: 1609.34, .yards: 0.9144
        ]

        if let fromFactor = toMeters[from], let toFactor = toMeters[target] {
            return (value * fromFactor) / toFactor
        }

        // Weight conversions (via kilograms)
        let toKilograms: [UnitType: Double] = [
            .kilograms: 1, .pounds: 0.453592, .ounces: 0.0283495,
            .grams: 0.001, .stones: 6.35029
        ]

        if let fromFactor = toKilograms[from], let toFactor = toKilograms[target] {
            return (value * fromFactor) / toFactor
        }

        // Temperature conversions
        let tempUnits: [UnitType] = [.celsius, .fahrenheit, .kelvin]
        if tempUnits.contains(from) && tempUnits.contains(target) {
            return convertTemperature(value, from: from, target: target)
        }

        return value
    }

    private func convertTemperature(_ value: Double, from: UnitType, target: UnitType) -> Double {
        // Convert to Celsius first
        var celsius: Double
        switch from {
        case .celsius: celsius = value
        case .fahrenheit: celsius = (value - 32) * 5 / 9
        case .kelvin: celsius = value - 273.15
        default: return value
        }

        // Convert from Celsius to target
        switch target {
        case .celsius: return celsius
        case .fahrenheit: return celsius * 9 / 5 + 32
        case .kelvin: return celsius + 273.15
        default: return value
        }
    }

    enum UnitType: String, AppEnum {
        // Length
        case meters, feet, inches, centimeters, kilometers, miles, yards
        // Weight
        case kilograms, pounds, ounces, grams, stones
        // Temperature
        case celsius, fahrenheit, kelvin

        static let typeDisplayRepresentation: TypeDisplayRepresentation = "Unit"

        static let caseDisplayRepresentations: [UnitType: DisplayRepresentation] = [
            // Length
            .meters: "meters",
            .feet: "feet",
            .inches: "inches",
            .centimeters: "centimeters",
            .kilometers: "kilometers",
            .miles: "miles",
            .yards: "yards",
            // Weight
            .kilograms: "kilograms",
            .pounds: "pounds",
            .ounces: "ounces",
            .grams: "grams",
            .stones: "stones",
            // Temperature
            .celsius: "celsius",
            .fahrenheit: "fahrenheit",
            .kelvin: "kelvin"
        ]
    }
}

// MARK: - Open Calculator Intent

/// Siri: "Open prismCalc"
struct OpenCalculatorIntent: AppIntent {
    static let title: LocalizedStringResource = "Open prismCalc"
    static let description = IntentDescription("Open the prismCalc calculator app")

    static let openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

// MARK: - App Shortcuts Provider

struct PrismCalcShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        // Note: App Shortcuts only support one parameter per phrase,
        // and only AppEntity/AppEnum types. For simple value types,
        // use parameter-free phrases and let Siri prompt for values.
        AppShortcut(
            intent: CalculateTipIntent(),
            phrases: [
                "Calculate tip with \(.applicationName)",
                "What's the tip with \(.applicationName)",
                "Tip calculator with \(.applicationName)"
            ],
            shortTitle: "Calculate Tip",
            systemImageName: "dollarsign.circle"
        )

        AppShortcut(
            intent: SplitBillIntent(),
            phrases: [
                "Split bill with \(.applicationName)",
                "Split the check with \(.applicationName)",
                "Divide bill with \(.applicationName)"
            ],
            shortTitle: "Split Bill",
            systemImageName: "person.2"
        )

        AppShortcut(
            intent: CalculateDiscountIntent(),
            phrases: [
                "Calculate discount with \(.applicationName)",
                "What's the sale price with \(.applicationName)",
                "Discount calculator with \(.applicationName)"
            ],
            shortTitle: "Calculate Discount",
            systemImageName: "tag"
        )

        AppShortcut(
            intent: ConvertUnitsIntent(),
            phrases: [
                "Convert units with \(.applicationName)",
                "Convert \(\.$fromUnit) with \(.applicationName)",
                "Unit converter with \(.applicationName)"
            ],
            shortTitle: "Convert Units",
            systemImageName: "arrow.left.arrow.right"
        )

        AppShortcut(
            intent: OpenCalculatorIntent(),
            phrases: [
                "Open \(.applicationName)",
                "Launch \(.applicationName)"
            ],
            shortTitle: "Open Calculator",
            systemImageName: "equal.square.fill"
        )
    }
}
