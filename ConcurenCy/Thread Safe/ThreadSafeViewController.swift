//
//  ThreadSafeViewController.swift
//  MainActor
//
//  Created by Trí Nguyễn on 19/11/2021.
//

import UIKit

// DataRace & Race Condition

class ThreadSafeViewController: UIViewController {

    let concurentQueue = DispatchQueue(label: "tri", attributes: .concurrent)
    var number = 1
    
    // MARK: - Thread safe
    var threads: [Int: String] = [:]
    var lockQueue = DispatchQueue(label: "lock.queue")
    
    let storage = AtomicStorage() // Storage
    
    @Atomic var storagee: [Int: String] = [:] // Atomic wrapper
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.concurrentPerform(iterations: 100) { i in
            storagee[i] = "\(Thread.current)"
        }

        DispatchQueue.concurrentPerform(iterations: 100) { i in
            storage.set(i, value: "\(Thread.current)")
        }
        
        // Thread 1
        concurentQueue.async {
            let temp = self.number
            self.number += 2
            print("#1: \(temp) + 2")
        }
        
        // Thread 2
        concurentQueue.async {
            let temp = self.number
            self.number *= 3
            print("#2: \(temp) * 3")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print(self.number)
        }
    }
}
