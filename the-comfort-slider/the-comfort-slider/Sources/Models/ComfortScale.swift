import Foundation

/// Maps the 0...100 comfort slider onto a debt-to-income fraction with a
/// deliberate non-linear "stretch": the first half of the slider spans a
/// sensible 0–20% of income, while the second half ramps through the reckless
/// 20–100%. This gives fine control in the range people actually live in and
/// lets the slider still reach the full 0–100% of income.
struct ComfortScale {
    /// Raw slider position, 0...100.
    let sliderValue: Double

    /// Debt-to-income fraction (0...1) the slider maps to, snapped to whole
    /// percentage points. Quantising here — rather than only when displaying —
    /// guarantees the number shown ("14%") and the number driving the math are
    /// always the same: the slider can never rest on a hidden 14.5%.
    var dtiFraction: Double {
        (rawDTIFraction * 100).rounded() / 100
    }

    /// The underlying continuous mapping before it is snapped to whole percents.
    private var rawDTIFraction: Double {
        let position = min(max(sliderValue / Constants.sliderMax, 0), 1)
        if position <= Constants.midpoint {
            return position / Constants.midpoint * Constants.midpointDTI
        }
        let upperProgress = (position - Constants.midpoint) / (1 - Constants.midpoint)
        return Constants.midpointDTI + upperProgress * (1 - Constants.midpointDTI)
    }

    /// A 0% share of income would require infinite money, so it is impossible.
    var isAffordable: Bool {
        dtiFraction > 0
    }

    var zone: ComfortZone {
        ComfortZone(dtiFraction: dtiFraction)
    }

    var dtiLabel: String {
        dtiFraction.formatted(.percent.precision(.fractionLength(0)))
    }

    /// Inverse of `dtiFraction`: given a debt-to-income fraction, returns the
    /// 0...100 slider position that would land on it. Used to move the slider so
    /// it reflects a fixed salary as the price changes.
    static func sliderValue(forDTI dti: Double) -> Double {
        let clamped = min(max(dti, 0), 1)
        let position: Double
        if clamped <= Constants.midpointDTI {
            position = clamped / Constants.midpointDTI * Constants.midpoint
        } else {
            position = Constants.midpoint + (clamped - Constants.midpointDTI) / (1 - Constants.midpointDTI) * (1 - Constants.midpoint)
        }
        return position * Constants.sliderMax
    }
}

private enum Constants {
    static let sliderMax = 100.0
    static let midpoint = 0.5
    static let midpointDTI = 0.20
}
