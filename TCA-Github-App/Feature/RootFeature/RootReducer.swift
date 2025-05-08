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
        var searchReducer: SearchRepositoriesReducer.State = .init(query: "初期値です。")
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
        
        // 親State＆Actionの中で、子State＆Actionを管理する
        // Scopeで子を親に組み（埋め）込み、親子関係を作成すると⬇︎
        // ・親が処理の一部を子に任せられる
        // ・親で子のActionを受け取れて処理できる
        // ・親が子のStateを操作できる
        
        Scope(state: \.tabBar, action: \.tabBar) {
            TabBarReducer()
        }
        
        Scope(state: \.homeReducer, action: \.homeTab) {
            HomeReducer()
        }
                
        Scope(state: \.searchReducer, action: \.searchTab) {
            SearchRepositoriesReducer()
        }
        
        Scope(state: \.profileReducer, action: \.profileTab) {
            ProfileReducer()
        }
        
        Reduce { state, action in
            switch action {
                
                // 子（TabBarReducer）からの.send(.delegate(.didSelectTab(tab)))アクションを受け取れる
            case let .tabBar(.delegate(.didSelectTab(tab))):
                // 子のStateを操作できる
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
