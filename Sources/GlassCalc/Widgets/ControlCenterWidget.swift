import WidgetKit
import SwiftUI
import AppIntents

// MARK: - Control Center Widget (iOS 18+)

/// Control Center button to quickly open GlassCalc
@available(iOS 18.0, *)
struct GlassCalcControlWidget: ControlWidget {
    static let kind: String = "GlassCalcControl"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: OpenCalculatorIntent()) {
                Label("GlassCalc", systemImage: "equal.square.fill")
            }
        }
        .displayName("GlassCalc")
        .description("Quick access to GlassCalc calculator")
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
