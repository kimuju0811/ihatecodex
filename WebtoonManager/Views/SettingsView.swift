import SwiftUI

struct SettingsView: View {
    @ObservedObject var store: WebtoonStore

    var body: some View {
        NavigationStack {
            Form {
                Toggle("자동 업데이트", isOn: Binding(
                    get: { store.autoUpdate },
                    set: { store.toggleAutoUpdate($0) }
                ))

                NavigationLink("카테고리 관리") {
                    CategoryManagementView(store: store)
                }
            }
            .navigationTitle("기타")
        }
    }
}

#Preview {
    SettingsView(store: WebtoonStore())
}
