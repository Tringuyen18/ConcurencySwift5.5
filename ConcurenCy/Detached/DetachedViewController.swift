//
//  DetachedViewController.swift
//  ConcurenCy
//
//  Created by Trí Nguyễn on 22/12/2021.
//

import UIKit

class DetachedViewController: UIViewController {
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
                Task {
                    let infor = await getInfor()
                    print("Infor: \(infor)")
                }
        
//        Task {
//            let user = User()
//            await user.login()
//        }
        
//        doWork()
    }
    
    // MARK: - function
    func getName() async -> String {
        print("--> getName")
        return "iOS"
    }
    
    func getFriends() async -> Int {
        print("--> getFriend")
        return 9999
    }
    
    func saveInfor(name: String, friends: Int) async {
        print("Saving: \(name) - Friends: \(friends)")
    }
    
    func getInfor() async -> (String, Int) {
        let name = await getName()
        let friends = await getFriends()
        
        Task.detached {
            await self.saveInfor(name: name, friends: friends)
        }
        
        let infor = (name, friends)
        print("infor...")
        return infor
    }
    
    // MARK: - Detached Task in Actor
    actor User {
        func login() {
            Task.detached {
                if await self.authenticate(user: "tringuyen18", password: "trioilatri") {
                    print("Successfullly logged in")
                } else {
                    print("Sorry, something wrong.")
                }
            }
        }
        
        func authenticate(user: String, password: String) -> Bool {
            return true
        }
    }
    
    // MARK: - Ngữ cảnh hoạt động của Detached Tasks: time&amount
    func doWork() {
        Task.detached {
            for i in 1...10 {
                print("🔵 #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
                print("In Task 1: \(i)")
            }
        }
        
        Task.detached {
            for i in 1...10 {
                print("🔴 #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
                print("In Task 2: \(i)")
            }
        }
    }
}

extension OperationQueue {
    static func mainQueueChecker() -> String {
        return Self.current == Self.main ? "✅" : "❌"
    }
}
