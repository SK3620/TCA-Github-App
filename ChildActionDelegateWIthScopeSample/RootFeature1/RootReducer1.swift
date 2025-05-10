//
//  RootReducer1.swift
//  TCA-Github-App
//
//  Created by 鈴木 健太 on 2025/05/05.
//

import ComposableArchitecture

@Reducer
public struct RootReducer1 {
    
    @ObservableState
    public struct State: Equatable {
        var childReducer1: ChildReducer1.State = .init()
        var isLoggedIn = false
        
        public init() {}
    }
    
    public enum Action {
        case childAction(ChildReducer1.Action)
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.childReducer1, action: \.childAction) {
            ChildReducer1()
        }

        Reduce { state, action in
            switch action {
            case .childAction(.delegate(.didLoginSuccessfully)):
                // 親が子の成功を検知して状態変更
                state.isLoggedIn = true
                return .none

            case .childAction:
                return .none
            }
        }
    }
}
