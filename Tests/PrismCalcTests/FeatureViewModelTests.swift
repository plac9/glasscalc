import Testing
@testable import PrismCalc

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

/// Tests for DiscountCalculatorViewModel
@Suite("Discount Calculator ViewModel")
struct DiscountCalculatorViewModelTests {

    @Test("Initial discount percentage is 20")
    @MainActor
    func testInitialDiscountPercentage() {
        let viewModel = DiscountCalculatorViewModel()
        #expect(viewModel.discountPercentage == 20)
    }

    @Test("Initial original price is empty")
    @MainActor
    func testInitialPrice() {
        let viewModel = DiscountCalculatorViewModel()
        #expect(viewModel.originalPrice == "")
    }

    @Test("Calculate discount amount at 10%")
    @MainActor
    func testCalculateDiscount10Percent() {
        let viewModel = DiscountCalculatorViewModel()
        viewModel.originalPrice = "100"
        viewModel.discountPercentage = 10

        #expect(viewModel.discountAmount == 10.0)
        #expect(viewModel.finalPrice == 90.0)
    }

    @Test("Calculate discount amount at 25%")
    @MainActor
    func testCalculateDiscount25Percent() {
        let viewModel = DiscountCalculatorViewModel()
        viewModel.originalPrice = "80"
        viewModel.discountPercentage = 25

        #expect(viewModel.discountAmount == 20.0)
        #expect(viewModel.finalPrice == 60.0)
    }

    @Test("Calculate discount amount at 50%")
    @MainActor
    func testCalculateDiscount50Percent() {
        let viewModel = DiscountCalculatorViewModel()
        viewModel.originalPrice = "200"
        viewModel.discountPercentage = 50

        #expect(viewModel.discountAmount == 100.0)
        #expect(viewModel.finalPrice == 100.0)
    }

    @Test("Edge case: 0% discount")
    @MainActor
    func testZeroPercentDiscount() {
        let viewModel = DiscountCalculatorViewModel()
        viewModel.originalPrice = "100"
        viewModel.discountPercentage = 0

        #expect(viewModel.discountAmount == 0.0)
        #expect(viewModel.finalPrice == 100.0)
    }

    @Test("Edge case: 100% discount")
    @MainActor
    func testFullDiscount() {
        let viewModel = DiscountCalculatorViewModel()
        viewModel.originalPrice = "100"
        viewModel.discountPercentage = 100

        #expect(viewModel.discountAmount == 100.0)
        #expect(viewModel.finalPrice == 0.0)
    }

    @Test("Empty price returns zero values")
    @MainActor
    func testEmptyPrice() {
        let viewModel = DiscountCalculatorViewModel()
        viewModel.originalPrice = ""
        viewModel.discountPercentage = 25

        #expect(viewModel.discountAmount == 0.0)
        #expect(viewModel.finalPrice == 0.0)
    }

    @Test("Invalid price returns zero values")
    @MainActor
    func testInvalidPrice() {
        let viewModel = DiscountCalculatorViewModel()
        viewModel.originalPrice = "abc"

        #expect(viewModel.priceValue == 0.0)
        #expect(viewModel.discountAmount == 0.0)
    }

    @Test("Select quick discount updates percentage")
    @MainActor
    func testSelectQuickDiscount() {
        let viewModel = DiscountCalculatorViewModel()
        viewModel.selectQuickDiscount(50)
        #expect(viewModel.discountPercentage == 50)
    }

    @Test("Clear resets all values")
    @MainActor
    func testClear() {
        let viewModel = DiscountCalculatorViewModel()
        viewModel.originalPrice = "99.99"
        viewModel.discountPercentage = 50

        viewModel.clear()

        #expect(viewModel.originalPrice == "")
        #expect(viewModel.discountPercentage == 20)
    }

    @Test("Input validation limits characters")
    @MainActor
    func testInputValidation() {
        let viewModel = DiscountCalculatorViewModel()
        viewModel.originalPrice = "12345678901234567890" // 20 chars

        // Should be limited to 10 characters
        #expect(viewModel.originalPrice.count <= 10)
    }

    @Test("Input validation prevents multiple decimals")
    @MainActor
    func testPreventMultipleDecimals() {
        let viewModel = DiscountCalculatorViewModel()
        viewModel.originalPrice = "12.34.56"

        // Should only have one decimal
        let decimalCount = viewModel.originalPrice.filter { $0 == "." }.count
        #expect(decimalCount <= 1)
    }

    @Test("Discount percentage is clamped 0-100")
    @MainActor
    func testDiscountPercentageClamped() {
        let viewModel = DiscountCalculatorViewModel()

        viewModel.discountPercentage = -10
        #expect(viewModel.discountPercentage == 0)

        viewModel.discountPercentage = 150
        #expect(viewModel.discountPercentage == 100)
    }
}

/// Tests for SplitBillViewModel
@Suite("Split Bill ViewModel")
struct SplitBillViewModelTests {

    @Test("Initial number of people is 2")
    @MainActor
    func testInitialPeople() {
        let viewModel = SplitBillViewModel()
        #expect(viewModel.numberOfPeople == 2)
    }

    @Test("Initial tip percentage is 18")
    @MainActor
    func testInitialTipPercentage() {
        let viewModel = SplitBillViewModel()
        #expect(viewModel.tipPercentage == 18)
    }

    @Test("Initial include tip is true")
    @MainActor
    func testInitialIncludeTip() {
        let viewModel = SplitBillViewModel()
        #expect(viewModel.includeTip == true)
    }

