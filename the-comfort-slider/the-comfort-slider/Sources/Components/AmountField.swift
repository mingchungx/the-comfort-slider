import SwiftUI

/// A monetary input: the currency symbol, the grouped amount, and an invisible
/// text field laid over the top so the caret goes where the tap does. The number
/// on screen is always the sanitised value, formatted for the device locale.
struct AmountField: View {
    @Binding var text: String
    let currency: Currency
    let field: CalcField
    var focus: FocusState<CalcField?>.Binding
    var symbolFont: Font = .title.bold()
    var valueFont: Font = .system(.largeTitle, design: .rounded).bold()

    var body: some View {
        ZStack {
            display
            input
        }
        .contentShape(.rect)
        .onTapGesture { focus.wrappedValue = field }
        .animation(.snappy, value: text)
    }
}

private extension AmountField {
    var display: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(currency.symbol)
                .font(symbolFont)
                .foregroundStyle(.secondary)
            Text(displayValue)
                .font(valueFont)
                .contentTransition(.numericText())
                .foregroundStyle(text.isEmpty ? .secondary : .primary)
                .lineLimit(1)
                .minimumScaleFactor(Constants.minimumScale)
            Spacer()
        }
    }

    var input: some View {
        TextField("", text: $text)
            .keyboardType(.decimalPad)
            .focused(focus, equals: field)
            .tint(.clear)
            .foregroundStyle(.clear)
    }

    var displayValue: String {
        guard !text.isEmpty else { return "0" }
        let parts = text.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
        let whole = String(parts.first ?? "")
        let grouped = Int(whole)?.formatted(.number.grouping(.automatic)) ?? (whole.isEmpty ? "0" : whole)
        guard text.contains(".") else { return grouped }
        let fraction = parts.count > 1 ? parts[1] : ""
        return grouped + decimalSeparator + fraction
    }

    /// The device locale's decimal mark, so the in-progress fraction renders the
    /// way the user expects (a "," in de_DE, a "." in en_US).
    var decimalSeparator: String {
        Locale.current.decimalSeparator ?? "."
    }
}

private enum Constants {
    static let minimumScale = 0.6
}
