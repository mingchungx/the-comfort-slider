import SwiftUI

struct PriceFieldView: View {
    @Binding var text: String
    let currency: Currency
    var focus: FocusState<CalcField?>.Binding

    var body: some View {
        GlassCard(title: "Total price") {
            AmountField(text: $text, currency: currency, field: .price, focus: focus)
        }
    }
}
