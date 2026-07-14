import SwiftUI

struct FinancingView: View {
    let downPaymentPercent: Int
    let downPaymentAmount: Decimal
    let canDecreaseDownPayment: Bool
    let canIncreaseDownPayment: Bool
    let onDecreaseDownPayment: () -> Void
    let onIncreaseDownPayment: () -> Void
    let aprPercent: Double
    let interestAmount: Decimal
    let canDecreaseAPR: Bool
    let onDecreaseAPR: () -> Void
    let onIncreaseAPR: () -> Void
    let currency: Currency
    @Binding var termMonths: Int

    var body: some View {
        CollapsibleSection("Financing") {
            VStack(alignment: .leading, spacing: Constants.rowSpacing) {
                downPaymentField
                Divider()
                aprField
                Divider()
                termField
            }
        }
    }
}

private extension FinancingView {
    var downPaymentField: some View {
        field(title: "Down payment") {
            StepperControl(
                decrementEnabled: canDecreaseDownPayment,
                incrementEnabled: canIncreaseDownPayment,
                onDecrement: onDecreaseDownPayment,
                onIncrement: onIncreaseDownPayment
            ) {
                VStack(spacing: Constants.valueSpacing) {
                    Text("\(downPaymentPercent)%")
                        .font(.title2.bold())
                        .monospacedDigit()
                        .contentTransition(.numericText())
                    amountRow(
                        downPaymentAmount,
                        title: "Down payment",
                        info: "The cash you put down upfront — this percentage of the total price. It's subtracted from the amount you finance."
                    )
                }
            }
        }
    }

    var aprField: some View {
        field(title: "APR") {
            StepperControl(
                decrementEnabled: canDecreaseAPR,
                incrementEnabled: true,
                onDecrement: onDecreaseAPR,
                onIncrement: onIncreaseAPR
            ) {
                VStack(spacing: Constants.valueSpacing) {
                    Text(aprLabel)
                        .font(.title2.bold())
                        .monospacedDigit()
                        .contentTransition(.numericText())
                    amountRow(
                        interestAmount,
                        title: "Total interest",
                        info: "The total interest you'll pay the lender over the full term, on top of the amount financed."
                    )
                }
            }
        }
    }

    var termField: some View {
        field(title: "Term") {
            Picker("Term", selection: $termMonths) {
                ForEach(Constants.termYears, id: \.self) { years in
                    Text(termLabel(months: years * Constants.monthsPerYear))
                        .tag(years * Constants.monthsPerYear)
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)
            .frame(height: Constants.wheelHeight)
        }
    }

    func field(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: Constants.labelSpacing) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    func amountRow(_ amount: Decimal, title: String, info message: String) -> some View {
        HStack(spacing: Constants.infoSpacing) {
            Text(amount, format: currencyFormat)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .monospacedDigit()
                .contentTransition(.numericText())
                .animation(.snappy, value: amount)
            InfoButton(title: title, message: message)
        }
    }

    var aprLabel: String {
        "\(aprPercent.formatted(.number.precision(.fractionLength(0...2))))%"
    }

    func termLabel(months: Int) -> String {
        let years = months / Constants.monthsPerYear
        let unit = years == 1 ? "year" : "years"
        return "\(months) months (\(years) \(unit))"
    }

    var currencyFormat: Decimal.FormatStyle.Currency {
        .currency(code: currency.code).precision(.fractionLength(0))
    }
}

private enum Constants {
    static let termYears = 1...100
    static let monthsPerYear = 12
    static let wheelHeight = 130.0
    static let rowSpacing = 16.0
    static let labelSpacing = 4.0
    static let valueSpacing = 2.0
    static let infoSpacing = 4.0
}
