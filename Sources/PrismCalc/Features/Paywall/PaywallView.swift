import SwiftUI

/// Paywall view shown when accessing Pro features without purchase
public struct PaywallView: View {
    @State private var showPurchaseError = false
    @State private var purchaseSuccess = false
    private var storeKit: StoreKitManager { StoreKitManager.shared }
    @ScaledMetric(relativeTo: .largeTitle) private var heroIconSize: CGFloat = 64

    public let featureName: String
    public let featureIcon: String

    public init(featureName: String, featureIcon: String) {
        self.featureName = featureName
        self.featureIcon = featureIcon
    }

    public var body: some View {
        VStack(spacing: GlassTheme.spacingLarge) {
            Spacer()

            // Feature icon
            Image(systemName: featureIcon)
                .font(.system(size: heroIconSize))
                .foregroundStyle(
                    LinearGradient(
                        colors: [GlassTheme.primary, GlassTheme.secondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding(.bottom, GlassTheme.spacingSmall)
                .accessibilityHidden(true) // Icon is decorative, text provides context

            // Title
            Text(featureName)
                .font(GlassTheme.titleFont)
                .foregroundStyle(GlassTheme.text)

            Text("This is a Pro feature")
                .font(GlassTheme.bodyFont)
                .foregroundStyle(GlassTheme.textSecondary)

            Spacer()

            // Pro benefits
            GlassCard {
                VStack(alignment: .leading, spacing: GlassTheme.spacingSmall) {
                    Text("Unlock PrismCalc Pro")
                        .font(GlassTheme.headlineFont)
                        .foregroundStyle(GlassTheme.text)

                    VStack(alignment: .leading, spacing: GlassTheme.spacingXS) {
                        benefitRow(icon: "percent", text: "Tip Calculator")
                        benefitRow(icon: "tag", text: "Discount Calculator")
                        benefitRow(icon: "person.2", text: "Split Bill")
                        benefitRow(icon: "arrow.left.arrow.right", text: "Unit Converter")
                        benefitRow(icon: "paintpalette", text: "All 6 Premium Themes")
                        benefitRow(icon: "clock.arrow.circlepath", text: "History with lock/unlock entries")
                    }
                }
            }

            // Purchase button
            Button {
                Task {
                    do {
                        try await storeKit.purchase()
                        purchaseSuccess = true
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
                .font(GlassTheme.headlineFont)
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
                .shadow(color: GlassTheme.primary.opacity(0.4), radius: 12, y: 6)
            }
            .buttonStyle(.plain)
            .disabled(storeKit.isLoading)
            .accessibilityIdentifier("paywall-upgrade-button")
            .accessibilityLabel("Upgrade to PrismCalc Pro for \(storeKit.proPrice)")
            .accessibilityHint("Unlocks all calculators, themes, and history with lock/unlock entries")
            .padding(.horizontal)

            // Restore button
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
                    .foregroundStyle(GlassTheme.textSecondary)
            }
            .buttonStyle(.plain)
            .disabled(storeKit.isLoading)
            .accessibilityIdentifier("paywall-restore-button")
            .accessibilityLabel("Restore previous purchases")
            .accessibilityHint("Restores Pro features if previously purchased")

            Spacer()
        }
        .padding()
        .sensoryFeedback(.success, trigger: purchaseSuccess)
        .sensoryFeedback(.error, trigger: showPurchaseError)
        .alert("Purchase Error", isPresented: $showPurchaseError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(storeKit.errorMessage ?? "An error occurred")
        }
    }

    @MainActor
    private func benefitRow(icon: String, text: String) -> some View {
        HStack(spacing: GlassTheme.spacingSmall) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(GlassTheme.success)
                .font(.caption)

            Image(systemName: icon)
                .foregroundStyle(GlassTheme.primary)
                .frame(width: 20)

            Text(text)
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.text)
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

        PaywallView(featureName: "Tip Calculator", featureIcon: "dollarsign.circle")
    }
}
