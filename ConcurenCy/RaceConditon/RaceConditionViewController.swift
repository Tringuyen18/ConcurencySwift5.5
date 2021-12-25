//
//  RaceConditionViewController.swift
//  MainActor
//
//  Created by Trí Nguyễn on 19/11/2021.
//

import UIKit

class RaceConditionViewController: UIViewController {

    let concurrentQueue = DispatchQueue(label: "tri", attributes: .concurrent)
    
    var number = 0
    var strings: [String: Int] = [:]
    
    let serialQueue = DispatchQueue(label: "tri")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Thread 1
        concurrentQueue.async(flags: .barrier) { // Barrier
//            self.serialQueue.sync { // Lock Queue
                for _ in 0...10 {
                    self.number += 1
                    self.strings["🔴 \(self.number)"] = self.number
                    print("🔴: \(self.number)")
                }
//            }
        }
        
        // Thread2
        concurrentQueue.async(flags: .barrier) { // Barrier
//            self.serialQueue.sync { // Lock Queue
                for _ in 0...10 {
                    self.number += 1
                    self.strings["🔵 \(self.number)"] = self.number
                    print("🔵: \(self.number)")
                }
//            }
        }
        
        // show result after 3.0 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print("Number = \(self.number)")
            for item in self.strings {
                print(item)
            }
        }
    }

}
