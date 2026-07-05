import SwiftUI

struct InfoButton: View {
    let title: String
    let message: String

    @State private var isPresented = false

    var body: some View {
        Button {
            isPresented = true
        } label: {
            Image(systemName: "info.circle")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
        .alert(title, isPresented: $isPresented) {
            Button("Got it", role: .cancel) {}
        } message: {
            Text(message)
        }
    }
}
