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
                // ユーザー入力や操作を、Actionに変えてReducerに伝える仕組み
                TabView(selection: $store.tabBar.selectedTab.sending(\.tabBar.didSelectTab)) {
                    
                    HomeView(store: store.scope(state: \.homeReducer, action: \.homeTab))
                        .tag(Tab.home)
                        .toolbar(.hidden, for: .tabBar)
                                        
                    SearchRepositoriesView(store: store.scope(state: \RootReducer.State.searchReducer, action: \.searchTab))
                        .tag(Tab.search)
                        .toolbar(.hidden, for: .tabBar)
                    
                    ProfileView(store: store.scope(state: \.profileReducer, action: \.profileTab))
                        .tag(Tab.profile)
                        .toolbar(.hidden, for: .tabBar)
                }
                
                // store.scopeでCustomTabBarで必要となる、親が持つtabBarのStateとActionだけを
                // 取り出して、StoreOf<TabBarReducer>を返却し、それを渡す
                // 返却値のStoreOf<TabBarReducer>はタブの初期位置などの状態を持つ
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
