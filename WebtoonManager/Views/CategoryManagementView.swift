import SwiftUI

struct CategoryManagementView: View {
    @ObservedObject var store: WebtoonStore
    @State private var editMode: EditMode = .inactive

    var body: some View {
        List {
            Section(header: Text("장르")) {
                ForEach(store.categories.indices, id: \.self) { i in
                    TextField("장르", text: Binding(
                        get: { store.categories[i] },
                        set: { store.renameCategory(at: i, new: $0) }
                    ))
                }
                .onDelete(perform: store.deleteCategory)
                Button("추가") { store.categories.append("") }
            }
            Section(header: Text("작가")) {
                ForEach(store.writers.indices, id: \.self) { i in
                    TextField("작가", text: Binding(
                        get: { store.writers[i] },
                        set: { store.renameWriter(at: i, new: $0) }
                    ))
                }
                .onDelete(perform: store.deleteWriter)
                Button("추가") { store.writers.append("") }
            }
            Section(header: Text("스튜디오")) {
                ForEach(store.studios.indices, id: \.self) { i in
                    TextField("스튜디오", text: Binding(
                        get: { store.studios[i] },
                        set: { store.renameStudio(at: i, new: $0) }
                    ))
                }
                .onDelete(perform: store.deleteStudio)
                Button("추가") { store.studios.append("") }
            }
        }
        .navigationTitle("카테고리 관리")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(editMode == .active ? "확인" : "편집") {
                    withAnimation {
                        editMode = editMode == .active ? .inactive : .active
                    }
                }
            }
        }
        .environment(\.editMode, $editMode)
    }
}

#Preview {
    CategoryManagementView(store: WebtoonStore())
}
