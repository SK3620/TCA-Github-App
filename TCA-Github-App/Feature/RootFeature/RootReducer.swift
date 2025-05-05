//
//  RootFeature.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/05/04.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct RootReducer: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable {
        var homeReducer: HomeReducer.State = .init()
        var searchReducer: SearchRepositoriesReducer.State = .init()
        var profileReducer: ProfileReducer.State = .init()
        var tabBar: TabBarReducer.State = .init()
        
        public init() {}
    }
    
    public init() {}
    
    public enum Action {
        case homeTab(HomeReducer.Action)
        case searchTab(SearchRepositoriesReducer.Action)
        case profileTab(ProfileReducer.Action)
        case tabBar(TabBarReducer.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.tabBar, action: \.tabBar) {
            TabBarReducer()
        }
        Reduce { state, action in
            switch action {
            case let .tabBar(.delegate(.didSelectTab(tab))):
                state.tabBar.selectedTab = tab
                return .none
            case .homeTab:
                return .none
            case .searchTab:
                return .none
            case .profileTab:
                return .none
            case .tabBar:
                return .none
            }
        }
    }
}
