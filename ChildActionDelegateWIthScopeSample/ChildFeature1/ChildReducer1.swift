//
//  ChildReducer1.swift
//  TCA-Github-App
//
//  Created by 鈴木 健太 on 2025/05/05.
//

import ComposableArchitecture

@Reducer
public struct ChildReducer1 {
    
    @ObservableState
    public struct State: Equatable {
        
        public init() {}
    }

    public enum Action {
        case loginButtonTapped
        case delegate(Delegate)

        public enum Delegate: Equatable {
            case didLoginSuccessfully
        }
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loginButtonTapped:
                // ログイン成功したと仮定して親に委譲
                return .send(.delegate(.didLoginSuccessfully))

            case .delegate:
                return .none
            }
        }
    }
}
