//
//  TabBarReducer.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/05/04.
//

import SwiftUI
import ComposableArchitecture

public struct CustomTabBar: View {
    let store: StoreOf<TabBarReducer>
    
    public init(store: StoreOf<TabBarReducer>) {
        self.store = store
    }
    
    public var body: some View {
        HStack {
            Button {
                store.send(.view(.didSelectTab(.home)))
            } label: {
                Image(systemName: store.selectedTab == .home ? "house.fill" : "house")
                    .font(.system(size: 24))
                    .foregroundColor(store.selectedTab == .home ? .blue : .gray)
            }
            
            Spacer()
            
            Button {
                store.send(.view(.didSelectTab(.search)))
            } label: {
                Image(systemName: store.selectedTab == .search ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                    .font(.system(size: 24))
                    .foregroundColor(store.selectedTab == .search ? .blue : .gray)
            }
            
            Spacer()
            
            Button {
                store.send(.view(.didSelectTab(.profile)))
            } label: {
                Image(systemName: store.selectedTab == .profile ? "person.crop.circle.fill" : "person.crop.circle")
                    .font(.system(size: 24))
                    .foregroundColor(store.selectedTab == .profile ? .blue : .gray)
            }
        }
    }
}
