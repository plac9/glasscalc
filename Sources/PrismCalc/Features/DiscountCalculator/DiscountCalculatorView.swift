import SwiftUI

/// Discount Calculator showing original price, discount %, and savings
public struct DiscountCalculatorView: View {
    @State private var viewModel = DiscountCalculatorViewModel()

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: GlassTheme.spacingLarge) {
                // Original Price Input
                priceInputSection
                    .scrollTransition { content, phase in
                        content.opacity(phase.isIdentity ? 1 : 0.85)
                    }

                // Discount Percentage Arc Slider
                discountSliderSection
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.85)
                            .scaleEffect(phase.isIdentity ? 1 : 0.97)
                    }

                // Quick Discount Buttons
                quickDiscountSection

                // Results with visual savings indicator
                resultsSection
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.9)
                            .offset(y: phase.isIdentity ? 0 : phase.value * 8)
                    }
            }
            .padding()
        }
    }

    // MARK: - Price Input

    @MainActor
    private var priceInputSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GlassTheme.spacingSmall) {
                Text("Original Price")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                HStack {
                    Text("$")
                        .font(.system(size: 32, weight: .light, design: .rounded))
                        .foregroundStyle(GlassTheme.textSecondary)

                    TextField("0.00", text: $viewModel.originalPrice)
                        .font(.system(size: 48, weight: .light, design: .rounded))
                        .decimalKeyboard()
                        .foregroundStyle(GlassTheme.text)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }

    // MARK: - Discount Slider

    private var discountSliderSection: some View {
        GlassCard(material: .ultraThinMaterial) {
            VStack(spacing: GlassTheme.spacingSmall) {
                ArcSlider(
                    value: $viewModel.discountPercentage,
                    range: 0...100,
                    step: 5,
                    label: "OFF"
                )
            }
            .padding(.vertical, GlassTheme.spacingSmall)
        }
    }

    // MARK: - Quick Discounts

    @MainActor
    private var quickDiscountSection: some View {
        HStack(spacing: GlassTheme.spacingSmall) {
            ForEach(viewModel.quickDiscounts, id: \.self) { discount in
                Button {
                    withAnimation(GlassTheme.springAnimation) {
                        viewModel.selectQuickDiscount(discount)
                    }
                } label: {
                    Text("\(Int(discount))%")
                        .font(GlassTheme.bodyFont)
                        .fontWeight(.medium)
                        .foregroundStyle(
                            viewModel.discountPercentage == discount
                                ? .white
                                : GlassTheme.text
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, GlassTheme.spacingSmall)
                        .background(
                            Capsule()
                                .fill(
                                    viewModel.discountPercentage == discount
                                        ? GlassTheme.primary
                                        : .clear
                                )
                                .background(
                                    Capsule()
                                        .fill(.thinMaterial)
                                )
                        )
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.selection, trigger: viewModel.discountPercentage)
            }
        }
    }

    // MARK: - Results

    @MainActor
    private var resultsSection: some View {
        VStack(spacing: GlassTheme.spacingMedium) {
            // Savings Badge
            if viewModel.discountAmount > 0 {
                HStack {
                    Image(systemName: "tag.fill")
                        .foregroundStyle(GlassTheme.success)
                        .symbolEffect(.wiggle, value: viewModel.discountAmount)

                    Text("You Save \(viewModel.formattedDiscount)")
                        .font(GlassTheme.headlineFont)
                        .foregroundStyle(GlassTheme.success)
                }
                .padding(.horizontal, GlassTheme.spacingMedium)
                .padding(.vertical, GlassTheme.spacingSmall)
                .background(
                    Capsule()
                        .fill(GlassTheme.success.opacity(0.15))
                )
                .sensoryFeedback(.success, trigger: viewModel.discountAmount)
            }

            // Price Breakdown
            VStack(spacing: GlassTheme.spacingSmall) {
                // Original Price (strikethrough)
                HStack {
                    Text("Original")
                        .font(GlassTheme.bodyFont)
                        .foregroundStyle(GlassTheme.textSecondary)

                    Spacer()

                    Text(viewModel.formattedOriginal)
                        .font(GlassTheme.bodyFont)
                        .strikethrough(viewModel.discountAmount > 0)
                        .foregroundStyle(GlassTheme.textTertiary)
                }

                // Discount Amount
                HStack {
                    Text("Discount (\(Int(viewModel.discountPercentage))%)")
                        .font(GlassTheme.bodyFont)
                        .foregroundStyle(GlassTheme.textSecondary)

                    Spacer()

                    Text("-\(viewModel.formattedDiscount)")
                        .font(GlassTheme.bodyFont)
                        .foregroundStyle(GlassTheme.success)
                }

                Divider()
                    .background(GlassTheme.textTertiary)

                // Final Price
                HStack {
                    Text("Final Price")
                        .font(GlassTheme.headlineFont)
                        .foregroundStyle(GlassTheme.text)

                    Spacer()

                    Text(viewModel.formattedFinal)
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .foregroundStyle(GlassTheme.primary)
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.15), value: viewModel.finalPrice)
                }

                // Save Button
                if viewModel.priceValue > 0 {
                    Divider()
                        .background(GlassTheme.textTertiary)

                    Button {
                        viewModel.saveToHistory()
                    } label: {
                        Label("Save to History", systemImage: "clock.arrow.circlepath")
                            .font(GlassTheme.bodyFont)
                            .foregroundStyle(GlassTheme.primary)
                    }
                    .buttonStyle(.plain)
                    .sensoryFeedback(.success, trigger: viewModel.priceValue)
                }
            }
            .padding(GlassTheme.spacingMedium)
            .background(
                RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusLarge)
                    .fill(.regularMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusLarge)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.4),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 15, y: 8)
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

        DiscountCalculatorView()
    }
}
