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

                Picker("테마", selection: Binding(
                    get: { store.theme },
                    set: { store.changeTheme($0) }
                )) {
                    Text("시스템").tag("system")
                    Text("라이트").tag("light")
                    Text("다크").tag("dark")
                    Text("세피아").tag("sepia")
                    Text("포스터 뷰").tag("poster")
                    Text("핑크").tag("pink")
                }

                NavigationLink("카테고리 관리") {
                    CategoryManagementView(store: store)
                }
            }
            .navigationTitle("기타")
        }
        .tint(store.tintColor)
    }
}

#Preview {
    SettingsView(store: WebtoonStore())
}
