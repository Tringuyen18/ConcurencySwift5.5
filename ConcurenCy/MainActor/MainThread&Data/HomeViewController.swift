//
//  HomeViewController.swift
//  ConcurenCy
//
//  Created by TrĆ­ Nguyį»n on 23/12/2021.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel = HomeViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    let serialQueue = DispatchQueue(label: "serialQueue") // Lock Queue
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.$image // Binding
            .assign(to: \.image, on: imageView)
            .store(in: &subscriptions)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        DispatchQueue.global(qos: .userInteractive).async {
        //            print("šµ - MainThread is \(OperationQueue.mainQueueCheckerr())")
        //            self.changeImageBackground(.blue, title: "šµ")
        //        }
        
        
        //        DispatchQueue.concurrentPerform(iterations: 10) { i in
        //            if i % 2 == 0 {
        //                print("šµ #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
        //                changeImageBackground(.blue, title: "šµ")
        //            } else {
        //                print("š“ #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
        //                changeImageBackground(.red, title: "š“")
        //            }
        //        }
        
        
        // MARK: - async/await
        //        async {
        //            for i in 1..<10 {
        //                print("šµ #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
        //                await changeImageBackground(.blue, title: "šµ")
        //            }
        //        }
        //
        //        async {
        //            for i in 1..<10 {
        //                print("š“ #\(i) - MainThread is \(OperationQueue.mainQueueChecker())")
        //                await changeImageBackground(.red, title: "š“")
        //            }
        //        }
        
        // MARK: - Detach
        //        detach { [self] in
        //            print("šµ #\(0) - MainThread is \(OperationQueue.mainQueueChecker())")
        //            await changeImageBackground(.blue, title: "šµ")
        //        }
        //
        //        detach { [self] in
        //            print("š“ #\(0) - MainThread is \(OperationQueue.mainQueueChecker())")
        //            await changeImageBackground(.red, title: "š“")
        //        }
        
        
        // Data Race on Thread UI
        DispatchQueue.concurrentPerform(iterations: 100) { i in
            detach {
                if i % 2 == 0 {
                    print("šµ #\(0) - MainThread is \(OperationQueue.mainQueueChecker())")
                    await self.changeImageBackground(.blue, title: "šµ")
                } else {
                    print("š“ #\(0) - MainThread is \(OperationQueue.mainQueueChecker())")
                    await self.changeImageBackground(.red, title: "š“")
                }
            }
        }
    }
    
    // MARK: -Actions
    @IBAction func start(_ sender: Any) {
        // Completion handle
//        viewModel.loadImage { image in
//            self.imageView.image = image
//        }
        
        // Publisher
//        viewModel.loadImage2()
        
        // Async/await
        async {
            await viewModel.loadImage3()
        }
    }
    
    // Function
    @MainActor
    func changeImageBackground(_ color: UIColor, title: String) {
        print("\(title) - MainThread is \(OperationQueue.mainQueueCheckerr())")
        self.imageView.backgroundColor = color
    }
}

// Check MainThread
extension OperationQueue {
    static func mainQueueCheckerr() -> String {
        return Self.current == Self.main ? "ā" : "ā"
    }
}
