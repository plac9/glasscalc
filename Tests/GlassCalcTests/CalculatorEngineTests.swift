import Testing
@testable import GlassCalc

/// Tests for the calculator engine
@Suite("Calculator Engine")
struct CalculatorEngineTests {

    // MARK: - Basic Operations

    @Test("Addition")
    func testAddition() {
        let result = CalculatorEngine.calculate(5, .add, 3)
        #expect(result == 8)
    }

    @Test("Subtraction")
    func testSubtraction() {
        let result = CalculatorEngine.calculate(10, .subtract, 4)
        #expect(result == 6)
    }

    @Test("Multiplication")
    func testMultiplication() {
        let result = CalculatorEngine.calculate(7, .multiply, 6)
        #expect(result == 42)
    }

    @Test("Division")
    func testDivision() {
        let result = CalculatorEngine.calculate(20, .divide, 4)
        #expect(result == 5)
    }

    @Test("Division by zero returns NaN")
    func testDivisionByZero() {
        let result = CalculatorEngine.calculate(10, .divide, 0)
        #expect(result.isNaN)
    }

    // MARK: - Special Operations

    @Test("Percentage")
    func testPercentage() {
        let result = CalculatorEngine.percentage(50)
        #expect(result == 0.5)
    }

    @Test("Negate positive")
    func testNegatePositive() {
        let result = CalculatorEngine.negate(5)
        #expect(result == -5)
    }

    @Test("Negate negative")
    func testNegateNegative() {
        let result = CalculatorEngine.negate(-5)
        #expect(result == 5)
    }

    // MARK: - Display Formatting

    @Test("Format whole number")
    func testFormatWholeNumber() {
        let result = CalculatorEngine.formatDisplay(1234567)
        #expect(result == "1,234,567")
    }

    @Test("Format decimal")
    func testFormatDecimal() {
        let result = CalculatorEngine.formatDisplay(123.456)
        #expect(result == "123.456")
    }

    @Test("Format error for NaN")
    func testFormatNaN() {
        let result = CalculatorEngine.formatDisplay(.nan)
        #expect(result == "Error")
    }

    @Test("Format error for infinity")
    func testFormatInfinity() {
        let result = CalculatorEngine.formatDisplay(.infinity)
        #expect(result == "Error")
    }

    // MARK: - Parse Display

    @Test("Parse display with commas")
    func testParseDisplayWithCommas() {
        let result = CalculatorEngine.parseDisplay("1,234,567")
        #expect(result == 1234567)
    }

    @Test("Parse display decimal")
    func testParseDisplayDecimal() {
        let result = CalculatorEngine.parseDisplay("123.45")
        #expect(result == 123.45)
    }
}
