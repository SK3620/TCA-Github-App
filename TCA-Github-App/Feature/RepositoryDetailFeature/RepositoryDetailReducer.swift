import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
public struct RepositoryDetailReducer: Reducer {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        var id: Int { repository.id }
        let repository: Repository
        var liked: Bool = false
        var changeBgColor: Bool = false
        
         // @Presents で"表示状態"をOptionalで管理する（nilで非表示, 値ありで表示）
         // AlertState でアラートの内容/中身（状態）を表す
        @Presents var alert: AlertState<Action.Alert>?

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
        case itemTapped
        // PresentationAction: Alert アクション内容を Reducer に伝える
        case alert(PresentationAction<Alert>)
        
        @CasePathable
        public enum Alert: Sendable {
            case changeBgColorButtonTapped
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
            case .itemTapped:
                // AlertState をセットし、アラート表示
                state.alert = AlertState {
                    TextState("Alert!")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                    ButtonState(action: .changeBgColorButtonTapped) {
                        TextState("Change Background Color")
                    }
                } message: {
                    TextState("This is an alert")
                }
                return .none
            case .alert(.presented(.changeBgColorButtonTapped)):
                state.changeBgColor.toggle()
                return .none
            case .alert:
                return .none
            }
        }
        .ifLet(\.alert, action: \.alert)
    }
}

