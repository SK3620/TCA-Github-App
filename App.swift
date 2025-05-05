import SwiftUI
import ComposableArchitecture

@main
struct GithubApp: App {
    var body: some Scene {
        WindowGroup {
            /*
             public convenience init<R: Reducer<State, Action>>(
             initialState: @autoclosure () -> R.State,
             @ReducerBuilder<State, Action> reducer: () -> R,
             withDependencies prepareDependencies: ((inout DependencyValues) -> Void)? = nil
             )
             */
            
            // RootView画面で使用するReducerを初期状態化したState（RootReducer.State）と一緒に指定する
            RootView(store: .init(initialState: .init(), reducer: {
                RootReducer()
            }))
        }
    }
}
