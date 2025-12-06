import SwiftUI

/// Curved arc slider with glassmorphic design
///
/// Perfect for tip percentage, discount rates, or any percentage-based input.
/// Features haptic feedback, smooth animations, and center value display.
public struct ArcSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let label: String
    let valueFormatter: (Double) -> String

    @State private var isDragging: Bool = false

    private let arcRadius: CGFloat = 100
    private let trackWidth: CGFloat = 24
    private let thumbSize: CGFloat = 44

    public init(
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double = 1,
        label: String,
        valueFormatter: @escaping (Double) -> String = { "\(Int($0))%" }
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.label = label
        self.valueFormatter = valueFormatter
    }

    public var body: some View {
        ZStack {
            arcTrack
            arcFill
            thumb
            centerDisplay
        }
        .frame(height: arcRadius + thumbSize + 30)
    }

    @MainActor
    private var arcTrack: some View {
        ArcShape(startAngle: .degrees(180), endAngle: .degrees(0), radius: arcRadius)
            .stroke(.ultraThinMaterial, lineWidth: trackWidth)
            .overlay {
                ArcShape(startAngle: .degrees(180), endAngle: .degrees(0), radius: arcRadius)
                    .stroke(GlassTheme.primary.opacity(0.2), lineWidth: 1)
            }
    }

    @MainActor
    private var arcFill: some View {
        let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        let endAngle = 180 - (180 * percentage)

        return ArcShape(
            startAngle: .degrees(180),
            endAngle: .degrees(endAngle),
            radius: arcRadius
        )
        .stroke(
            LinearGradient(
                colors: [GlassTheme.primary, GlassTheme.secondary],
                startPoint: .leading,
                endPoint: .trailing
            ),
            lineWidth: trackWidth
        )
    }

    @MainActor
    private var thumb: some View {
        let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        let angle = 180 - (180 * percentage)
        let radians = angle * .pi / 180
        let x = arcRadius * cos(radians)
        let y = -arcRadius * sin(radians)

        return Circle()
            .fill(.regularMaterial)
            .overlay {
                Circle()
                    .strokeBorder(GlassTheme.primary, lineWidth: 3)
            }
            .frame(width: thumbSize, height: thumbSize)
            .shadow(color: GlassTheme.primary.opacity(0.4), radius: 10, y: 4)
            .offset(x: x, y: y)
            .scaleEffect(isDragging ? 1.1 : 1.0)
            .animation(GlassTheme.buttonSpring, value: isDragging)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        handleDrag(gesture)
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
    }

    @MainActor
    private var centerDisplay: some View {
        VStack(spacing: GlassTheme.spacingXS) {
            Text(label)
                .font(GlassTheme.captionFont)
                .foregroundStyle(GlassTheme.textSecondary)

            Text(valueFormatter(value))
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundStyle(GlassTheme.primary)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.1), value: value)
        }
        .padding(GlassTheme.spacingSmall)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: GlassTheme.cornerRadiusSmall))
        .offset(y: 20)
    }

    private func handleDrag(_ gesture: DragGesture.Value) {
        isDragging = true

        let center = CGPoint(x: 0, y: 0)
        let vector = CGPoint(
            x: gesture.location.x - center.x,
            y: gesture.location.y - center.y
        )

        var angle = atan2(vector.y, vector.x) * 180 / .pi
        angle = 180 - angle
        angle = max(0, min(180, angle))

        let percentage = angle / 180
        let rawValue = range.lowerBound + (percentage * (range.upperBound - range.lowerBound))
        let steppedValue = (rawValue / step).rounded() * step
        let clampedValue = min(max(steppedValue, range.lowerBound), range.upperBound)

        if clampedValue != value {
            triggerHaptic()
            withAnimation(.interactiveSpring(response: 0.2, dampingFraction: 0.8)) {
                value = clampedValue
            }
        }
    }

    private func triggerHaptic() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }
}

// MARK: - Arc Shape

struct ArcShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.maxY)

        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )

        return path
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

        ArcSlider(
            value: .constant(18),
            range: 0...30,
            step: 1,
            label: "TIP"
        )
        .padding()
    }
}
