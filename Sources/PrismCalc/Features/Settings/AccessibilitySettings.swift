import SwiftUI

/// App-wide accessibility preferences.
public struct AccessibilitySettings: View {
    @AppStorage(AccessibilityTheme.highContrastKey) private var highContrastUI: Bool = false

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: GlassTheme.spacingLarge) {
                Text("Accessibility")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)
                    .textCase(.uppercase)
                    .padding(.leading, GlassTheme.spacingSmall)

                GlassCard(material: .thinMaterial, padding: GlassTheme.spacingMedium) {
                    Toggle(isOn: $highContrastUI) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("High Contrast Text")
                                .font(GlassTheme.bodyFont)
                                .foregroundStyle(GlassTheme.text)
                            Text("Increase contrast for improved readability on glass backgrounds.")
                                .font(GlassTheme.captionFont)
                                .foregroundStyle(GlassTheme.textSecondary)
                        }
                    }
                    .toggleStyle(.switch)
                    .accessibilityLabel("High Contrast Text")
                    .accessibilityHint("Increases text contrast for readability on glass backgrounds")
                }

                GlassCard(material: .ultraThinMaterial, padding: GlassTheme.spacingMedium) {
                    VStack(alignment: .leading, spacing: GlassTheme.spacingSmall) {
                        Text("Tip")
                            .font(GlassTheme.captionFont)
                            .foregroundStyle(GlassTheme.textSecondary)
                            .textCase(.uppercase)
                        Text("High contrast improves legibility in bright environments and helps reduce eye strain.")
                            .font(GlassTheme.bodyFont)
                            .foregroundStyle(GlassTheme.text)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Accessibility")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        #endif
    }
}

#Preview {
    NavigationStack {
        AccessibilitySettings()
    }
}
