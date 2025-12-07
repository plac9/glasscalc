import Foundation
import SwiftData

/// A saved calculation history entry
@Model
public final class HistoryEntry {
    /// Unique identifier
    public var id: UUID

    /// Type of calculation
    public var calculationType: String

    /// Primary display value (result)
    public var result: String

    /// Description of the calculation
    public var details: String

    /// When the calculation was performed
    public var timestamp: Date

    /// Optional: original expression for basic calculator
    public var expression: String?

    public init(
        calculationType: CalculationType,
        result: String,
        details: String,
        expression: String? = nil
    ) {
        self.id = UUID()
        self.calculationType = calculationType.rawValue
        self.result = result
        self.details = details
        self.timestamp = Date()
        self.expression = expression
    }

    // MARK: - Computed

    public var type: CalculationType {
        CalculationType(rawValue: calculationType) ?? .basic
    }

    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }

    public var relativeDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}

// MARK: - Calculation Type

public enum CalculationType: String, CaseIterable, Sendable {
    case basic = "Calculator"
    case tip = "Tip"
    case discount = "Discount"
    case split = "Split"
    case convert = "Convert"

    public var icon: String {
        switch self {
        case .basic: return "plus.forwardslash.minus"
        case .tip: return "dollarsign.circle"
        case .discount: return "tag"
        case .split: return "person.2"
        case .convert: return "arrow.left.arrow.right"
        }
    }
}
