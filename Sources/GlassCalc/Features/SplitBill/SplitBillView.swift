import SwiftUI

/// Split Bill Calculator - divide bills among friends with optional tip
public struct SplitBillView: View {
    @State private var viewModel = SplitBillViewModel()

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: GlassTheme.spacingLarge) {
                // Total Bill Input
                billInputSection

                // Number of People
                peopleSection

                // Tip Toggle and Slider
                tipSection

                // Results
                resultsSection
            }
            .padding()
        }
    }

    // MARK: - Bill Input

    @MainActor
    private var billInputSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GlassTheme.spacingSmall) {
                Text("Total Bill")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                HStack {
                    Text("$")
                        .font(.system(size: 32, weight: .light, design: .rounded))
                        .foregroundStyle(GlassTheme.textSecondary)

                    TextField("0.00", text: $viewModel.totalBill)
                        .font(.system(size: 48, weight: .light, design: .rounded))
                        .decimalKeyboard()
                        .foregroundStyle(GlassTheme.text)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }

    // MARK: - People Section

    @MainActor
    private var peopleSection: some View {
        GlassCard {
            VStack(spacing: GlassTheme.spacingMedium) {
                Text("Split Between")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                HStack(spacing: GlassTheme.spacingXL) {
                    // Decrement
                    Button {
                        viewModel.decrementPeople()
                    } label: {
                        Image(systemName: "minus")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(
                                viewModel.numberOfPeople > 1
                                    ? GlassTheme.text
                                    : GlassTheme.textTertiary
                            )
                            .frame(width: 56, height: 56)
                            .background(
                                Circle()
                                    .fill(.thinMaterial)
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.numberOfPeople <= 1)

                    // People Count with Icons
                    VStack(spacing: GlassTheme.spacingXS) {
                        HStack(spacing: 4) {
                            ForEach(0..<min(viewModel.numberOfPeople, 5), id: \.self) { _ in
                                Image(systemName: "person.fill")
                                    .foregroundStyle(GlassTheme.primary)
                            }
                            if viewModel.numberOfPeople > 5 {
                                Text("+\(viewModel.numberOfPeople - 5)")
                                    .font(GlassTheme.captionFont)
                                    .foregroundStyle(GlassTheme.primary)
                            }
                        }

                        Text("\(viewModel.numberOfPeople)")
                            .font(.system(size: 56, weight: .light, design: .rounded))
                            .foregroundStyle(GlassTheme.text)
                            .contentTransition(.numericText())
                            .animation(.easeInOut(duration: 0.15), value: viewModel.numberOfPeople)

                        Text(viewModel.numberOfPeople == 1 ? "person" : "people")
                            .font(GlassTheme.captionFont)
                            .foregroundStyle(GlassTheme.textSecondary)
                    }

                    // Increment
                    Button {
                        viewModel.incrementPeople()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(GlassTheme.text)
                            .frame(width: 56, height: 56)
                            .background(
                                Circle()
                                    .fill(.thinMaterial)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .sensoryFeedback(.selection, trigger: viewModel.numberOfPeople)
            }
        }
    }

    // MARK: - Tip Section

    @MainActor
    private var tipSection: some View {
        GlassCard(material: .ultraThinMaterial) {
            VStack(spacing: GlassTheme.spacingMedium) {
                // Toggle
                HStack {
                    Text("Include Tip")
                        .font(GlassTheme.bodyFont)
                        .foregroundStyle(GlassTheme.text)

                    Spacer()

                    Toggle("", isOn: $viewModel.includeTip)
                        .tint(GlassTheme.primary)
                        .labelsHidden()
                }

                // Tip Slider (when enabled)
                if viewModel.includeTip {
                    VStack(spacing: GlassTheme.spacingSmall) {
                        HStack {
                            Text("Tip: \(Int(viewModel.tipPercentage))%")
                                .font(GlassTheme.captionFont)
                                .foregroundStyle(GlassTheme.textSecondary)

                            Spacer()

                            Text(viewModel.formattedTip)
                                .font(GlassTheme.bodyFont)
                                .foregroundStyle(GlassTheme.primary)
                        }

                        Slider(
                            value: $viewModel.tipPercentage,
                            in: 0...30,
                            step: 1
                        )
                        .tint(GlassTheme.primary)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .animation(GlassTheme.springAnimation, value: viewModel.includeTip)
        }
    }

    // MARK: - Results

    @MainActor
    private var resultsSection: some View {
        VStack(spacing: GlassTheme.spacingMedium) {
            // Per Person (Hero)
            VStack(spacing: GlassTheme.spacingXS) {
                Text("Each Person Pays")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                Text(viewModel.formattedPerPerson)
                    .font(.system(size: 56, weight: .medium, design: .rounded))
                    .foregroundStyle(GlassTheme.primary)
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.15), value: viewModel.perPersonShare)
            }
            .frame(maxWidth: .infinity)
            .padding(GlassTheme.spacingLarge)
            .background(
                RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusXL)
                    .fill(.regularMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusXL)
                            .stroke(GlassTheme.primary.opacity(0.3), lineWidth: 2)
                    )
            )
            .shadow(color: GlassTheme.primary.opacity(0.2), radius: 20, y: 10)

            // Breakdown
            GlassCard {
                VStack(spacing: GlassTheme.spacingSmall) {
                    breakdownRow(label: "Bill", value: viewModel.formattedBill)

                    if viewModel.includeTip {
                        breakdownRow(label: "Tip (\(Int(viewModel.tipPercentage))%)", value: viewModel.formattedTip)
                    }

                    Divider()
                        .background(GlassTheme.textTertiary)

                    breakdownRow(
                        label: "Grand Total",
                        value: viewModel.formattedGrandTotal,
                        isHighlighted: true
                    )

                    // Save Button
                    if viewModel.billValue > 0 {
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
                        .sensoryFeedback(.success, trigger: viewModel.billValue)
                    }
                }
            }
        }
    }

    @MainActor
    private func breakdownRow(label: String, value: String, isHighlighted: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(GlassTheme.bodyFont)
                .foregroundStyle(GlassTheme.textSecondary)

            Spacer()

            Text(value)
                .font(isHighlighted ? GlassTheme.headlineFont : GlassTheme.bodyFont)
                .foregroundStyle(isHighlighted ? GlassTheme.text : GlassTheme.textSecondary)
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

        SplitBillView()
    }
}
