//
//  Atomic.swift
//  MainActor
//
//  Created by Trí Nguyễn on 19/11/2021.
//

import Foundation

//Atomic Property = Thread Safety + Property Wrappers

@propertyWrapper
struct Atomic<Value> {
    
    private let queue = DispatchQueue(label: "atomic")
    private var value: Value
    
    init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    var wrappedValue: Value {
        get {
            return queue.sync { value }
        }
        set {
            queue.sync { value = newValue }
        }
    }
    
}
