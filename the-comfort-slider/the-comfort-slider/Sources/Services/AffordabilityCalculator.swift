import Foundation

struct AffordabilityResult {
    let monthlyPayment: Decimal
    /// `nil` when the comfort level implies 0% of income — i.e. no finite
    /// salary can make this payment that small a share of your money.
    let requiredAnnualIncome: Decimal?
    let totalInterest: Decimal
    let dtiFraction: Double
    let months: Int
    let annualRatePercent: Double
    let zone: ComfortZone

    func withRequiredIncome(_ income: Decimal) -> AffordabilityResult {
        AffordabilityResult(
            monthlyPayment: monthlyPayment,
            requiredAnnualIncome: income,
            totalInterest: totalInterest,
            dtiFraction: dtiFraction,
            months: months,
            annualRatePercent: annualRatePercent,
            zone: zone
        )
    }
}

struct AffordabilityCalculator {
    func result(
        totalPrice: Decimal,
        downPaymentPercent: Int,
        annualRatePercent: Double,
        months: Int,
        sliderValue: Double
    ) -> AffordabilityResult {
        let scale = ComfortScale(sliderValue: sliderValue)
        let financed = totalPrice * Decimal(100 - downPaymentPercent) / 100
        let monthly = monthlyPayment(principal: financed, annualRatePercent: annualRatePercent, months: months)
        let monthlyValue = (monthly as NSDecimalNumber).doubleValue
        let requiredAnnualIncome: Decimal? = scale.isAffordable
            ? Decimal(monthlyValue / scale.dtiFraction * 12)
            : nil
        let totalInterest = max(.zero, monthly * Decimal(months) - financed)
        return AffordabilityResult(
            monthlyPayment: monthly,
            requiredAnnualIncome: requiredAnnualIncome,
            totalInterest: totalInterest,
            dtiFraction: scale.dtiFraction,
            months: months,
            annualRatePercent: annualRatePercent,
            zone: scale.zone
        )
    }
}

private extension AffordabilityCalculator {
    func monthlyPayment(principal: Decimal, annualRatePercent: Double, months: Int) -> Decimal {
        let principalValue = (principal as NSDecimalNumber).doubleValue
        let count = Double(max(months, 1))
        let monthlyRate = annualRatePercent / 100 / 12
        guard monthlyRate > 0 else { return Decimal(principalValue / count) }
        let growth = pow(1 + monthlyRate, count)
        let payment = principalValue * monthlyRate * growth / (growth - 1)
        return Decimal(payment)
    }
}
