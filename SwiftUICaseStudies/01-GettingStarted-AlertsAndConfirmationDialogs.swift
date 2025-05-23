import ComposableArchitecture
import SwiftUI

private let readMe = """
  This demonstrates how to best handle alerts and confirmation dialogs in the Composable \
  Architecture.

  The library comes with two types, `AlertState` and `ConfirmationDialogState`, which are data \
  descriptions of the state and actions of an alert or dialog. These types can be constructed in \
  reducers to control whether or not an alert or confirmation dialog is displayed, and \
  corresponding view modifiers, `alert(_:)` and `confirmationDialog(_:)`, can be handed bindings \
  to a store focused on an alert or dialog domain so that the alert or dialog can be displayed in \
  the view.

  The benefit of using these types is that you can get full test coverage on how a user interacts \
  with alerts and dialogs in your application
  """

@Reducer
struct AlertAndConfirmationDialog {
    @ObservableState
    struct State: Equatable {
        
        /*
         @Presents
         アラート表示するかどうか（＝nil か そうでないか）を監視しつつ、関連アクションも自動的に処理できるようにするマーク
         
         AlertState<Action>
         ユーザーに表示されるアラートの状態を表す
         Actionジェネリック: アラート内のボタンをタップすることで送信できるアクションの種類
         */
        
        @Presents var alert: AlertState<Action.Alert>?
        @Presents var confirmationDialog: ConfirmationDialogState<Action.ConfirmationDialog>?
        var count = 0
    }
    
    enum Action {
        
        /*
         PresentationAction
         アラートやダイアログでユーザーがボタンを押したことを、Reducer に伝える
         */
        
        case alert(PresentationAction<Alert>)
        case alertButtonTapped
        case confirmationDialog(PresentationAction<ConfirmationDialog>)
        case confirmationDialogButtonTapped
        
        @CasePathable
        enum Alert {
            case incrementButtonTapped
        }
        @CasePathable
        enum ConfirmationDialog {
            case incrementButtonTapped
            case decrementButtonTapped
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .alert(.presented(.incrementButtonTapped)),
                    .confirmationDialog(.presented(.incrementButtonTapped)):
                state.alert = AlertState { TextState("Incremented!") }
                state.count += 1
                return .none
                
            case .alert:
                return .none
                
            case .alertButtonTapped:
                // AlertState をセットし、アラート表示
                state.alert = AlertState {
                    TextState("Alert!")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                    ButtonState(action: .incrementButtonTapped) {
                        TextState("Increment")
                    }
                } message: {
                    TextState("This is an alert")
                }
                return .none
                
            case .confirmationDialog(.presented(.decrementButtonTapped)):
                state.alert = AlertState { TextState("Decremented!") }
                state.count -= 1
                return .none
                
            case .confirmationDialog:
                return .none
                
            case .confirmationDialogButtonTapped:
                state.confirmationDialog = ConfirmationDialogState {
                    TextState("Confirmation dialog")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                    ButtonState(action: .incrementButtonTapped) {
                        TextState("Increment")
                    }
                    ButtonState(action: .decrementButtonTapped) {
                        TextState("Decrement")
                    }
                } message: {
                    TextState("This is a confirmation dialog.")
                }
                return .none
            }
        }
        /*
         .iflet 親の状態（State）にある @Presentsな子の状態（Optional） があるときだけ、その子のロジック（Reducer）を埋め込む
         */
        .ifLet(\.$alert, action: \.alert) // Reducer を返す
        .ifLet(\.$confirmationDialog, action: \.confirmationDialog) // Reducer を返す
    }
}

struct AlertAndConfirmationDialogView: View {
    @Bindable var store: StoreOf<AlertAndConfirmationDialog>
    
    var body: some View {
        Form {
            Section {
                AboutView(readMe: readMe)
            }
            
            Text("Count: \(store.count)")
            Button("Alert") { store.send(.alertButtonTapped) }
            Button("Confirmation Dialog") { store.send(.confirmationDialogButtonTapped) }
        }
        .navigationTitle("Alerts & Dialogs")
        .alert($store.scope(state: \.alert, action: \.alert))
        .confirmationDialog($store.scope(state: \.confirmationDialog, action: \.confirmationDialog))
    }
}

#Preview {
  NavigationStack {
    AlertAndConfirmationDialogView(
      store: Store(initialState: AlertAndConfirmationDialog.State()) {
        AlertAndConfirmationDialog()
      }
    )
  }
}
