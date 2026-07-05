import SwiftUI

struct ShaderBackground: View {
    let zone: ComfortZone

    var body: some View {
        GeometryReader { proxy in
            TimelineView(.animation) { timeline in
                Rectangle()
                    .colorEffect(
                        ShaderLibrary.sandyGradient(
                            .float2(proxy.size),
                            .float(time(timeline.date)),
                            .color(zone.gradient[0]),
                            .color(zone.gradient[1]),
                            .color(zone.gradient[2])
                        )
                    )
            }
        }
        .ignoresSafeArea()
        .animation(.smooth(duration: 0.6), value: zone)
    }
}

private extension ShaderBackground {
    func time(_ date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 1_000))
    }
}
