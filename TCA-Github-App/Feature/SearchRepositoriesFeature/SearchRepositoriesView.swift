import SwiftUI
import ComposableArchitecture

// 検索リポジトリ画面を表示する View
public struct SearchRepositoriesView: View {
    // 検索機能の状態とアクションを管理するStore
    @Bindable var store: StoreOf<SearchRepositoriesReducer>
    
    public init(store: StoreOf<SearchRepositoriesReducer>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack {
                switch store.loadingState {
                case .loading:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                case .idle:
                    List {
                        Toggle(isOn: $store.showFavoritesOnly) {
                            Text("Favorites Only")
                        }
                        
                        ForEach(
                            // 親Storeが持っている子要素リストから、それぞれの子要素専用の小さなStoreを作り出す
                            store.scope(state: \.filteredItems, action: \.items),
                            id: \.state.id
                        ) { itemStore in
                            RepositoryItemView(store: itemStore)
                                .onTapGesture {
                                    store.send(.itemTapped(item: itemStore.repository, liked: itemStore.liked))
                                }
                        }
                    }
                }
            }
            .navigationTitle("GitHubApp")
            .searchable(
                text: $store.query,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("Search repositories")
            )
            .onSubmit(of: .search) {
                store.send(.search)
            }
        } destination: { store in
            switch store.case {
            case .repositoryDetail(let store):
                RepositoryDetailView(store: store)
            }
        }
    }
}
