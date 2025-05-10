//
//  ProjectedValue.swift
//  TCA-Github-App
//
//  Created by 鈴木 健太 on 2025/05/10.
//

import SwiftUI

// MARK: - projectedValue

/*
追加でprojectedValueという変数を実装することもできます。ラッピングした値の状態を示したり、wrappedValueに関するなんらかの情報を返すことができます。外からこの値にアクセスするには$を頭につけなければいけません。
 
 @State
 */


@propertyWrapper
struct HelloWorld2 {
    private var text: String
    var projectedValue: Bool

    init() {
        projectedValue = false
        text = ""
    }
    var wrappedValue: String {
        get { return text }
        set {
            if newValue == "世界" {
                text = "こんにちは, \(newValue)!"
                projectedValue = true
                return
            }
            text = "Hello, \(newValue)!"
            projectedValue = false
        }
    }
}

class HelloWorld22 {

    @HelloWorld2 var str: String
    
    func sayHello() {
        print(str)        // Hello, World!
        print("\($str)")  // false
        str = "世界"
        print(str)        // こんにちは, 世界!
        print("\($str)")  // true
    }
}


// MARK: - State における projectedValue

/*
 StateはprojecteValueとして、Bindingを返します。上記の例だと、 $message で、StringをBindingでラップした値を返してくれます。

 */
struct GreetingViewView: View {
    @State var message: String = "こんにちは"
    
    var body: some View {
        VStack {
            Text(message)
            TextField(message, text: $message)
        }
    }
}