    @Test("Calculate split without tip")
    @MainActor
    func testSplitWithoutTip() {
        let viewModel = SplitBillViewModel()
        viewModel.totalBill = "100"
        viewModel.numberOfPeople = 4
        viewModel.includeTip = false

        #expect(viewModel.grandTotal == 100.0)
        #expect(viewModel.perPersonShare == 25.0)
    }

    @Test("Calculate split with tip")
    @MainActor
    func testSplitWithTip() {
        let viewModel = SplitBillViewModel()
        viewModel.totalBill = "100"
        viewModel.numberOfPeople = 4
        viewModel.tipPercentage = 20
        viewModel.includeTip = true

        // 100 + 20% = 120, divided by 4 = 30
        #expect(viewModel.tipAmount == 20.0)
        #expect(viewModel.grandTotal == 120.0)
        #expect(viewModel.perPersonShare == 30.0)
    }

    @Test("Tip per person calculation")
    @MainActor
    func testTipPerPerson() {
        let viewModel = SplitBillViewModel()
        viewModel.totalBill = "80"
        viewModel.numberOfPeople = 4
        viewModel.tipPercentage = 20
        viewModel.includeTip = true

        // 80 * 20% = 16 tip, divided by 4 = 4 per person
        #expect(viewModel.tipPerPerson == 4.0)
    }

    @Test("Empty bill returns zero values")
    @MainActor
    func testEmptyBill() {
        let viewModel = SplitBillViewModel()
        viewModel.totalBill = ""

        #expect(viewModel.billValue == 0.0)
        #expect(viewModel.grandTotal == 0.0)
        #expect(viewModel.perPersonShare == 0.0)
    }

    @Test("Invalid bill returns zero values")
    @MainActor
    func testInvalidBill() {
        let viewModel = SplitBillViewModel()
        viewModel.totalBill = "abc"

        #expect(viewModel.billValue == 0.0)
    }

    @Test("Increment people count")
    @MainActor
    func testIncrementPeople() {
        let viewModel = SplitBillViewModel()
        viewModel.incrementPeople()
        #expect(viewModel.numberOfPeople == 3)
    }

    @Test("Decrement people count")
    @MainActor
    func testDecrementPeople() {
        let viewModel = SplitBillViewModel()
        viewModel.numberOfPeople = 5
        viewModel.decrementPeople()
        #expect(viewModel.numberOfPeople == 4)
    }

    @Test("People count minimum is 1")
    @MainActor
    func testPeopleCountMinimum() {
        let viewModel = SplitBillViewModel()
        viewModel.numberOfPeople = 1
        viewModel.decrementPeople()
        #expect(viewModel.numberOfPeople == 1)
    }

    @Test("People count maximum is 99")
    @MainActor
    func testPeopleCountMaximum() {
        let viewModel = SplitBillViewModel()
        viewModel.numberOfPeople = 99
        viewModel.incrementPeople()
        #expect(viewModel.numberOfPeople == 99)
    }

    @Test("Toggle tip")
    @MainActor
    func testToggleTip() {
        let viewModel = SplitBillViewModel()
        #expect(viewModel.includeTip == true)

        viewModel.toggleTip()
        #expect(viewModel.includeTip == false)

        viewModel.toggleTip()
        #expect(viewModel.includeTip == true)
    }

    @Test("Clear resets all values")
    @MainActor
    func testClear() {
        let viewModel = SplitBillViewModel()
        viewModel.totalBill = "50"
        viewModel.numberOfPeople = 5
        viewModel.tipPercentage = 25
        viewModel.includeTip = false

        viewModel.clear()

        #expect(viewModel.totalBill == "")
        #expect(viewModel.numberOfPeople == 2)
        #expect(viewModel.tipPercentage == 18)
        #expect(viewModel.includeTip == true)
    }

    @Test("Input validation limits characters")
    @MainActor
    func testInputValidation() {
        let viewModel = SplitBillViewModel()
        viewModel.totalBill = "12345678901234567890" // 20 chars

        // Should be limited to 10 characters
        #expect(viewModel.totalBill.count <= 10)
    }

    @Test("Input validation prevents multiple decimals")
    @MainActor
    func testPreventMultipleDecimals() {
        let viewModel = SplitBillViewModel()
        viewModel.totalBill = "12.34.56"

        // Should only have one decimal
        let decimalCount = viewModel.totalBill.filter { $0 == "." }.count
        #expect(decimalCount <= 1)
    }

    @Test("Tip percentage is clamped 0-100")
    @MainActor
    func testTipPercentageClamped() {
        let viewModel = SplitBillViewModel()

        viewModel.tipPercentage = -10
        #expect(viewModel.tipPercentage == 0)

        viewModel.tipPercentage = 150
        #expect(viewModel.tipPercentage == 100)
    }

    @Test("People count is clamped 1-99")
    @MainActor
    func testPeopleCountClamped() {
        let viewModel = SplitBillViewModel()

        viewModel.numberOfPeople = 0
        #expect(viewModel.numberOfPeople == 1)

        viewModel.numberOfPeople = 100
        #expect(viewModel.numberOfPeople == 99)
    }

    @Test("Even split rounding")
    @MainActor
    func testEvenSplitRounding() {
        let viewModel = SplitBillViewModel()
        viewModel.totalBill = "100"
        viewModel.numberOfPeople = 3
        viewModel.includeTip = false

        // 100 / 3 = 33.333...
        let result = viewModel.perPersonShare
        #expect(result > 33.33 && result < 33.34)
    }
}
