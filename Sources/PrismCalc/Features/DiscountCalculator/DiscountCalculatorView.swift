import SwiftUI

/// Discount Calculator showing original price, discount %, and savings
public struct DiscountCalculatorView: View {
    @State private var viewModel = DiscountCalculatorViewModel()
    // Fixed sizes for calculator displays - should not scale with Dynamic Type
    private let currencySymbolSize: CGFloat = 32
    private let inputValueSize: CGFloat = 48
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityIncreaseContrast) private var increaseContrast
    @FocusState private var isInputFocused: Bool

    public init() {}

    public var body: some View {
        let reduce = reduceMotion

        ScrollView {
            VStack(spacing: GlassTheme.spacingLarge) {
                // Original Price Input
                priceInputSection
                    .scrollTransition(.animated, axis: .vertical) { content, phase in
                        return content.opacity(reduce || phase.isIdentity ? 1 : 0.85)
                    }

                // Discount Percentage Arc Slider
                discountSliderSection
                    .scrollTransition(.animated, axis: .vertical) { content, phase in
                        return content
                            .opacity(reduce || phase.isIdentity ? 1 : 0.85)
                            .scaleEffect(reduce || phase.isIdentity ? 1 : 0.97)
                    }

                // Quick Discount Buttons
                quickDiscountSection

                // Results with visual savings indicator
                resultsSection
                    .scrollTransition(.animated, axis: .vertical) { content, phase in
                        return content
                            .opacity(reduce || phase.isIdentity ? 1 : 0.9)
                            .offset(y: reduce || phase.isIdentity ? 0 : phase.value * 8)
                    }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isInputFocused = false
                }
                .foregroundStyle(GlassTheme.primary)
            }
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
                        .font(.system(size: currencySymbolSize, weight: .light, design: .rounded))
                        .foregroundStyle(GlassTheme.textSecondary)

                    TextField("0.00", text: $viewModel.originalPrice)
                        .font(.system(size: inputValueSize, weight: .light, design: .rounded))
                        .decimalKeyboard()
                        .foregroundStyle(GlassTheme.text)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .multilineTextAlignment(.trailing)
                        .focused($isInputFocused)
                        .accessibilityLabel("Original price")
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
            let reduceMotionSnapshot = reduceMotion
            ForEach(viewModel.quickDiscounts, id: \.self) { discount in
                Button {
                    if reduceMotionSnapshot {
                        viewModel.selectQuickDiscount(discount)
                    } else {
                        withAnimation(GlassTheme.springAnimation) {
                            viewModel.selectQuickDiscount(discount)
                        }
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
                .accessibilityLabel("\(Int(discount)) percent discount")
                .accessibilityHint(
                    viewModel.discountPercentage == discount ? "Currently selected" : "Double tap to select"
                )
            }
        }
    }

    // MARK: - Results

    @MainActor
    private var resultsSection: some View {
        VStack(spacing: GlassTheme.spacingMedium) {
            let reduceMotionSnapshot = reduceMotion

            // Savings Badge
            if viewModel.discountAmount > 0 {
                HStack {
                    savingsTagIcon
                        .foregroundStyle(GlassTheme.success)

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
                        .contentTransition(reduceMotionSnapshot ? .identity : .numericText())
                        .animation(reduceMotionSnapshot ? nil : .easeInOut(duration: 0.15), value: viewModel.finalPrice)
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
                    .accessibilityLabel("Save to history")
                    .accessibilityHint("Saves this discount calculation to your history")
                }
            }
            .padding(GlassTheme.spacingMedium)
            .background(
                GlassTheme.glassCardBackground(
                    cornerRadius: GlassTheme.cornerRadiusLarge,
                    material: .regularMaterial,
                    reduceTransparency: reduceTransparency
                )
                    .overlay(
                        RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusLarge)
                            .stroke(
                                GlassTheme.glassBorderGradient(
                                    reduceTransparency: reduceTransparency,
                                    increaseContrast: increaseContrast
                                ),
                                lineWidth: GlassTheme.glassBorderLineWidth(
                                    reduceTransparency: reduceTransparency,
                                    increaseContrast: increaseContrast
                                )
                            )
                    )
            )
            .shadow(color: Color.black.opacity(GlassTheme.glassShadowOpacityPrimary), radius: 15, y: 8)
        }
    }

    // MARK: - Savings Tag Icon (Reduce Motion Support)

    @MainActor @ViewBuilder
    private var savingsTagIcon: some View {
        if reduceMotion {
            Image(systemName: "tag.fill")
        } else {
            Image(systemName: "tag.fill")
                .symbolEffect(.wiggle, value: viewModel.discountAmount)
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
