import Foundation

/// Shared accessibility preferences backed by UserDefaults.
public enum AccessibilityTheme {
    public static let highContrastKey = "highContrastUI"

    /// Whether to increase text contrast globally.
    public static var isHighContrast: Bool {
        UserDefaults.standard.bool(forKey: highContrastKey)
    }
}
