//
//  CustomBindingView.swift
//  TCA-Github-App
//
//  Created by 鈴木 健太 on 2025/05/10.
//

// MARK: - 自作Binding

import SwiftUI

public struct CustomBindingView: View {
    @State private var text: String = "Hello"
    
    public init() {}

    public var body: some View {
        let binding = Binding(
            get: { self.text },
            set: { newValue in self.text = newValue }
        )

        VStack {
            Text("入力内容: \(text)")
            TextField("入力してください", text: binding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
}

/*
 TextField に文字を入力
 → binding.set(newValue) が呼ばれる
 → self.text = newValue が実行される

 text の値が更新されると View が再描画

 TextField に値を表示する時は binding.get() が呼ばれる
 → self.text の最新値を取得
 */


// MARK: - 普通のBinding 要するに上記と同じ。

public struct NormalBindingView: View {
    @State private var text: String = "Hello"
    
    public init() {}

    public var body: some View {

        VStack {
            Text("入力内容: \(text)")
            TextField("入力してください", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
}

