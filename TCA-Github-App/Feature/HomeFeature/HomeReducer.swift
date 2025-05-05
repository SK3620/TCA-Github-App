//
//  HomeReducer.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/05/04.
//

import ComposableArchitecture

@Reducer
public struct HomeReducer: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    public init() {}
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case delegate(Delegate)
       
        public enum Delegate: Equatable {
            case someDelegateAction
        }
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .delegate:
                return .none
            }
        }
    }
}
