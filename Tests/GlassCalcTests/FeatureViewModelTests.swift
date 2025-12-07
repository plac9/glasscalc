import Testing
@testable import GlassCalc

/// Tests for TipCalculatorViewModel
@Suite("Tip Calculator ViewModel")
struct TipCalculatorViewModelTests {

    @Test("Initial tip percentage is 18")
    @MainActor
    func testInitialTipPercentage() {
        let viewModel = TipCalculatorViewModel()
        #expect(viewModel.tipPercentage == 18)
    }

    @Test("Initial number of people is 1")
    @MainActor
    func testInitialNumberOfPeople() {
        let viewModel = TipCalculatorViewModel()
        #expect(viewModel.numberOfPeople == 1)
    }

    @Test("Calculate tip amount")
    @MainActor
    func testCalculateTipAmount() {
        let viewModel = TipCalculatorViewModel()
        viewModel.billAmount = "100"
        viewModel.tipPercentage = 20

        #expect(viewModel.tipAmount == 20.0)
    }

    @Test("Calculate total with tip")
    @MainActor
    func testCalculateTotal() {
        let viewModel = TipCalculatorViewModel()
        viewModel.billAmount = "100"
        viewModel.tipPercentage = 15

        #expect(viewModel.totalAmount == 115.0)
    }

    @Test("Calculate per person amount")
    @MainActor
    func testCalculatePerPerson() {
        let viewModel = TipCalculatorViewModel()
        viewModel.billAmount = "120"
        viewModel.tipPercentage = 20
        viewModel.numberOfPeople = 4

        // 120 + 24 (20%) = 144, divided by 4 = 36
        #expect(viewModel.perPersonAmount == 36.0)
    }

    @Test("Empty bill returns zero values")
    @MainActor
    func testEmptyBill() {
        let viewModel = TipCalculatorViewModel()
        viewModel.billAmount = ""

        #expect(viewModel.tipAmount == 0)
        #expect(viewModel.totalAmount == 0)
        #expect(viewModel.perPersonAmount == 0)
    }

    @Test("Invalid bill returns zero values")
    @MainActor
    func testInvalidBill() {
        let viewModel = TipCalculatorViewModel()
        viewModel.billAmount = "abc"

        #expect(viewModel.tipAmount == 0)
        #expect(viewModel.totalAmount == 0)
    }

    @Test("Increment people count")
    @MainActor
    func testIncrementPeople() {
        let viewModel = TipCalculatorViewModel()
        viewModel.incrementPeople()
        #expect(viewModel.numberOfPeople == 2)
    }

    @Test("Decrement people count")
    @MainActor
    func testDecrementPeople() {
        let viewModel = TipCalculatorViewModel()
        viewModel.numberOfPeople = 3
        viewModel.decrementPeople()
        #expect(viewModel.numberOfPeople == 2)
    }

    @Test("People count minimum is 1")
    @MainActor
    func testPeopleCountMinimum() {
        let viewModel = TipCalculatorViewModel()
        viewModel.numberOfPeople = 1
        viewModel.decrementPeople()
        #expect(viewModel.numberOfPeople == 1)
    }

    @Test("Select quick tip updates percentage")
    @MainActor
    func testSelectQuickTip() {
        let viewModel = TipCalculatorViewModel()
        viewModel.selectQuickTip(25)
        #expect(viewModel.tipPercentage == 25)
    }

    @Test("Clear resets all values")
    @MainActor
    func testClear() {
        let viewModel = TipCalculatorViewModel()
        viewModel.billAmount = "50"
        viewModel.tipPercentage = 25
        viewModel.numberOfPeople = 4

        viewModel.clear()

        #expect(viewModel.billAmount == "")
        #expect(viewModel.tipPercentage == 18)
        #expect(viewModel.numberOfPeople == 1)
    }
}

/// Tests for UnitConverterViewModel
@Suite("Unit Converter ViewModel")
struct UnitConverterViewModelTests {

