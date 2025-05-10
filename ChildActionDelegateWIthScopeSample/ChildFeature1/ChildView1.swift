//
//  Untitled.swift
//  TCA-Github-App
//
//  Created by 鈴木 健太 on 2025/05/05.
//

import SwiftUI
import ComposableArchitecture

public struct ChildView1: View {
    
    @Bindable var store: StoreOf<ChildReducer1>
    
    public init(store: StoreOf<ChildReducer1>) {
        self.store = store
    }
        
    public var body: some View {
        Button("ログイン") {
            store.send(.loginButtonTapped)
        }
    }
}
