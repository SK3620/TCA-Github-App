//
//  InternalBindingProcess.swift
//  TCA-Github-App
//
//  Created by 鈴木 健太 on 2025/05/10.
//

import SwiftUI

// おそらく内部的にはこんな感じ？

@propertyWrapper
struct HugaState<Value> {
    private var storage: Value
    
    init(wrappedValue: Value) {
        self.storage = wrappedValue
    }
    
    var wrappedValue: Value {
        get { storage }
        set { storage = newValue }
    }
    
    
    var projectedValue: HugaBinding<Value> {
        HugaBinding(
            get: { storage },
            set: { newValue in /* storage = newValue */ } // Cannot assign to property: 'self' is immutable
        )
    }
}

public struct HugaBinding<Value> {
    private let getter: () -> Value
    private let setter: (Value) -> Void

    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        self.getter = get
        self.setter = set
    }

    public var wrappedValue: Value {
        get { getter() }
        set { setter(newValue) }
    }
}

