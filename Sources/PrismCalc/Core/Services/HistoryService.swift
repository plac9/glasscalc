import Foundation
import SwiftData
import SwiftUI

/// Service for managing calculation history
@MainActor
public final class HistoryService {
    public static let shared = HistoryService()

    private var container: ModelContainer?
    private var context: ModelContext?

    private init() {
        setupContainer()
    }

    // MARK: - Setup

    private func setupContainer() {
        do {
            let schema = Schema([HistoryEntry.self])
            let config = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .none // Enable .automatic for iCloud sync in Pro
            )
            container = try ModelContainer(for: schema, configurations: config)
            context = container?.mainContext
        } catch {
            print("Failed to create ModelContainer: \(error)")
        }
    }

    // MARK: - Public API

    /// Save a new history entry
    public func save(_ entry: HistoryEntry) {
        guard let context else { return }
        context.insert(entry)
        try? context.save()
        syncToWidget(entry: entry)
    }

    /// Sync latest entry to widget
    private func syncToWidget(entry: HistoryEntry) {
        // Update last result
        SharedDataService.shared.saveLastCalculation(
            result: entry.result,
            expression: entry.details
        )

        // Update recent history for widget
        let recent = fetchRecent(limit: 5)
        let widgetItems = recent.map { historyEntry in
            WidgetHistoryItem(
                type: historyEntry.calculationType,
                result: historyEntry.result,
                details: historyEntry.details,
                icon: iconForType(historyEntry.calculationType)
            )
        }
        SharedDataService.shared.saveRecentHistory(widgetItems)
    }

    private func iconForType(_ type: String) -> String {
        switch type {
        case "basic": return "plus.forwardslash.minus"
        case "tip": return "dollarsign.circle"
        case "discount": return "tag"
        case "split": return "person.2"
        case "convert": return "arrow.left.arrow.right"
        default: return "equal.square"
        }
    }

    /// Save a basic calculation
    public func saveCalculation(expression: String, result: String) {
        let entry = HistoryEntry(
            calculationType: .basic,
            result: result,
            details: expression,
            expression: expression
        )
        save(entry)
    }

    /// Save a tip calculation
    public func saveTip(bill: String, tipPercent: Int, total: String, perPerson: String?, people: Int, note: String? = nil) {
        var details = "\(bill) + \(tipPercent)% tip"
        if let perPerson, people > 1 {
            details += " ÷ \(people) = \(perPerson)/person"
        }
        let entry = HistoryEntry(
            calculationType: .tip,
            result: total,
            details: details,
            note: note?.isEmpty == true ? nil : note
        )
        save(entry)
    }

    /// Save a discount calculation
    public func saveDiscount(original: String, discountPercent: Int, final: String, saved: String, note: String? = nil) {
        let details = "\(original) - \(discountPercent)% = \(final) (saved \(saved))"
        let entry = HistoryEntry(
            calculationType: .discount,
            result: final,
            details: details,
            note: note?.isEmpty == true ? nil : note
        )
        save(entry)
    }

    /// Save a split bill calculation
    public func saveSplit(total: String, people: Int, perPerson: String, note: String? = nil) {
        let details = "\(total) ÷ \(people) people"
        let entry = HistoryEntry(
            calculationType: .split,
            result: perPerson,
            details: details,
            note: note?.isEmpty == true ? nil : note
        )
        save(entry)
    }

    /// Save a unit conversion
    public func saveConversion(value: String, fromUnit: String, toUnit: String, result: String, note: String? = nil) {
        let details = "\(value) \(fromUnit) → \(toUnit)"
        let entry = HistoryEntry(
            calculationType: .convert,
            result: result,
            details: details,
            note: note?.isEmpty == true ? nil : note
        )
        save(entry)
    }

    /// Fetch all history entries
    public func fetchAll() -> [HistoryEntry] {
        guard let context else { return [] }

        let descriptor = FetchDescriptor<HistoryEntry>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        return (try? context.fetch(descriptor)) ?? []
    }

    /// Fetch recent history (limited count)
    public func fetchRecent(limit: Int = 10) -> [HistoryEntry] {
        guard let context else { return [] }

        var descriptor = FetchDescriptor<HistoryEntry>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        descriptor.fetchLimit = limit

        return (try? context.fetch(descriptor)) ?? []
    }

    /// Delete a specific entry
    public func delete(_ entry: HistoryEntry) {
        guard let context else { return }
        context.delete(entry)
        try? context.save()
    }

    /// Clear all history
    public func clearAll() {
        guard let context else { return }

        let entries = fetchAll()
        for entry in entries {
            context.delete(entry)
        }
        try? context.save()
    }

    /// Get the model container for SwiftUI environment
    public var modelContainer: ModelContainer? {
        container
    }
}
