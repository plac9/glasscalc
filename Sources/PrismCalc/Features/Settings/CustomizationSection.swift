import SwiftUI

/// Customization settings section for keypad layout, tab order, and widgets
public struct CustomizationSection: View {
    @AppStorage("zeroOnRight") private var zeroOnRight: Bool = false
    #if os(macOS)
    @AppStorage("macTabBarMode") private var macTabBarMode: MacTabBarMode = .always
    #endif
    @ScaledMetric(relativeTo: .caption2) private var proBadgeSize: CGFloat = 9

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: GlassTheme.spacingSmall) {
            sectionHeader

            GlassCard(material: .thinMaterial, padding: 0) {
                VStack(spacing: 0) {
                    zeroPositionRow

                    Divider()
                        .background(GlassTheme.text.opacity(0.1))

                    #if os(macOS)
                    macTabBarRow

                    Divider()
                        .background(GlassTheme.text.opacity(0.1))
                    #endif

                    resetTabOrderRow

                    Divider()
                        .background(GlassTheme.text.opacity(0.1))

                    widgetSettingsRow
                }
            }
        }
    }

    // MARK: - Subviews

    @MainActor
    private var sectionHeader: some View {
        Text("Customization")
            .font(GlassTheme.captionFont)
            .foregroundStyle(GlassTheme.textSecondary)
            .textCase(.uppercase)
            .padding(.leading, GlassTheme.spacingSmall)
    }

    @MainActor
    private var zeroPositionRow: some View {
        HStack {
            Image(systemName: "number.square")
                .foregroundStyle(GlassTheme.primary)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text("Zero on Right")
                    .font(GlassTheme.bodyFont)
                    .foregroundStyle(GlassTheme.text)

                Text("Swap 0 and decimal positions")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textTertiary)
            }

            Spacer()

            Toggle("", isOn: $zeroOnRight)
                .tint(GlassTheme.primary)
                .labelsHidden()
        }
        .padding(GlassTheme.spacingMedium)
        .sensoryFeedback(.selection, trigger: zeroOnRight)
        .accessibilityLabel("Zero on right")
        .accessibilityHint("When enabled, the zero button appears on the right side of the keypad")
    }

    @MainActor
    private var resetTabOrderRow: some View {
        Button {
            resetTabOrder()
        } label: {
            HStack {
                Image(systemName: "square.grid.2x2")
                    .foregroundStyle(GlassTheme.primary)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Reset Tab Order")
                        .font(GlassTheme.bodyFont)
                        .foregroundStyle(GlassTheme.text)

                    Text("Tap More menu to customize tabs")
                        .font(GlassTheme.captionFont)
                        .foregroundStyle(GlassTheme.textTertiary)
                }

                Spacer()

                Image(systemName: "arrow.counterclockwise")
                    .font(.caption)
                    .foregroundStyle(GlassTheme.textSecondary)
            }
            .padding(GlassTheme.spacingMedium)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: false)
        .accessibilityLabel("Reset tab order")
        .accessibilityHint("Restores tabs to their default order")
    }

    #if os(macOS)
    @MainActor
    private var macTabBarRow: some View {
        HStack(alignment: .center, spacing: GlassTheme.spacingSmall) {
            Image(systemName: "dock.rectangle")
                .foregroundStyle(GlassTheme.primary)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text("Bottom Bar")
                    .font(GlassTheme.bodyFont)
                    .foregroundStyle(GlassTheme.text)

                Text(macTabBarMode.subtitle)
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textTertiary)
            }

            Spacer()

            Picker("", selection: $macTabBarMode) {
                ForEach(MacTabBarMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 180)
            .labelsHidden()
        }
        .padding(GlassTheme.spacingMedium)
        .accessibilityLabel("Bottom bar mode")
        .accessibilityHint("Choose always visible or auto-hide")
    }
    #endif

    @MainActor
    private var widgetSettingsRow: some View {
        NavigationLink {
            WidgetSettingsView()
        } label: {
            HStack {
                Image(systemName: "widget.small")
                    .foregroundStyle(GlassTheme.primary)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Widgets")
                        .font(GlassTheme.bodyFont)
                        .foregroundStyle(GlassTheme.text)

                    Text("Add widgets to Home Screen")
                        .font(GlassTheme.captionFont)
                        .foregroundStyle(GlassTheme.textTertiary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(GlassTheme.textTertiary)
            }
            .padding(GlassTheme.spacingMedium)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Widgets")
        .accessibilityHint("View available widgets and how to add them")
    }

    // MARK: - Actions

    private func resetTabOrder() {
        UserDefaults.standard.removeObject(forKey: "tabCustomization")
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        #endif
    }
}
