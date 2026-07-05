import SwiftUI

struct PriceFieldView: View {
    @Binding var text: String
    let currency: Currency
    var focus: FocusState<CalcField?>.Binding

    var body: some View {
        GlassCard(title: "Total price") {
            ZStack {
                display
                field
            }
            .contentShape(.rect)
            .onTapGesture { focus.wrappedValue = .price }
        }
        .animation(.snappy, value: text)
    }
}

private extension PriceFieldView {
    var display: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(currency.symbol)
                .font(.title.bold())
                .foregroundStyle(.secondary)
            Text(displayValue)
                .font(.system(.largeTitle, design: .rounded).bold())
                .contentTransition(.numericText())
                .foregroundStyle(text.isEmpty ? .secondary : .primary)
            Spacer()
        }
    }

    var field: some View {
        TextField("", text: $text)
            .keyboardType(.decimalPad)
            .focused(focus, equals: .price)
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
