import ComposableArchitecture
import SwiftUI
import Foundation

@Reducer
public struct SearchRepositoriesReducer: Reducer, Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        var items = IdentifiedArrayOf<RepositoryItemReducer.State>()
        var query: String = ""
        var showFavoritesOnly = false
        var hasMorePage = false
                
        var filteredItems: IdentifiedArrayOf<RepositoryItemReducer.State> {
            items.filter {
                !showFavoritesOnly || $0.liked
            }
        }
        
        var loadingState: LoadingState = .idle
        
        // 画面の状態を積み上げる
         var path = StackState<Path.State>()
        
        public init() {}
    }
    
    // どんな画面を積み上げるかを定義
    @Reducer(state: .equatable)
    public enum Path {
        case repositoryDetail(RepositoryDetailReducer)
    }
    
    enum LoadingState: Equatable {
        case idle
        case loading
    }
    
    public init() {}
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>) // バインディング変更時のアクション
        case items(IdentifiedActionOf<RepositoryItemReducer>)
        case itemAppeared(id: Int)
        case itemTapped(item: Repository, liked: Bool)
        case search // 検索押下時
        case searchReposResponse(Result<SearchReposResponse, Error>) // 受け取った検索結果を流す
        case path(StackActionOf<Path>) // 子画面からのイベントを受け取る窓口
        case delegate(Delegate)
       
        public enum Delegate: Equatable {
            case someDelegateAction
        }
    }
    
    // MARK: - Dependencies
    @Dependency(\.githubClient) var githubClient

    public var body: some ReducerOf<Self> {
        BindingReducer() // 各プロパティの変更を自動的に処理してくれる
            .onChange(of: \.query) { oldValue, newValue in
                Reduce { state, action in
                    print("古い値：\(oldValue), 新しい値：\(newValue)")
                    return Effect.none // 副作用なし
                }
            }
        
        Reduce { state, action in
            switch action {
            case .binding(\State.query): // KeyPathでパターンマッチングも可能（※「case .binding」よりも先に書く）.onChangeでも良い
                print("現在の入力値は：\(state.query)")
                return .none
            case .binding:
                return .none // BindingReducer()で自動で処理されるので特に何もしなくて
            case .items:
                return .none
            case .itemAppeared:
                return .none
            case let .itemTapped(item, liked):
                let repositoryDetailReducerState = RepositoryDetailReducer.State(item: item, liked: liked)
                state.path.append(.repositoryDetail(repositoryDetailReducerState))
                return .none
            case .search:
                state.loadingState = .loading
                return .run { [query = state.query] send in
                    // init(catching body: () async throws(Failure) -> Success) async 「async」なのでawaitつける
                    let result = await Result(catching: { () async throws -> SearchReposResponse in
                        try await githubClient.searchRepos(query, 0)
                    })
                    // let result: Result<SearchReposResponse, any Error>
                    await send(.searchReposResponse(result))
                }
            case let .path(.element(id: id, action: .repositoryDetail(.binding(_)))):
                // case let .path(.element(id: id, action: .binding(\.$liked))): コンパイルエラー
                /*
                public enum StackAction<State, Action>: CasePathable {
                    indirect case element(id: StackElementID, action: Action)
                }
                 */
                guard let repositoryDetail = state.path[id: id]?.repositoryDetail else { return .none }
                state.items[id: repositoryDetail.id]?.liked = repositoryDetail.liked
                return .none
            case .path:
                return .none
            case .searchReposResponse(.success(let response)):
                let newItems = IdentifiedArray(uniqueElements: response.items.map { RepositoryItemReducer.State(repository: Repository(from: $0)) })
                state.items = newItems
                state.loadingState = .idle
                return .none
            case .searchReposResponse(.failure):
                return .none
            case .delegate:
                return .none
            }
        }
        // それぞれの子に対応するロジック（Reducer）を割り当てる
        .forEach(\.items, action: \.items) {
            RepositoryItemReducer()
        }
        // 各子画面の処理を親とつなげる
        .forEach(\.path, action: \.path)
    }
}
