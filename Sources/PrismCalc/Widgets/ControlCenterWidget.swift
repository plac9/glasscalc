#if os(iOS)
import WidgetKit
import SwiftUI
import AppIntents

// MARK: - Control Center Widget (iOS 18+)

/// Control Center button to quickly open PrismCalc
@available(iOS 18.0, *)
struct PrismCalcControlWidget: ControlWidget {
    static let kind: String = "PrismCalcControl"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: OpenCalculatorIntent()) {
                Label("PrismCalc", systemImage: "equal.square.fill")
            }
        }
        .displayName("PrismCalc")
        .description("Quick access to PrismCalc calculator")
    }
}

/// Control Center button for tip calculator
@available(iOS 18.0, *)
struct TipCalculatorControlWidget: ControlWidget {
    static let kind: String = "TipCalculatorControl"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: OpenFeatureIntent(feature: .tipCalculator)) {
                Label("Tip", systemImage: "dollarsign.circle")
            }
        }
        .displayName("Tip Calculator")
        .description("Quick tip calculation")
    }
}

/// Control Center button for bill split
@available(iOS 18.0, *)
struct BillSplitControlWidget: ControlWidget {
    static let kind: String = "BillSplitControl"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: OpenFeatureIntent(feature: .billSplit)) {
                Label("Split", systemImage: "person.2")
            }
        }
        .displayName("Bill Split")
        .description("Split bills quickly")
    }
}

/// Control Center button for unit converter
@available(iOS 18.0, *)
struct UnitConverterControlWidget: ControlWidget {
    static let kind: String = "UnitConverterControl"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: OpenFeatureIntent(feature: .unitConverter)) {
                Label("Convert", systemImage: "arrow.left.arrow.right")
            }
        }
        .displayName("Unit Converter")
        .description("Quick unit conversion")
    }
}

/// Control Center button for discount calculator
@available(iOS 18.0, *)
struct DiscountControlWidget: ControlWidget {
    static let kind: String = "DiscountControl"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: OpenFeatureIntent(feature: .discountCalculator)) {
                Label("Discount", systemImage: "tag")
            }
        }
        .displayName("Discount Calculator")
        .description("Calculate discounts quickly")
    }
}
#endif