    @Test("Initial input value is empty")
    @MainActor
    func testInitialState() {
        let viewModel = UnitConverterViewModel()
        #expect(viewModel.inputValue == "")
    }

    @Test("Default category is length")
    @MainActor
    func testDefaultCategory() {
        let viewModel = UnitConverterViewModel()
        #expect(viewModel.selectedCategory == .length)
    }

    @Test("Convert meters to feet")
    @MainActor
    func testMetersToFeet() {
        let viewModel = UnitConverterViewModel()
        viewModel.inputValue = "1"
        viewModel.selectedCategory = .length
        viewModel.fromUnit = "meters"
        viewModel.toUnit = "feet"

        // 1 meter ≈ 3.28084 feet
        let result = viewModel.convertedValue
        #expect(result > 3.2 && result < 3.3)
    }

    @Test("Convert kilometers to miles")
    @MainActor
    func testKilometersToMiles() {
        let viewModel = UnitConverterViewModel()
        viewModel.inputValue = "10"
        viewModel.selectedCategory = .length
        viewModel.fromUnit = "kilometers"
        viewModel.toUnit = "miles"

        // 10 km ≈ 6.21371 miles
        let result = viewModel.convertedValue
        #expect(result > 6.2 && result < 6.3)
    }

    @Test("Convert Celsius to Fahrenheit")
    @MainActor
    func testCelsiusToFahrenheit() {
        let viewModel = UnitConverterViewModel()
        viewModel.inputValue = "100"
        viewModel.selectCategory(.temperature)
        viewModel.fromUnit = "celsius"
        viewModel.toUnit = "fahrenheit"

        // 100°C = 212°F
        #expect(viewModel.convertedValue == 212.0)
    }

    @Test("Convert pounds to kilograms")
    @MainActor
    func testPoundsToKilograms() {
        let viewModel = UnitConverterViewModel()
        viewModel.inputValue = "100"
        viewModel.selectCategory(.weight)
        viewModel.fromUnit = "pounds"
        viewModel.toUnit = "kilograms"

        // 100 lbs ≈ 45.36 kg
        let result = viewModel.convertedValue
        #expect(result > 45 && result < 46)
    }

    @Test("Empty input returns zero")
    @MainActor
    func testEmptyInput() {
        let viewModel = UnitConverterViewModel()
        viewModel.inputValue = ""
        #expect(viewModel.convertedValue == 0)
    }

    @Test("Invalid input returns zero")
    @MainActor
    func testInvalidInput() {
        let viewModel = UnitConverterViewModel()
        viewModel.inputValue = "abc"
        #expect(viewModel.convertedValue == 0)
    }

    @Test("Swap units")
    @MainActor
    func testSwapUnits() {
        let viewModel = UnitConverterViewModel()
        viewModel.selectedCategory = .length
        viewModel.fromUnit = "meters"
        viewModel.toUnit = "feet"

        viewModel.swapUnits()

        #expect(viewModel.fromUnit == "feet")
        #expect(viewModel.toUnit == "meters")
    }

    @Test("Input validation limits characters")
    @MainActor
    func testInputValidation() {
        let viewModel = UnitConverterViewModel()
        viewModel.inputValue = "12345678901234567890" // 20 chars

        // Should be limited to 15 characters
        #expect(viewModel.inputValue.count <= 15)
    }

    @Test("Input validation allows only numbers and decimal")
    @MainActor
    func testInputValidationFiltersCharacters() {
        let viewModel = UnitConverterViewModel()
        viewModel.inputValue = "12.3abc45"

        // Should filter out non-numeric characters
        #expect(!viewModel.inputValue.contains("a"))
        #expect(!viewModel.inputValue.contains("b"))
        #expect(!viewModel.inputValue.contains("c"))
    }

    @Test("Same unit returns same value")
    @MainActor
    func testSameUnitNoConversion() {
        let viewModel = UnitConverterViewModel()
        viewModel.inputValue = "42"
        viewModel.fromUnit = "meters"
        viewModel.toUnit = "meters"

        #expect(viewModel.convertedValue == 42)
    }
}
