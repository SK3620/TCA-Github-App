import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
public struct RepositoryDetailReducer: Reducer {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var id: Int { repository.id }
        public let repository: Repository
        public var liked: Bool = false

        public init(
            item: Repository,
            liked: Bool = false
        ) {
            self.repository = item
            self.liked = liked
        }
    }

    public init() {}

    // MARK: - Action
    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
    }

    // MARK: - Dependencies

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
    }
}

