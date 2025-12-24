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
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    private let arcRadius: CGFloat = 100
    private let trackWidth: CGFloat = 24
    private let thumbSize: CGFloat = 44

    /// Normalized percentage (0...1) clamped to prevent arc overflow
    private var normalizedPercentage: Double {
        let rangeSpan = range.upperBound - range.lowerBound
        guard rangeSpan > 0 else { return 0 }
        let raw = (value - range.lowerBound) / rangeSpan
        return min(1.0, max(0.0, raw))
    }

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
        GeometryReader { geometry in
            let frameHeight = arcRadius + thumbSize + 30
            let arcCenter = CGPoint(x: geometry.size.width / 2, y: frameHeight)

            ZStack {
                arcTrack
                arcFill
                thumbView(arcCenter: arcCenter, frameWidth: geometry.size.width)
                centerDisplay
            }
            .frame(width: geometry.size.width, height: frameHeight)
            .coordinateSpace(name: "arcSlider")
        }
        .frame(height: arcRadius + thumbSize + 30)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
        .accessibilityValue(valueFormatter(value))
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                value = min(value + step, range.upperBound)
            case .decrement:
                value = max(value - step, range.lowerBound)
            @unknown default:
                break
            }
        }
    }

    @MainActor
    private var arcTrack: some View {
        // Subtle track without material background for seamless look
        ArcShape(startAngle: .degrees(180), endAngle: .degrees(0), radius: arcRadius)
            .stroke(GlassTheme.text.opacity(0.15), lineWidth: trackWidth)
            .overlay {
                ArcShape(startAngle: .degrees(180), endAngle: .degrees(0), radius: arcRadius)
                    .stroke(GlassTheme.primary.opacity(0.3), lineWidth: 1)
            }
    }

    @MainActor
    private var arcFill: some View {
        // Use trim() to draw partial arc - this ensures correct direction regardless of percentage
        // trim(from: 0, to: 1) = full semicircle, trim(from: 0, to: 0.5) = half of semicircle
        ArcShape(startAngle: .degrees(180), endAngle: .degrees(0), radius: arcRadius)
            .trim(from: 0, to: normalizedPercentage)
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
    private func thumbView(arcCenter: CGPoint, frameWidth: CGFloat) -> some View {
        // Use clamped percentage to keep thumb on the semicircle
        let angle = 180 - (180 * normalizedPercentage)
        let radians = angle * .pi / 180
        let thumbX = arcRadius * cos(radians)
        let thumbY = -arcRadius * sin(radians)

        return GlassTheme.glassCircleBackground(
            material: .regular,
            reduceTransparency: reduceTransparency
        )
        .overlay {
            Circle()
                .strokeBorder(GlassTheme.primary, lineWidth: 3)
        }
            .frame(width: thumbSize, height: thumbSize)
            .shadow(color: GlassTheme.primary.opacity(0.4), radius: 10, y: 4)
            .offset(x: thumbX, y: thumbY)
            .scaleEffect(isDragging ? 1.1 : 1.0)
            .animation(reduceMotion ? nil : GlassTheme.buttonSpring, value: isDragging)
            .gesture(
                DragGesture(coordinateSpace: .named("arcSlider"))
                    .onChanged { gesture in
                        handleDrag(gesture, arcCenter: arcCenter, frameWidth: frameWidth)
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
    }

    @MainActor
    private var centerDisplay: some View {
        // Center display without background for seamless integration
        VStack(spacing: GlassTheme.spacingXS) {
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(GlassTheme.textSecondary)

            Text(valueFormatter(value))
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(GlassTheme.primary)
                .contentTransition(reduceMotion ? .identity : .numericText())
                .animation(reduceMotion ? nil : .easeInOut(duration: 0.1), value: value)
        }
        .padding(GlassTheme.spacingSmall)
        .offset(y: 20)
    }

    private func handleDrag(_ gesture: DragGesture.Value, arcCenter: CGPoint, frameWidth: CGFloat) {
        isDragging = true

        let touchPoint = gesture.location

        // Calculate vector from arc center to touch point
        let vector = CGPoint(
            x: touchPoint.x - arcCenter.x,
            y: touchPoint.y - arcCenter.y
        )

        // Calculate angle from the arc center
        // atan2 gives angle from positive X axis
        var angle = atan2(-vector.y, vector.x) * 180 / .pi

        // Handle touches below the arc (vector.y > 0 means below center in screen coords)
        // Clamp to nearest edge: left side (180°/0%) or right side (0°/100%)
        if vector.y > 0 {
            // Below the arc - snap to nearest edge
            angle = vector.x < 0 ? 180 : 0
        } else {
            // Above the arc - clamp to valid range
            angle = max(0, min(180, angle))
        }

        // Convert angle to percentage (180° = 0%, 0° = 100%)
        let newPercentage = (180 - angle) / 180
        let rawValue = range.lowerBound + (newPercentage * (range.upperBound - range.lowerBound))
        let steppedValue = (rawValue / step).rounded() * step
        let clampedValue = min(max(steppedValue, range.lowerBound), range.upperBound)

        // Only update if value changed by at least half a step (reduces jitter)
        let minChange = step * 0.5
        if abs(clampedValue - value) >= minChange {
            triggerHaptic()
            if reduceMotion {
                value = clampedValue
            } else {
                // Slower, smoother animation for less jumpy feel
                withAnimation(.easeOut(duration: 0.15)) {
                    value = clampedValue
                }
            }
        }
    }

    private func triggerHaptic() {
        #if os(iOS) && !targetEnvironment(macCatalyst)
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
