//
//  PropertyWrappers.swift
//  TCA-Github-App
//
//  Created by 鈴木 健太 on 2025/05/10.
//

import SwiftUI

// MARK: - wrappedValue

/*
propertyWrapperはラッピングした値を返す変数であるwrappedValueを実装する必要があります。この値のget/setで、ラッピングした値を変更したりします。
 */


@propertyWrapper
struct HelloWorld {
    private var text: String
    init() {
        text = ""
    }
    var wrappedValue: String {
        get { return text }
        set {
            if newValue == "世界" {
                text = "こんにちは, \(newValue)!"
                return
            }
            text = "Hello, \(newValue)!"
        }
    }
}

struct HelloWorldView: View {
    
    @HelloWorld var name: String
    
    var body: some View {
        Text("")
    }
    
    private func hoge() {
        var closure: (String) -> Void
        
        // (String) -> Void ⬇︎
        closure = { str -> Void in
            print(str)
        }
        
        huga(set: closure)
        
    }
    
    private func huga(set: (String) -> Void) {
        set("aaa")
    }
}
