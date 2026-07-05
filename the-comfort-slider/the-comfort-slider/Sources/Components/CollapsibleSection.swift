import SwiftUI

struct CollapsibleSection<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    @State private var isExpanded: Bool

    init(_ title: String, initiallyExpanded: Bool = true, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
        _isExpanded = State(initialValue: initiallyExpanded)
    }

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: Constants.spacing) {
                header
                if isExpanded {
                    content
                        .transition(.opacity)
                }
            }
        }
    }
}

private extension CollapsibleSection {
    var header: some View {
        Button {
            withAnimation(.snappy) { isExpanded.toggle() }
        } label: {
            HStack {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .rotationEffect(.degrees(isExpanded ? 0 : -90))
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}

private enum Constants {
    static let spacing = 16.0
}
