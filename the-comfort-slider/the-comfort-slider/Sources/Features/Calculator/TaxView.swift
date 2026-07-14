import SwiftUI

struct TaxView: View {
    let taxPercent: Double
    let taxAmount: Decimal
    let canDecreaseTax: Bool
    let canIncreaseTax: Bool
    let onDecreaseTax: () -> Void
    let onIncreaseTax: () -> Void
    let currency: Currency

    var body: some View {
        CollapsibleSection("Sales tax", initiallyExpanded: false) {
            StepperControl(
                decrementEnabled: canDecreaseTax,
                incrementEnabled: canIncreaseTax,
                onDecrement: onDecreaseTax,
                onIncrement: onIncreaseTax
            ) {
                VStack(spacing: Constants.valueSpacing) {
                    Text(taxLabel)
                        .font(.title2.bold())
                        .monospacedDigit()
                        .contentTransition(.numericText())
                    HStack(spacing: Constants.infoSpacing) {
                        Text(taxAmount, format: currencyFormat)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                            .contentTransition(.numericText())
                            .animation(.snappy, value: taxAmount)
                        InfoButton(
                            title: "Sales tax",
                            message: "The tax added on top of the price — this percentage of the total. It's rolled into your out-the-door total and the amount you finance."
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

private extension TaxView {
    var taxLabel: String {
        "\(taxPercent.formatted(.number.precision(.fractionLength(0...2))))%"
    }

    var currencyFormat: Decimal.FormatStyle.Currency {
        .currency(code: currency.code).precision(.fractionLength(0))
    }
}

private enum Constants {
    static let valueSpacing = 2.0
    static let infoSpacing = 4.0
}
