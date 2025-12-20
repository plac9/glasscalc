import TipKit

// MARK: - Pro Feature Tips

/// Tip shown when user first sees a Pro feature
struct ProFeatureTip: Tip {
    var title: Text {
        Text("Unlock Pro Features")
    }

    var message: Text? {
        Text("Get access to tip calculator, discounts, split bill, and unit converter.")
    }

    var image: Image? {
        Image(systemName: "star.fill")
    }

    var actions: [Action] {
        Action(id: "upgrade", title: "Learn More")
    }
}

// MARK: - Widget Tips

/// Tip to encourage adding the widget with clear instructions
struct AddWidgetTip: Tip {
    var title: Text {
        Text("Add Quick Access Widget")
    }

    var message: Text? {
        Text("Long-press your Home Screen, tap the + button, then search \"prismCalc\" to add a calculator widget.")
    }

    var image: Image? {
        Image(systemName: "plus.app")
    }

    var actions: [Action] {
        Action(id: "dismiss", title: "Got It")
    }

    // Show after 3 calculations
    @Parameter
    static var calculationCount: Int = 0

    var rules: [Rule] {
        #Rule(Self.$calculationCount) { $0 >= 3 }
    }
}

// MARK: - History Tips

/// Tip for using history feature
struct HistoryTip: Tip {
    var title: Text {
        Text("View Past Calculations")
    }

    var message: Text? {
        Text("Tap History to see your recent calculations. Long press any result to copy it.")
    }

    var image: Image? {
        Image(systemName: "clock.arrow.circlepath")
    }

    // Show after first calculation saved
    @Parameter
    static var hasUsedCalculator: Bool = false

    var rules: [Rule] {
        #Rule(Self.$hasUsedCalculator) { $0 == true }
    }
}

/// Tip for copying results
struct CopyResultTip: Tip {
    var title: Text {
        Text("Copy Your Results")
    }

    var message: Text? {
        Text("Long press on any result to copy it to your clipboard.")
    }

    var image: Image? {
        Image(systemName: "doc.on.doc")
    }

    // Show after 5 calculations
    @Parameter
    static var calculationCount: Int = 0

    var rules: [Rule] {
        #Rule(Self.$calculationCount) { $0 >= 5 }
    }
}

// MARK: - Calculator Tips

/// Tip for swipe gestures (if applicable)
struct SwipeToSwitchTip: Tip {
    var title: Text {
        Text("Switch Calculators")
    }

    var message: Text? {
        Text("Use the tabs at the bottom to access different calculators.")
    }

    var image: Image? {
        Image(systemName: "hand.tap")
    }
}

// MARK: - Tip Configuration

/// Configure TipKit on app launch
public enum TipKitConfiguration {
    public static func configure() {
        try? Tips.configure([
            .displayFrequency(.daily),
            .datastoreLocation(.applicationDefault)
        ])
    }

    /// Call when a calculation is performed
    public static func recordCalculation() {
        AddWidgetTip.calculationCount += 1
        CopyResultTip.calculationCount += 1
        HistoryTip.hasUsedCalculator = true
    }

    /// Reset tips for testing
    public static func resetTips() {
        try? Tips.resetDatastore()
    }
}
