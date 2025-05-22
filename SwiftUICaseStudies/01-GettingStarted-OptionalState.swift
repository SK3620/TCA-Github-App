import ComposableArchitecture
import SwiftUI

/// この画面では、オプショナルな子状態が存在するかどうかによってビューの表示を切り替える方法を示します。
/// 親の状態（State）は `Counter.State?` 型のプロパティを持っており、
/// これが `nil` の場合はテキストビューを表示し、非 `nil` の場合はカウンタービューを表示します。
/// ボタンをタップすることで、この `optionalCounter` の値を `nil` <-> 非 `nil` にトグルし、表示を切り替えます。
private let readMe = """
  This screen demonstrates how to show and hide views based on the presence of some optional child \
  state.

  The parent state holds a `Counter.State?` value. When it is `nil` we will default to a plain \
  text view. But when it is non-`nil` we will show a view fragment for a counter that operates on \
  the non-optional counter state.

  Tapping "Toggle counter state" will flip between the `nil` and non-`nil` counter states.
  """

@Reducer
struct OptionalBasics {
  @ObservableState
  struct State: Equatable {
    // オプショナルな子状態を保持するプロパティ。
    // nil のときは何も表示しない or テキストを表示し、
    // 値が設定されていれば対応するカウンターUIを表示します。
    var optionalCounter: Counter.State?
  }

  enum Action {
    case optionalCounter(Counter.Action)
    case toggleCounterButtonTapped
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .toggleCounterButtonTapped:
        // ボタンがタップされると、optionalCounter が nil と非 nil の間で切り替わります。
        // これにより表示されるビューが切り替わります。
        state.optionalCounter =
          state.optionalCounter == nil
          ? Counter.State()
          : nil
        return .none
      case .optionalCounter:
        return .none
      }
    }
      
      /*
       optionalCounter が nil でない場合に、Counter （子）Reducer を親に埋め込み、
       動作させる。
       つまり、子状態が存在する場合にのみ Counter のロジックを適用する構造です。
       */
    .ifLet(\.optionalCounter, action: \.optionalCounter) {
      Counter()
    }
  }
}

struct OptionalBasicsView: View {
  let store: StoreOf<OptionalBasics>

  var body: some View {
    Form {
      Section {
        AboutView(readMe: readMe)
      }

      Button("Toggle counter state") {
        store.send(.toggleCounterButtonTapped)
      }

      // optionalCounter が存在する（非 nil）場合は、カウンタービューを表示。
      // 存在しない（nil）場合は、プレーンなテキストを表示。
      if let store = store.scope(state: \.optionalCounter, action: \.optionalCounter) {
        Text(template: "`Counter.State` is non-`nil`")
        CounterView(store: store)
          .buttonStyle(.borderless) // カウンタービューのボタンスタイルを境界なしに設定
          .frame(maxWidth: .infinity) // 幅いっぱいに表示されるように調整
      } else {
        Text(template: "`Counter.State` is `nil`")
      }
    }
    .navigationTitle("Optional state")
  }
}

#Preview {
  NavigationStack {
    OptionalBasicsView(
      store: Store(initialState: OptionalBasics.State()) {
        OptionalBasics()
      }
    )
  }
}

#Preview("Deep-linked") {
  NavigationStack {
    OptionalBasicsView(
      store: Store(
        initialState: OptionalBasics.State(
          optionalCounter: Counter.State(
            count: 42
          )
        )
      ) {
        OptionalBasics()
      }
    )
  }
}
