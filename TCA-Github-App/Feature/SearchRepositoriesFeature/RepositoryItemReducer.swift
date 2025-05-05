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
    }

    // MARK: - Action
    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
    }

    // MARK: - Dependencies

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}
