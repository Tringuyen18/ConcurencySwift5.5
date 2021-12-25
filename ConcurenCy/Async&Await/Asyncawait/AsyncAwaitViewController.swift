//
//  AsyncAwaitViewController.swift
//  MainActor
//
//  Created by Trí Nguyễn on 19/12/2021.
//

import UIKit

enum MyError: Error {
    case soBehon
    case soAm
    case bangKhong
}

enum APIIError: Error {
    case anError
}

class AsyncAwaitViewController: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        async {
            await tinh()
        }
        
        async {
            try await tinh2()
        }
        
        async {
            let items = await fetchLatesNews()
            for item in items {
                print(item)
            }
        }
    }
    
    func cong(a: Int, b: Int) async -> Int {
        a + b
    }
    
    func nhan(a: Int, b: Int) async -> Int {
        a * b
    }
    
    func tinh() async {
        let A = 10
        let B = 20
        print("...#1")
        let Cong = await cong(a: A, b: B)
        print("...#2")
        let Nhan = await nhan(a: A, b: B)
        print("2 kq ne: \(Cong) & \(Nhan)")
    }
    
    
    func tru(a: Int, b: Int) async throws -> Int {
        if a < b {
            throw MyError.soBehon
        } else {
            return a - b
        }
    }
    
    func chia(a: Int, b: Int) async throws -> Float {
        if b == 0 {
            throw MyError.bangKhong
        } else {
            return Float(a) / Float(b)
        }
    }

    func tinh2() async {
        let A = 30
        let B = 20
        
        do {
            print("...#1")
            let Tru = try await tru(a: A, b: B)
            print("...#2")
            let Chia = try await chia(a: A, b: B)
            print("2 kq ne: \(Tru) & \(Chia)")
        } catch {
            print("Error nhe")
        }
    }
    
    
    //  Await Checked Continuation
    func fetchLatesNews() async -> [String] {
        await withCheckedContinuation({ c in
            c.resume(returning: ["iOS, Developer"])
        })
    }
    
    
}
