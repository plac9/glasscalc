import SwiftUI

/// Pro upgrade section showing upgrade benefits and purchase options
public struct ProUpgradeSection: View {
    @State private var showPurchaseError: Bool = false
    private var storeKit: StoreKitManager { StoreKitManager.shared }

    public init() {}

    public var body: some View {
        GlassCard {
            VStack(spacing: GlassTheme.spacingMedium) {
                HStack {
                    VStack(alignment: .leading, spacing: GlassTheme.spacingXS) {
                        Text("prismCalc Pro")
                            .font(GlassTheme.headlineFont)
                            .foregroundStyle(GlassTheme.text)

                        Text(storeKit.isPro ? "All features unlocked" : "Unlock all features")
                            .font(GlassTheme.captionFont)
                            .foregroundStyle(GlassTheme.textSecondary)
                    }

                    Spacer()

                    if storeKit.isPro {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.title)
                            .foregroundStyle(GlassTheme.success)
                    }
                }

                if !storeKit.isPro {
                    featureList

                    purchaseButton

                    restoreButton
                }
            }
        }
        .alert("Purchase Error", isPresented: $showPurchaseError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(storeKit.errorMessage ?? "An error occurred")
        }
    }

    private var featureList: some View {
        VStack(alignment: .leading, spacing: GlassTheme.spacingXS) {
            featureRow(icon: "percent", text: "Tip Calculator")
            featureRow(icon: "tag", text: "Discount Calculator")
            featureRow(icon: "person.2", text: "Split Bill")
            featureRow(icon: "arrow.left.arrow.right", text: "Unit Converter")
            featureRow(icon: "paintpalette", text: "All 6 Themes")
            featureRow(icon: "clock.arrow.circlepath", text: "History with lock/unlock entries")
        }
    }

    private var purchaseButton: some View {
        Button {
            Task {
                do {
                    try await storeKit.purchase()
                } catch {
                    showPurchaseError = true
                }
            }
        } label: {
            HStack {
                if storeKit.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Upgrade for \(storeKit.proPrice)")
                }
            }
            .font(GlassTheme.bodyFont)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [GlassTheme.primary, GlassTheme.secondary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(storeKit.isLoading)
        .accessibilityLabel("Upgrade to Pro for \(storeKit.proPrice)")
        .accessibilityHint("Unlocks all Pro features including tip calculator, discount calculator, and more")
    }

    private var restoreButton: some View {
        Button {
            Task {
                await storeKit.restorePurchases()
                if storeKit.errorMessage != nil && !storeKit.isPro {
                    showPurchaseError = true
                }
            }
        } label: {
            Text("Restore Purchases")
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.primary)
        }
        .buttonStyle(.plain)
        .disabled(storeKit.isLoading)
        .accessibilityLabel("Restore purchases")
        .accessibilityHint("Restores previously purchased Pro features")
    }

    @MainActor
    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: GlassTheme.spacingSmall) {
            Image(systemName: icon)
                .foregroundStyle(GlassTheme.primary)
                .frame(width: 24)

            Text(text)
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.textSecondary)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        LinearGradient(
            colors: GlassTheme.auroraGradient,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        ProUpgradeSection()
            .padding()
    }
}
