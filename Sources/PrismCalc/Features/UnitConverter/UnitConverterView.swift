import SwiftUI

/// Unit Converter with length, weight, temperature, and currency
public struct UnitConverterView: View {
    @State private var viewModel = UnitConverterViewModel()
    @State private var currencyResult: Double?
    @State private var isConverting: Bool = false

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: GlassTheme.spacingLarge) {
                // Category Selector
                categorySelector

                // Input
                inputSection

                // Unit Selectors with Swap
                unitSelectors

                // Result
                resultSection
            }
            .padding()
        }
        .task {
            if viewModel.selectedCategory == .currency {
                await viewModel.loadCurrencies()
            }
        }
    }

    // MARK: - Category Selector

    @MainActor
    private var categorySelector: some View {
        HStack(spacing: GlassTheme.spacingSmall) {
            ForEach(UnitConverterViewModel.Category.allCases) { category in
                Button {
                    withAnimation(GlassTheme.springAnimation) {
                        viewModel.selectCategory(category)
                        currencyResult = nil
                    }
                } label: {
                    VStack(spacing: GlassTheme.spacingXS) {
                        Image(systemName: category.icon)
                            .font(.title2)

                        Text(category.rawValue)
                            .font(GlassTheme.captionFont)
                    }
                    .foregroundStyle(
                        viewModel.selectedCategory == category
                            ? .white
                            : GlassTheme.text
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, GlassTheme.spacingSmall)
                    .background(
                        RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusSmall)
                            .fill(
                                viewModel.selectedCategory == category
                                    ? GlassTheme.primary
                                    : .clear
                            )
                            .background(
                                RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusSmall)
                                    .fill(.thinMaterial)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .sensoryFeedback(.selection, trigger: viewModel.selectedCategory)
    }

    // MARK: - Input

    @MainActor
    private var inputSection: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: GlassTheme.spacingSmall) {
                Text("Value")
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                TextField("0", text: $viewModel.inputValue)
                    .font(.system(size: 48, weight: .light, design: .rounded))
                    .decimalKeyboard()
                    .foregroundStyle(GlassTheme.text)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: viewModel.inputValue) {
                        if viewModel.selectedCategory == .currency {
                            Task { await convertCurrency() }
                        }
                    }
            }
        }
    }

    // MARK: - Unit Selectors

    @MainActor
    private var unitSelectors: some View {
        HStack(spacing: GlassTheme.spacingSmall) {
            // From Unit
            unitPicker(
                label: "From",
                selection: $viewModel.fromUnit,
                units: viewModel.availableUnits
            )

            // Swap Button
            Button {
                withAnimation(GlassTheme.springAnimation) {
                    viewModel.swapUnits()
                    if viewModel.selectedCategory == .currency {
                        Task { await convertCurrency() }
                    }
                }
            } label: {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.title3)
                    .foregroundStyle(GlassTheme.primary)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(.regularMaterial)
                    )
            }
            .buttonStyle(.plain)

            // To Unit
            unitPicker(
                label: "To",
                selection: $viewModel.toUnit,
                units: viewModel.availableUnits
            )
        }
        .onChange(of: viewModel.fromUnit) {
            if viewModel.selectedCategory == .currency {
                Task { await convertCurrency() }
            }
        }
        .onChange(of: viewModel.toUnit) {
            if viewModel.selectedCategory == .currency {
                Task { await convertCurrency() }
            }
        }
    }

    @MainActor
    private func unitPicker(label: String, selection: Binding<String>, units: [String]) -> some View {
        GlassCard {
            VStack(spacing: GlassTheme.spacingXS) {
                Text(label)
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                Picker(label, selection: selection) {
                    ForEach(units, id: \.self) { unit in
                        Text(formatUnitName(unit))
                            .tag(unit)
                    }
                }
                .pickerStyle(.menu)
                .tint(GlassTheme.primary)
            }
        }
    }

    // MARK: - Result

    @MainActor
    private var resultSection: some View {
        VStack(spacing: GlassTheme.spacingSmall) {
            if viewModel.isLoadingCurrencies || isConverting {
                ProgressView()
                    .tint(GlassTheme.primary)
            } else if let error = viewModel.currencyError {
                Text(error)
                    .font(GlassTheme.captionFont)
                    .foregroundStyle(GlassTheme.error)
            } else {
                Text(displayResult)
                    .font(.system(size: 48, weight: .medium, design: .rounded))
                    .foregroundStyle(GlassTheme.primary)
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.15), value: displayResult)

                Text(formatUnitName(viewModel.toUnit))
                    .font(GlassTheme.headlineFont)
                    .foregroundStyle(GlassTheme.textSecondary)

                // Save Button
                if viewModel.inputDouble > 0 {
                    Button {
                        viewModel.saveToHistory(result: displayResult)
                    } label: {
                        Label("Save to History", systemImage: "clock.arrow.circlepath")
                            .font(GlassTheme.bodyFont)
                            .foregroundStyle(GlassTheme.primary)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, GlassTheme.spacingSmall)
                    .sensoryFeedback(.success, trigger: viewModel.inputDouble)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(GlassTheme.spacingXL)
        .background(
            RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusXL)
                .fill(.regularMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusXL)
                        .stroke(GlassTheme.primary.opacity(0.3), lineWidth: 2)
                )
        )
        .shadow(color: GlassTheme.primary.opacity(0.2), radius: 20, y: 10)
    }

    private var displayResult: String {
        if viewModel.selectedCategory == .currency {
            let value = currencyResult ?? 0
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            return formatter.string(from: NSNumber(value: value)) ?? "0.00"
        }
        return viewModel.formattedResult
    }

    // MARK: - Helpers

    private func formatUnitName(_ unit: String) -> String {
        if viewModel.selectedCategory == .currency {
            if let currency = viewModel.currencies.first(where: { $0.code == unit }) {
                return "\(currency.flag) \(currency.code)"
            }
            return unit
        }
        return unit.capitalized
    }

    private func convertCurrency() async {
        guard viewModel.selectedCategory == .currency,
              viewModel.inputDouble > 0 else {
            currencyResult = 0
            return
        }

        isConverting = true

        do {
            currencyResult = try await CurrencyService.shared.convert(
                amount: viewModel.inputDouble,
                from: viewModel.fromUnit,
                to: viewModel.toUnit
            )
        } catch {
            viewModel.currencyError = error.localizedDescription
        }

        isConverting = false
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

        UnitConverterView()
    }
}
