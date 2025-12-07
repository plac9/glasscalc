import SwiftUI
#if os(iOS)
import UIKit
#endif

/// Detail view for a history entry with iOS 18 zoom transition support
@available(iOS 18.0, *)
public struct HistoryDetailView: View {
    let entry: HistoryEntry
    @Environment(\.dismiss) private var dismiss

    @State private var showCopied = false

    public init(entry: HistoryEntry) {
        self.entry = entry
    }

    public var body: some View {
        ZStack {
            // Themed mesh background
            ThemedMeshBackground()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: GlassTheme.spacingLarge) {
                    // Type icon with bounce effect
                    iconSection

                    // Result display
                    resultSection

                    // Details card
                    detailsCard

                    // Action buttons
                    actionButtons

                    Spacer(minLength: GlassTheme.spacingXL)
                }
                .padding()
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                GlassIconButton(
                    icon: "xmark",
                    style: .plain,
                    symbolAnimation: .bounce,
                    accessibilityLabel: "Close"
                ) {
                    dismiss()
                }
            }
        }
        #else
        .toolbar {
            ToolbarItem(placement: .automatic) {
                GlassIconButton(
                    icon: "xmark",
                    style: .plain,
                    symbolAnimation: .bounce,
                    accessibilityLabel: "Close"
                ) {
                    dismiss()
                }
            }
        }
        #endif
        .overlay(alignment: .top) {
            if showCopied {
                copiedToast
            }
        }
    }

    // MARK: - Icon Section

    @MainActor
    private var iconSection: some View {
        Image(systemName: entry.type.icon)
            .font(.system(size: 64, weight: .medium))
            .foregroundStyle(
                LinearGradient(
                    colors: [GlassTheme.primary, GlassTheme.secondary],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .symbolEffect(.bounce, options: .nonRepeating)
            .padding(.top, GlassTheme.spacingLarge)
    }

    // MARK: - Result Section

    @MainActor
    private var resultSection: some View {
        VStack(spacing: GlassTheme.spacingXS) {
            Text(entry.result)
                .font(GlassTheme.displayFont)
                .foregroundStyle(GlassTheme.text)
                .multilineTextAlignment(.center)

            Text(entry.type.rawValue)
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.textSecondary)
                .padding(.horizontal, GlassTheme.spacingSmall)
                .padding(.vertical, GlassTheme.spacingXS)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                )
        }
    }

    // MARK: - Details Card

    @MainActor
    private var detailsCard: some View {
        GlassCard(material: .thinMaterial) {
            VStack(alignment: .leading, spacing: GlassTheme.spacingMedium) {
                detailRow(label: "Calculation", value: entry.details)

                if let expression = entry.expression, !expression.isEmpty {
                    detailRow(label: "Expression", value: expression)
                }

                detailRow(label: "Date", value: entry.formattedDate)
            }
        }
    }

    @MainActor
    private func detailRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: GlassTheme.spacingXS) {
            Text(label)
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.textTertiary)

            Text(value)
                .font(GlassTheme.bodyFont)
                .foregroundStyle(GlassTheme.text)
        }
    }

    // MARK: - Action Buttons

    @MainActor
    private var actionButtons: some View {
        HStack(spacing: GlassTheme.spacingMedium) {
            GlassPillButton(
                icon: "doc.on.doc",
                text: "Copy",
                style: .secondary,
                symbolAnimation: .bounce
            ) {
                copyToClipboard()
            }

            GlassPillButton(
                icon: "square.and.arrow.up",
                text: "Share",
                style: .secondary,
                symbolAnimation: .bounce
            ) {
                shareResult()
            }
        }
    }

    // MARK: - Copied Toast

    @MainActor
    private var copiedToast: some View {
        Text("Copied!")
            .font(GlassTheme.captionFont)
            .foregroundStyle(.white)
            .padding(.horizontal, GlassTheme.spacingMedium)
            .padding(.vertical, GlassTheme.spacingSmall)
            .background(
                Capsule()
                    .fill(GlassTheme.success)
            )
            .transition(.move(edge: .top).combined(with: .opacity))
            .padding(.top, GlassTheme.spacingMedium)
    }

    // MARK: - Actions

    private func copyToClipboard() {
        #if os(iOS)
        let text = "\(entry.result)\n\(entry.details)"
        UIPasteboard.general.string = text
        #endif

        withAnimation(GlassTheme.springAnimation) {
            showCopied = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(GlassTheme.springAnimation) {
                showCopied = false
            }
        }
    }

    private func shareResult() {
        #if os(iOS)
        let text = """
        \(entry.type.rawValue): \(entry.result)
        \(entry.details)
        — Shared from PrismCalc
        """

        let activityVC = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
        #endif
    }
}

// MARK: - Preview

#Preview {
    if #available(iOS 18.0, *) {
        NavigationStack {
            HistoryDetailView(
                entry: HistoryEntry(
                    calculationType: .tip,
                    result: "$15.00",
                    details: "20% tip on $75.00"
                )
            )
        }
    }
}
