import Testing
@testable import PrismCalc

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

    @Test("Parse display invalid returns zero")
    func testParseDisplayInvalid() {
        let result = CalculatorEngine.parseDisplay("abc")
        #expect(result == 0)
    }

    // MARK: - Edge Cases

    @Test("Zero handling")
    func testZeroHandling() {
        #expect(CalculatorEngine.calculate(0, .add, 5) == 5)
        #expect(CalculatorEngine.calculate(5, .subtract, 5) == 0)
        #expect(CalculatorEngine.calculate(0, .multiply, 100) == 0)
        #expect(CalculatorEngine.negate(0) == 0)
    }

    @Test("Negative numbers")
    func testNegativeNumbers() {
        #expect(CalculatorEngine.calculate(-5, .add, 3) == -2)
        #expect(CalculatorEngine.calculate(-5, .multiply, -3) == 15)
        #expect(CalculatorEngine.calculate(-10, .divide, 2) == -5)
    }

    @Test("Decimal precision")
    func testDecimalPrecision() {
        let result = CalculatorEngine.calculate(0.1, .add, 0.2)
        // Due to floating point, check approximate equality
        #expect(abs(result - 0.3) < 0.0000001)
    }

    @Test("Format very large numbers uses scientific notation")
    func testFormatVeryLargeNumbers() {
        let result = CalculatorEngine.formatDisplay(1e16)
        #expect(result.contains("E") || result.contains("e"))
    }

    @Test("Format very small numbers uses scientific notation")
    func testFormatVerySmallNumbers() {
        let result = CalculatorEngine.formatDisplay(1e-9)
        #expect(result.contains("E") || result.contains("e"))
    }

    @Test("Format negative infinity")
    func testFormatNegativeInfinity() {
        let result = CalculatorEngine.formatDisplay(-.infinity)
        #expect(result == "Error")
    }

    @Test("Percentage of zero")
    func testPercentageOfZero() {
        let result = CalculatorEngine.percentage(0)
        #expect(result == 0)
    }

    @Test("Percentage of negative")
    func testPercentageOfNegative() {
        let result = CalculatorEngine.percentage(-50)
        #expect(result == -0.5)
    }

    @Test("Format large whole number boundary")
    func testFormatLargeWholeBoundary() {
        // Just under the scientific notation threshold
        let result = CalculatorEngine.formatDisplay(999_999_999_999_999)
        #expect(!result.contains("E") && !result.contains("e"))
    }
}
