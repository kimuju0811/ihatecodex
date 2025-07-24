import SwiftUI

struct SettingsView: View {
    @ObservedObject var store: WebtoonStore

    var body: some View {
        Form {
            Toggle("자동 업데이트", isOn: Binding(
                get: { store.autoUpdate },
                set: { store.toggleAutoUpdate($0) }
            ))
        }
    }
}

#Preview {
    SettingsView(store: WebtoonStore())
}
