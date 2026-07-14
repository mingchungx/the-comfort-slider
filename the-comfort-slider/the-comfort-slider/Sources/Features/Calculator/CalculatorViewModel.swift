import Foundation
import Observation

@MainActor
@Observable
final class CalculatorViewModel {
    var priceText = "" {
        didSet {
            let sanitized = AmountSanitizer.sanitize(priceText)
            if priceText != sanitized {
                priceText = sanitized
            }
        }
    }
    var aprPercent = 7.5
    var downPaymentPercent = 0
    var taxPercent = 0.0
    var termMonths = 60
    var sliderValue = 50.0 {
        didSet {
            if let salaryAnchor, abs(sliderValue - salaryAnchor) > Constants.anchorEpsilon {
                self.salaryAnchor = nil
                followsDefaultSalary = false
            }
            throttleSliderCommit()
        }
    }

    var taxEnabled = false
    var defaultSalary: Decimal?

    private(set) var committedSliderValue = 50.0
    private(set) var roast = ""
    private(set) var rerollTick = 0

    private let calculator = AffordabilityCalculator()
    private let roastProvider = RoastProvider()
    private var roastedZone: ComfortZone?
    private var sliderCommitTask: Task<Void, Never>?
    private var lastSliderCommit = Date.distantPast
    private var salaryAnchor: Double?
    private var followsDefaultSalary = false

    var zone: ComfortZone {
        ComfortScale(sliderValue: committedSliderValue).zone
    }

    var result: AffordabilityResult? {
        guard let taxedPrice, taxedPrice > .zero else { return nil }
        let base = calculator.result(
            totalPrice: taxedPrice,
            downPaymentPercent: downPaymentPercent,
            annualRatePercent: aprPercent,
            months: termMonths,
            sliderValue: committedSliderValue
        )
        // While the slider is anchored to the default salary, show that exact
        // salary rather than the value implied by the whole-percent DTI.
        guard salaryAnchor != nil, let defaultSalary else { return base }
        return base.withRequiredIncome(defaultSalary)
    }

    /// The monthly payment, independent of the comfort slider — used to reposition
    /// the slider against a fixed salary without feeding back on itself.
    var monthly: Decimal? {
        result?.monthlyPayment
    }

    /// Price plus sales tax (when enabled). Everything downstream — down payment,
    /// financing, interest — is computed from this out-the-door total.
    var taxedPrice: Decimal? {
        guard let price else { return nil }
        guard taxEnabled else { return price }
        return price * (1 + Decimal(taxPercent) / 100)
    }

    var downPaymentAmount: Decimal {
        guard let taxedPrice else { return .zero }
        return taxedPrice * Decimal(downPaymentPercent) / 100
    }

    var taxAmount: Decimal {
        guard let price, taxEnabled else { return .zero }
        return price * Decimal(taxPercent) / 100
    }

    var totalInterest: Decimal {
        result?.totalInterest ?? .zero
    }

    var canDecreaseAPR: Bool { aprPercent > 0 }
    var canIncreaseDownPayment: Bool { downPaymentPercent < Constants.percentMax }
    var canDecreaseDownPayment: Bool { downPaymentPercent > 0 }
    var canIncreaseTax: Bool { taxPercent < Constants.taxMax }
    var canDecreaseTax: Bool { taxPercent > 0 }

    func increaseAPR() { aprPercent = normalizedAPR(aprPercent + Constants.aprStep) }
    func decreaseAPR() { aprPercent = normalizedAPR(max(0, aprPercent - Constants.aprStep)) }
    func increaseDownPayment() { downPaymentPercent = min(Constants.percentMax, downPaymentPercent + Constants.percentStep) }
    func decreaseDownPayment() { downPaymentPercent = max(0, downPaymentPercent - Constants.percentStep) }
    func increaseTax() { taxPercent = min(Constants.taxMax, taxPercent + Constants.taxStep) }
    func decreaseTax() { taxPercent = max(0, taxPercent - Constants.taxStep) }

    /// Moves the slider so its comfort level reflects the fixed default salary at
    /// the current monthly payment. Called when the price or financing changes,
    /// never on a manual drag, so the user can still override the slider.
    /// Called when the default salary itself changes: (re)locks the slider onto
    /// it, so the slider always reflects that fixed salary.
    func lockToDefaultSalary() {
        followsDefaultSalary = defaultSalary != nil
        repositionToDefaultSalary()
    }

    /// Called when the payment changes: only moves the slider while it is still
    /// locked to the default salary. Once you've dragged off, your chosen
    /// percentage stays put and price/financing changes leave it alone.
    func syncSliderIfFollowing() {
        guard followsDefaultSalary else { return }
        repositionToDefaultSalary()
    }

    func refreshRoastIfNeeded() {
        guard zone != roastedZone else { return }
        roastedZone = zone
        roast = roastProvider.roast(for: zone)
    }

    func rerollRoast() {
        roast = roastProvider.roast(for: zone)
        rerollTick += 1
    }
}

private extension CalculatorViewModel {
    var price: Decimal? {
        let cleaned = priceText.trimmingCharacters(in: .whitespaces)
        guard !cleaned.isEmpty else { return nil }
        return Decimal(string: cleaned)
    }

    /// Snaps the APR to whole cents so repeated 0.01 steps never drift into
    /// floating-point noise like 7.500000001.
    func normalizedAPR(_ value: Double) -> Double {
        (value * 100).rounded() / 100
    }

    /// Positions the slider so its comfort level reflects the default salary at
    /// the current monthly payment. No-ops (clearing the anchor) until both a
    /// salary and a payment exist, while staying in follow mode.
    func repositionToDefaultSalary() {
        guard followsDefaultSalary, let defaultSalary, defaultSalary > .zero, let monthly, monthly > .zero else {
            salaryAnchor = nil
            return
        }
        let annualPayment = (monthly as NSDecimalNumber).doubleValue * 12
        let salary = (defaultSalary as NSDecimalNumber).doubleValue
        let position = ComfortScale.sliderValue(forDTI: annualPayment / salary)
        salaryAnchor = position
        sliderValue = position
    }

    /// Throttles slider-driven recalculation so the expensive work — the
    /// `result` recompute plus every effect keyed off the resulting `zone`
    /// (spray change-effects, haptics, roast) — fires at most once per
    /// `sliderThrottle` while the slider is moving, rather than on every pixel.
    /// This keeps the readout updating live during a drag while capping how fast
    /// the spray animations can pile up. The thumb stays perfectly smooth because
    /// it is bound to `sliderValue`; only the derived `committedSliderValue` is
    /// gated, and a trailing commit guarantees the final resting value is exact.
    func throttleSliderCommit() {
        sliderCommitTask?.cancel()
        let elapsed = Date.now.timeIntervalSince(lastSliderCommit)
        guard elapsed < Constants.sliderThrottle else {
            commitSliderValue()
            return
        }
        let remaining = Constants.sliderThrottle - elapsed
        sliderCommitTask = Task { @MainActor [weak self] in
            try? await Task.sleep(for: .seconds(remaining))
            guard !Task.isCancelled else { return }
            self?.commitSliderValue()
        }
    }

    func commitSliderValue() {
        lastSliderCommit = .now
        committedSliderValue = sliderValue
    }
}

private enum Constants {
    static let aprStep = 0.01
    static let percentStep = 1
    static let percentMax = 100
    static let taxStep = 1.0
    static let taxMax = 100.0
    static let sliderThrottle = 0.05
    static let anchorEpsilon = 0.01
}
