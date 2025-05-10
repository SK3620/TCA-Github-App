//
//  TabBarReducer.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/05/04.
//

import ComposableArchitecture

public enum Tab: Equatable {
    case home
    case search
    case profile
}

@Reducer
public struct TabBarReducer {
    
    @ObservableState
    public struct State: Equatable, Hashable {
        var selectedTab: Tab = .home
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case let .didSelectTab(tab):
                    return .send(.delegate(.didSelectTab(tab)))
                }
                
            case .internal:
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}

extension TabBarReducer {
    public enum Action: ReducerAction {
        
        case view(ViewAction)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        // View で発生する Action
        public enum ViewAction {
            case didSelectTab(Tab)
        }
        
        // Reducer 内部で副作用によって発生する Action
        public enum InternalAction {}
        
        // Parent Reducer に処理を委譲するための Action
        public enum DelegateAction: Equatable {
            // 親（RootReducer）にタブ選択時のActionを委譲するためのAction
            case didSelectTab(Tab)
        }
    }
}
