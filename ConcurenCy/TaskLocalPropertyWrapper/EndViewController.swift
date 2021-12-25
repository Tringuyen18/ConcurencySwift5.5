//
//  EndViewController.swift
//  ConcurenCy
//
//  Created by Trí Nguyễn on 24/12/2021.
//

import UIKit

class EndViewController: UIViewController {
    
    // MARK: - Properties
//    var name: String?
    @TaskLocal static var currentName: String? // TaskLocal Property Wrapper
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DataRace
//        Task {
//            self.name = "iOS"
//            self.printName()
//
//            Task {
//                self.name = "iOS2"
//                self.printName()
//            }
//        }
        
        // #1
        Self.$currentName.withValue("iOS") { // Binding
            // Sharing Data
            Task { // task tree
                print("#1 - 0")
                await asyncPrintName() // iOS
                
                Task { // task child
                    print("#1 - 1")
                    await asyncPrintName() // iOS
                    
                    // update
                    await Self.$currentName.withValue("iOS2", operation: {
                        print("#1 - 1 - 1")
                        await asyncPrintName() // iOS2
                    })
                }
                
                Task { // task child
                    sleep(2) // 2s
                    print("#1 - 2")
                    await asyncPrintName() // iOS
                }
            }
            
            
            Task.detached {
                print("#3 - 0 ")
                await asyncPrintName() // Noname
                
                await Self.$currentName.withValue("iOS3", operation: {
                    print("#3 - 1")
                    await asyncPrintName() // iOS3
                })
            }
        }
        
//      #2
        Task {
            print("#4 - 0")
            await asyncPrintName() // Noname
        }
    }
    
//    func printName() {
//        if let name = self.name {
//            print("Name is \(name)")
//        } else {
//            print("Noname")
//        }
//    }
    
}

func asyncPrintName() async {
    if let name = await EndViewController.currentName {
        print("Current Name is \(name)")
    } else {
        print("Noname")
    }
}

