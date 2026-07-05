import Pow
import SwiftUI

struct HoldStepButton: View {
    let systemName: String
    let sprayEmoji: String
    var isEnabled = true
    let onStep: () -> Void

    @State private var repeatTask: Task<Void, Never>?
    @State private var isPressing = false
    @State private var didStep = false
    @State private var sprayTick = 0

    var body: some View {
        Image(systemName: systemName)
            .font(.headline)
            .foregroundStyle(isEnabled ? Color.primary : Color.secondary)
            .frame(width: Constants.size, height: Constants.size)
            .background(.regularMaterial, in: .rect(cornerRadius: Constants.cornerRadius))
            .scaleEffect(isPressing ? Constants.pressedScale : 1)
            .opacity(isEnabled ? 1 : Constants.disabledOpacity)
            .contentShape(.rect)
            .changeEffect(.spray { Text(sprayEmoji) }, value: sprayTick)
            .sensoryFeedback(.impact(weight: .light), trigger: sprayTick)
            .animation(.snappy(duration: Constants.pressAnimation), value: isPressing)
            .onLongPressGesture(
                minimumDuration: .infinity,
                maximumDistance: Constants.maxDistance,
                pressing: { pressing in
                    if pressing { beginPressing() } else { endPressing() }
                },
                perform: {}
            )
    }
}

private extension HoldStepButton {
    func beginPressing() {
        guard isEnabled else { return }
        isPressing = true
        didStep = true
        step()
        repeatTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(Constants.initialDelay))
            while !Task.isCancelled {
                step()
                try? await Task.sleep(for: .seconds(Constants.repeatInterval))
            }
        }
    }

    /// Animates the value change at the moment of interaction, so the numeric
    /// roll only plays on taps — never on the initial on-appear seeding.
    func step() {
        withAnimation(.snappy) { onStep() }
    }

    func endPressing() {
        isPressing = false
        repeatTask?.cancel()
        repeatTask = nil
        guard didStep else { return }
        didStep = false
        sprayTick += 1
    }
}

private enum Constants {
    static let size = 44.0
    static let cornerRadius = 14.0
    static let pressedScale = 0.88
    static let disabledOpacity = 0.4
    static let pressAnimation = 0.15
    static let maxDistance = 40.0
    static let initialDelay = 0.35
    static let repeatInterval = 0.03
}
