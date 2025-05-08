import SwiftUI
import ComposableArchitecture

struct RepositoryItemView: View {
    
    @Bindable var store: StoreOf<RepositoryItemReducer>
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(store.repository.name)
                    .font(.system(size: 20, weight: .bold))
                    .lineLimit(1)
                
                Label {
                    Text("\(store.repository.stars)")
                        .font(.system(size: 14))
                } icon: {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.yellow)
                }
            }
            
            Spacer(minLength: 16)
            
            VStack {
                
                Spacer()
                
                Button {
                    store.liked.toggle()
                } label: {
                    Image(systemName: store.liked ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.pink)
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Button {
                    store.bookmarked.toggle()
                    store.send(.didBookmark(store.repository))
                } label: {
                    Image(systemName: store.bookmarked ? "bookmark.fill" : "bookmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.pink)
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
        }
    }
}
