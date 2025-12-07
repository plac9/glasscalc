import Foundation
import WidgetKit

/// Shared data service for app-widget communication via App Groups
/// @unchecked Sendable because UserDefaults is thread-safe but not marked Sendable
public final class SharedDataService: @unchecked Sendable {

    // MARK: - Constants

    public static let shared = SharedDataService()
    public static let appGroupIdentifier = "group.com.laclairtech.prismcalc"
    private let userDefaults: UserDefaults
    private let shouldReloadWidgets: Bool
    private let lastResultKey = "lastResult"
    private let lastExpressionKey = "lastExpression"
    private let recentHistoryKey = "recentHistory"

    // MARK: - Init

    private init() {
        self.userDefaults = UserDefaults(suiteName: Self.appGroupIdentifier) ?? .standard
        self.shouldReloadWidgets = true
    }

    /// Internal initializer for testing with an isolated suite and optional widget reload suppression.
    init(userDefaults: UserDefaults, shouldReloadWidgets: Bool = true) {
        self.userDefaults = userDefaults
        self.shouldReloadWidgets = shouldReloadWidgets
    }

    // MARK: - Write (from main app)

    public func saveLastCalculation(result: String, expression: String) {
        userDefaults.set(result, forKey: lastResultKey)
        userDefaults.set(expression, forKey: lastExpressionKey)
        reloadWidget()
    }

    public func saveRecentHistory(_ items: [WidgetHistoryItem]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(items) {
            userDefaults.set(data, forKey: recentHistoryKey)
            reloadWidget()
        }
    }

    // MARK: - Read (from widget)

    public func getLastResult() -> String {
        userDefaults.string(forKey: lastResultKey) ?? "0"
    }

    public func getLastExpression() -> String {
        userDefaults.string(forKey: lastExpressionKey) ?? ""
    }

    public func getRecentHistory() -> [WidgetHistoryItem] {
        guard let data = userDefaults.data(forKey: recentHistoryKey),
              let items = try? JSONDecoder().decode([WidgetHistoryItem].self, from: data) else {
            return []
        }
        return items
    }

    // MARK: - Clear Data

    public func clearHistory() {
        userDefaults.removeObject(forKey: lastResultKey)
        userDefaults.removeObject(forKey: lastExpressionKey)
        userDefaults.removeObject(forKey: recentHistoryKey)
        reloadWidget()
    }

    // MARK: - Widget Reload

    private func reloadWidget() {
        guard shouldReloadWidgets else { return }
        WidgetCenter.shared.reloadTimelines(ofKind: "PrismCalcWidget")
    }
}

// MARK: - Widget History Item

public struct WidgetHistoryItem: Codable, Identifiable {
    public let id: UUID
    public let type: String
    public let result: String
    public let details: String
    public let icon: String

    public init(type: String, result: String, details: String, icon: String) {
        self.id = UUID()
        self.type = type
        self.result = result
        self.details = details
        self.icon = icon
    }
}
