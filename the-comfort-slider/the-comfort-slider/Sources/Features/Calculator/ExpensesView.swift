import SwiftUI

struct ExpensesView: View {
    @Binding var expenses: [AdditionalExpense]
    let monthlyTotal: Decimal
    let canRemove: Bool
    let currency: Currency
    var focus: FocusState<CalcField?>.Binding
    let onAdd: () -> Void
    let onRemove: (AdditionalExpense.ID) -> Void

    var body: some View {
        CollapsibleSection("Additional costs", initiallyExpanded: false) {
            VStack(alignment: .leading, spacing: Constants.rowSpacing) {
                ForEach($expenses) { $expense in
                    row($expense)
                    Divider()
                }
                footer
            }
        }
    }
}

private extension ExpensesView {
    func row(_ expense: Binding<AdditionalExpense>) -> some View {
        let id = expense.wrappedValue.id
        return HStack(spacing: Constants.rowSpacing) {
            AmountField(
                text: expense.amountText,
                currency: currency,
                field: .expense(id),
                focus: focus,
                symbolFont: .title3.bold(),
                valueFont: .system(.title2, design: .rounded).bold()
            )
            frequencyPicker(expense.frequency)
            if canRemove {
                removeButton(id)
            }
        }
    }

    func frequencyPicker(_ frequency: Binding<ExpenseFrequency>) -> some View {
        Picker("Frequency", selection: frequency) {
            ForEach(ExpenseFrequency.allCases) { option in
                Text(option.label).tag(option)
            }
        }
        .labelsHidden()
        .pickerStyle(.menu)
        .font(.subheadline)
    }

    func removeButton(_ id: AdditionalExpense.ID) -> some View {
        Button {
            withAnimation(.snappy) { onRemove(id) }
        } label: {
            Image(systemName: "minus.circle.fill")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Remove cost")
    }

    var footer: some View {
        HStack {
            Button {
                withAnimation(.snappy) { onAdd() }
            } label: {
                Label("Add cost", systemImage: "plus.circle.fill")
                    .font(.subheadline.weight(.semibold))
            }
            .buttonStyle(.plain)
            Spacer()
            total
        }
    }

    var total: some View {
        HStack(spacing: Constants.infoSpacing) {
            Text(monthlyTotal, format: currencyFormat)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .monospacedDigit()
                .contentTransition(.numericText())
                .animation(.snappy, value: monthlyTotal)
            Text("/ mo")
                .font(.caption)
                .foregroundStyle(.secondary)
            InfoButton(
                title: "Additional costs",
                message: "Recurring costs like gas, insurance, or maintenance — each is converted to a monthly amount and added to your financing payment."
            )
        }
    }

    var currencyFormat: Decimal.FormatStyle.Currency {
        .currency(code: currency.code).precision(.fractionLength(0))
    }
}

private enum Constants {
    static let rowSpacing = 12.0
    static let infoSpacing = 4.0
}
