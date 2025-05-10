//
//  RootView1.swift
//  TCA-Github-App
//
//  Created by 鈴木 健太 on 2025/05/05.
//

import SwiftUI
import ComposableArchitecture

public struct RootView1: View {
    
    @Bindable var store: StoreOf<RootReducer1>
    
    public init(store: StoreOf<RootReducer1>) {
        self.store = store
    }
        
    public var body: some View {
        if store.isLoggedIn {
            Text("ログイン成功")
        } else {
            ChildView1(store: store.scope(state: \.childReducer1, action: \.childAction))
        }
    }
}
