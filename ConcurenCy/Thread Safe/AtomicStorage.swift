//
//  AtomicStorage.swift
//  MainActor
//
//  Created by Trí Nguyễn on 19/11/2021.
//

import Foundation
import Dispatch

class AtomicStorage {
    
    private let lockQueue = DispatchQueue(label: "serial.lock.queue")
    private var storage: [Int: String] = [:]
    
    init() {
        self.storage = [:]
    }
    
    func get(_ key: Int) -> String? {
        lockQueue.sync {
            storage[key]
        }
    }
    
    func set(_ key: Int, value: String) {
        lockQueue.sync {
            storage[key] = value
        }
    }
    
    var allValue: [Int: String] {
        lockQueue.sync {
            storage
        }
    }
}
