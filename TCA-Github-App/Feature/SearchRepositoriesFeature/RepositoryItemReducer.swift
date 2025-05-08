import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
public struct RepositoryItemReducer: Reducer, Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable, Identifiable, Sendable {
        public var id: Int { repository.id }
        let repository: Repository
        var liked = false
        var bookmarked = false
    }

    // MARK: - Action
    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case didBookmark(Repository)
        case delegate(Delegate)
        
        public enum Delegate: Equatable, Sendable {
            case didBookmark(Repository)
        }
    }

    // MARK: - Dependencies

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case let .didBookmark(repository):
                guard state.bookmarked else { return .none }
                // 親に処理を委譲する
                return .send(.delegate(.didBookmark(repository)))
            case .delegate:
                return .none
            }
        }
    }
}
