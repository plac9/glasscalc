import SwiftUI
import Observation

/// Calculator state management with @Observable
///
/// Manages:
/// - Current display value
/// - Pending operations
/// - Expression history
/// - Input state (fresh vs. continuing)
@Observable
@MainActor
public final class CalculatorViewModel {

    // MARK: - Published State

    public private(set) var display: String = "0"
    public private(set) var expression: String = ""

    // MARK: - Internal State

    private var currentValue: Double = 0
    private var pendingOperation: CalculatorEngine.Operation?
    private var pendingValue: Double = 0
    private var isNewInput: Bool = true
    private var hasDecimal: Bool = false

    // MARK: - Computed Properties

    public var displayValue: Double {
        CalculatorEngine.parseDisplay(display)
    }

    // MARK: - Init

    public init() {}

    // MARK: - Number Input

    public func inputDigit(_ digit: String) {
        if isNewInput {
            display = digit == "." ? "0." : digit
            isNewInput = false
            hasDecimal = digit == "."
        } else {
            // Limit display length
            guard display.replacingOccurrences(of: ",", with: "").count < 15 else { return }

            if digit == "." {
                guard !hasDecimal else { return }
                hasDecimal = true
            }

            display = display + digit
        }

        // Format with commas for whole numbers being typed
        if !hasDecimal {
            let value = CalculatorEngine.parseDisplay(display)
            display = CalculatorEngine.formatDisplay(value)
        }
    }

    // MARK: - Operations

    public func inputOperation(_ operation: CalculatorEngine.Operation) {
        // Complete pending operation first
        if pendingOperation != nil && !isNewInput {
            calculate()
        }

        pendingValue = displayValue
        pendingOperation = operation
        expression = "\(CalculatorEngine.formatDisplay(pendingValue)) \(operation.rawValue)"
        isNewInput = true
        hasDecimal = false
    }

    public func calculate() {
        guard let operation = pendingOperation else { return }

        let result = CalculatorEngine.calculate(pendingValue, operation, displayValue)
        let fullExpression = "\(CalculatorEngine.formatDisplay(pendingValue)) \(operation.rawValue) \(display)"
        expression = fullExpression
        display = CalculatorEngine.formatDisplay(result)
        currentValue = result

        // Save to history
        HistoryService.shared.saveCalculation(expression: fullExpression, result: display)

        // Record for TipKit
        TipKitConfiguration.recordCalculation()

        // Reset for next calculation
        pendingOperation = nil
        pendingValue = 0
        isNewInput = true
        hasDecimal = display.contains(".")
    }

    // MARK: - Special Operations

    public func clear() {
        display = "0"
        expression = ""
        currentValue = 0
        pendingOperation = nil
        pendingValue = 0
        isNewInput = true
        hasDecimal = false
    }

    public func toggleSign() {
        let value = CalculatorEngine.negate(displayValue)
        display = CalculatorEngine.formatDisplay(value)
    }

    public func percentage() {
        let value = CalculatorEngine.percentage(displayValue)
        display = CalculatorEngine.formatDisplay(value)
    }

    public func backspace() {
        guard !isNewInput else { return }

        if display.count > 1 {
            let removed = display.removeLast()
            if removed == "." {
                hasDecimal = false
            }
            // Handle comma formatting
            if !hasDecimal {
                let value = CalculatorEngine.parseDisplay(display)
                display = CalculatorEngine.formatDisplay(value)
            }
        } else {
            display = "0"
            isNewInput = true
        }
    }
}
