import SwiftUI
import ComposableArchitecture

public struct RepositoryDetailView: View {
    @Bindable var store: StoreOf<RepositoryDetailReducer>
    
    public init(store: StoreOf<RepositoryDetailReducer>) {
        self.store = store
    }
    
    public var body: some View {
        Form {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    AsyncImage(url: store.repository.avatarUrl) { image in image.image?.resizable() }
                        .frame(width: 40, height: 40)

                    Text(store.repository.name)
                        .font(.system(size: 24, weight: .bold))

                    if let description = store.repository.description {
                        Text(description)
                    }

                    Label {
                        Text("\(store.repository.stars)")
                            .font(.system(size: 14, weight: .bold))
                    } icon: {
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color.yellow)
                    }
                }
                .onTapGesture {
                    store.send(.itemTapped)
                }

                Spacer(minLength: 16)

                Button {
                    $store.liked.wrappedValue.toggle()
                } label: {
                    Image(systemName: store.liked ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.pink)
                }
            }
            .background(store.changeBgColor ? Color.green.opacity(0.1) : Color.white)
        }
        // store（Reducer） で保持されている Optional な @Presents で表示状態が管理されている alertState が non-nil の時にアラートを表示
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
