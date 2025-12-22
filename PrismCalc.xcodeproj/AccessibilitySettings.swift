import SwiftUI

/// App-wide accessibility preferences
public struct AccessibilitySettings: View {
    @AppStorage("highContrastUI") private var highContrastUI: Bool = false

    public init() {}

    public var body: some View {
        Form {
            Section("Accessibility") {
                Toggle(isOn: $highContrastUI) {
                    Text("High Contrast Text")
                }
                .accessibilityLabel("High Contrast Text")
                .accessibilityHint("Increases text contrast for readability on glass backgrounds")
            }
        }
        .navigationTitle("Accessibility")
    }
}

// MARK: - Theme Hook

public enum AccessibilityTheme {
    @AppStorage("highContrastUI") private static var highContrastUI: Bool = false

    /// Whether to increase text contrast globally
    public static var isHighContrast: Bool { highContrastUI }
}

// MARK: - GlassTheme extension to adjust text colors based on accessibility

public enum GlassTheme {
    public static var labelColor: Color {
        AccessibilityTheme.isHighContrast ? Color.white : Color.gray.opacity(0.8)
    }

    public static var secondaryLabelColor: Color {
        AccessibilityTheme.isHighContrast ? Color.white.opacity(0.8) : Color.gray.opacity(0.5)
    }
}

#Preview {
    NavigationStack {
        AccessibilitySettings()
    }
}
