//
//  RootFeature.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/05/04.
//

import SwiftUI
import ComposableArchitecture

public struct RootView: View {
    @Bindable var store: StoreOf<RootReducer>
    
    public init(store: StoreOf<RootReducer>) {
        UITabBar.appearance().isHidden = true
        self.store = store
    }
    
    public var body: some View {
        GeometryReader { geometryReader in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                TabView(selection: $store.tabBar.selectedTab.sending(\.tabBar.didSelectTab)) {
                    Text("Home")
                        .tag(Tab.home)
                        .toolbar(.hidden, for: .tabBar)
                    
                    SearchRepositoriesView(store: .init(initialState: .init(), reducer: {
                        SearchRepositoriesReducer()
                    }))
                    .tag(Tab.search)
                    .toolbar(.hidden, for: .tabBar)
                    
                    Text("Profile")
                        .tag(Tab.profile)
                        .toolbar(.hidden, for: .tabBar)
                }
                
                CustomTabBar(store: store.scope(state: \.tabBar, action: \.tabBar))
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: geometryReader.size.height / 9)
                    .padding(.horizontal, 40)
                    .padding(.vertical)
            }
            .ignoresSafeArea()
        }
    }
}
