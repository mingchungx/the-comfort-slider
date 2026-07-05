import SwiftUI

struct StepperControl<Content: View>: View {
    let decrementEnabled: Bool
    let incrementEnabled: Bool
    let onDecrement: () -> Void
    let onIncrement: () -> Void
    @ViewBuilder var content: Content

    var body: some View {
        HStack(spacing: Constants.spacing) {
            HoldStepButton(systemName: "minus", sprayEmoji: "➖", isEnabled: decrementEnabled, onStep: onDecrement)
            content
                .frame(maxWidth: .infinity)
            HoldStepButton(systemName: "plus", sprayEmoji: "➕", isEnabled: incrementEnabled, onStep: onIncrement)
        }
    }
}

private enum Constants {
    static let spacing = 16.0
}
