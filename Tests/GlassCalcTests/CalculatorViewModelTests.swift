import Testing
@testable import GlassCalc

/// Tests for the CalculatorViewModel
@Suite("Calculator ViewModel")
struct CalculatorViewModelTests {

    // MARK: - Initial State

    @Test("Initial display is zero")
    @MainActor
    func testInitialDisplay() {
        let viewModel = CalculatorViewModel()
        #expect(viewModel.display == "0")
        #expect(viewModel.expression == "")
    }

    // MARK: - Digit Input

    @Test("Input single digit")
    @MainActor
    func testInputSingleDigit() {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("5")
        #expect(viewModel.display == "5")
    }

    @Test("Input multiple digits")
    @MainActor
    func testInputMultipleDigits() {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("1")
        viewModel.inputDigit("2")
        viewModel.inputDigit("3")
        #expect(viewModel.display == "123")
    }

    @Test("Input with decimal")
    @MainActor
    func testInputDecimal() {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("3")
        viewModel.inputDigit(".")
        viewModel.inputDigit("1")
        viewModel.inputDigit("4")
        #expect(viewModel.display == "3.14")
    }

    @Test("Prevent multiple decimals")
    @MainActor
    func testPreventMultipleDecimals() {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("3")
        viewModel.inputDigit(".")
        viewModel.inputDigit("1")
        viewModel.inputDigit(".")
        viewModel.inputDigit("4")
        #expect(viewModel.display == "3.14")
    }

    @Test("Leading decimal becomes 0.")
    @MainActor
    func testLeadingDecimal() {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit(".")
        #expect(viewModel.display == "0.")
    }

    // MARK: - Operations

    @Test("Simple addition")
    @MainActor
    func testAddition() async {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("5")
        viewModel.inputOperation(.add)
        viewModel.inputDigit("3")
        viewModel.calculate()
        #expect(viewModel.display == "8")
    }

    @Test("Simple subtraction")
    @MainActor
    func testSubtraction() async {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("1")
        viewModel.inputDigit("0")
        viewModel.inputOperation(.subtract)
        viewModel.inputDigit("4")
        viewModel.calculate()
        #expect(viewModel.display == "6")
    }

    @Test("Simple multiplication")
    @MainActor
    func testMultiplication() async {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("6")
        viewModel.inputOperation(.multiply)
        viewModel.inputDigit("7")
        viewModel.calculate()
        #expect(viewModel.display == "42")
    }

    @Test("Simple division")
    @MainActor
    func testDivision() async {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("2")
        viewModel.inputDigit("0")
        viewModel.inputOperation(.divide)
        viewModel.inputDigit("4")
        viewModel.calculate()
        #expect(viewModel.display == "5")
    }

    @Test("Chain operations")
    @MainActor
    func testChainOperations() async {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("2")
        viewModel.inputOperation(.add)
        viewModel.inputDigit("3")
        viewModel.inputOperation(.multiply) // Should compute 2+3=5 first
        viewModel.inputDigit("4")
        viewModel.calculate()
        #expect(viewModel.display == "20") // 5 * 4 = 20
    }

    // MARK: - Special Operations

    @Test("Clear resets state")
    @MainActor
    func testClear() {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("1")
        viewModel.inputDigit("2")
        viewModel.inputDigit("3")
        viewModel.clear()
        #expect(viewModel.display == "0")
        #expect(viewModel.expression == "")
    }

    @Test("Toggle sign positive to negative")
    @MainActor
    func testToggleSignPositive() {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("5")
        viewModel.toggleSign()
        #expect(viewModel.display == "-5")
    }

    @Test("Toggle sign negative to positive")
    @MainActor
    func testToggleSignNegative() {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("5")
        viewModel.toggleSign()
        viewModel.toggleSign()
        #expect(viewModel.display == "5")
    }

    @Test("Percentage")
    @MainActor
    func testPercentage() {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("5")
        viewModel.inputDigit("0")
        viewModel.percentage()
        #expect(viewModel.display == "0.5")
    }

    @Test("Backspace removes last digit")
    @MainActor
    func testBackspace() {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("1")
        viewModel.inputDigit("2")
        viewModel.inputDigit("3")
        viewModel.backspace()
        #expect(viewModel.display == "12")
    }

    @Test("Backspace to single digit shows 0")
    @MainActor
    func testBackspaceToZero() {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("5")
        viewModel.backspace()
        #expect(viewModel.display == "0")
    }

    // MARK: - Display Formatting

    @Test("Large numbers have comma separators")
    @MainActor
    func testLargeNumberFormatting() {
        let viewModel = CalculatorViewModel()
        viewModel.inputDigit("1")
        viewModel.inputDigit("2")
        viewModel.inputDigit("3")
        viewModel.inputDigit("4")
        viewModel.inputDigit("5")
        viewModel.inputDigit("6")
        viewModel.inputDigit("7")
        #expect(viewModel.display == "1,234,567")
    }
}
