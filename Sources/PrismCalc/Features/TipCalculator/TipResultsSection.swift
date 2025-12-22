import SwiftUI

/// Results display section for tip calculator with save to history
struct TipResultsSection: View {
    let viewModel: TipCalculatorViewModel
    @Binding var noteText: String
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityIncreaseContrast) private var increaseContrast

    var body: some View {
        VStack(spacing: GlassTheme.spacingSmall) {
            // Tip Amount
            resultRow(label: "Tip", value: viewModel.formattedTip)

            // Total
            resultRow(
                label: "Total",
                value: viewModel.formattedTotal,
                isHighlighted: true
            )

            // Per Person (if splitting)
            if viewModel.numberOfPeople > 1 {
                perPersonSection
            }

            // Save Button
            if viewModel.billValue > 0 {
                saveSection
            }
        }
        .padding(GlassTheme.spacingMedium)
        .background(resultsBackground)
        .shadow(color: Color.black.opacity(GlassTheme.glassShadowOpacityPrimary), radius: 15, y: 8)
    }

    // MARK: - Subviews

    @MainActor
    private var perPersonSection: some View {
        Group {
            Divider()
                .background(GlassTheme.textTertiary)

            resultRow(
                label: "Per Person",
                value: viewModel.formattedPerPerson,
                isHighlighted: true
            )

            resultRow(
                label: "Tip Per Person",
                value: viewModel.formattedTipPerPerson
            )
        }
    }

    @MainActor
    private var saveSection: some View {
        Group {
            Divider()
                .background(GlassTheme.textTertiary)

            noteInput

            Button {
                viewModel.saveToHistory(note: noteText.isEmpty ? nil : noteText)
                noteText = ""
            } label: {
                Label("Save to History", systemImage: "clock.arrow.circlepath")
                    .font(GlassTheme.bodyFont)
                    .foregroundStyle(GlassTheme.primary)
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.success, trigger: viewModel.billValue)
            .accessibilityLabel("Save to history")
            .accessibilityHint("Saves this tip calculation to your history")
        }
    }

    @MainActor
    private var noteInput: some View {
        HStack(spacing: GlassTheme.spacingSmall) {
            Image(systemName: "note.text")
                .foregroundStyle(GlassTheme.textTertiary)

            TextField("Add a note (optional)", text: $noteText)
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.text)
                .textFieldStyle(.plain)
                .accessibilityLabel("Note")
                .accessibilityHint("Optional note to save with this calculation")
        }
        .padding(.vertical, GlassTheme.spacingXS)
    }

    private var resultsBackground: some View {
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
    }

    // MARK: - Result Row

    @MainActor
    private func resultRow(
        label: String,
        value: String,
        isHighlighted: Bool = false
    ) -> some View {
        let reduceMotionSnapshot = reduceMotion

        return HStack {
            Text(label)
                .font(GlassTheme.bodyFont)
                .foregroundStyle(GlassTheme.textSecondary)

            Spacer()

            Text(value)
                .font(isHighlighted ? GlassTheme.titleFont : GlassTheme.headlineFont)
                .foregroundStyle(isHighlighted ? GlassTheme.primary : GlassTheme.text)
                .contentTransition(reduceMotionSnapshot ? .identity : .numericText())
                .animation(reduceMotionSnapshot ? nil : .easeInOut(duration: 0.15), value: value)
        }
    }
}
