//
//  HomeView.swift
//  GithubApp
//
//  Created by 鈴木 健太 on 2025/05/04.
//

import SwiftUI
import ComposableArchitecture

public struct HomeView: View {
    @Bindable var store: StoreOf<HomeReducer>
    
    public init(store: StoreOf<HomeReducer>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            Color.blue.opacity(0.1)
              .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Home")
                Text("（CustomTabBarにTabViewの切り替え練習）")
            }
        }
    }
}
