//
//  StructConcurencyViewController.swift
//  MainActor
//
//  Created by Trí Nguyễn on 22/11/2021.
//

import UIKit

class StructConcurencyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Task {
//            await printStudentInfo2()
//        }
        
//        Task {
//            await printStudentInfo3()
//        }
        

        Task {
            await printStudentInfo4()
        }
        
    }
    
    // MARK: - Define
    enum MyError: Error {
        case anError
    }

    struct Student {
        var name: String
        var classes: [String]
        var scores: [Int]
    }
    

    // MARK: - functions
    func getStudentName() async -> String {
        await Task.sleep(1_000_000_000) // sleep 1s
        return "Tyler"
    }

    func getClasses() async -> [String] {
        await Task.sleep(1_000_000_000)
        return ["A", "B", "C", "D"]
    }

    func getScores() async -> [Int] {
        await Task.sleep(1_000_000_000)
        return [10, 9, 7, 8 , 9 , 9]
    }

    
    func getClassesAndScores() async -> ([String], [Int]) {
        async let classes = getClasses()
        async let scores = getScores()
        
        return await (classes, scores)
    }
    
    
    // MARK: - function2
    func getStudentName2() async throws -> String {
        await Task.sleep(1_000_000_000)
        return "Tyler"
    }
    
    func getClasses2() async throws -> [String] {
        throw MyError.anError
//        await Task.sleep(1_000_000_000)
//        return ["A", "B", "C", "D", "E", "F"]
    }
    
    func getScores2() async throws -> [Int] {
//        await Task.sleep(1_000_000_000)
//        if Task.isCancelled {
//            return [10, 9, 7, 8, 9, 9]
//        } else {
//            print("getScores2 will cancel")
//            throw MyError.anError
//        }
        
        try Task.checkCancellation()
        await Task.sleep(1_000_000_000)
        print("get scores2 calling")
        return [10, 9, 7, 8, 9, 9]
    }
    
    
    // MARK: - Async let
    func printStudentInfo() async {
           print("\(Date()): get name")
           let name = await getStudentName()
           print("\(Date()): get classes")
           let classes = await getClasses()
           print("\(Date()): get score")
           let scores = await getScores()
           
           print("\(Date()): Creating ....")
           let student = Student(name: name, classes: classes, scores: scores)
           print("\(Date()): \(student.name) - \(student.classes) - \(student.scores)")
       }
    
    func printStudentInfo2() async {
        print("\(Date()): get Name")
        async let name = getStudentName()
        
        print("\(Date()): get Classes")
        async let classes = getClasses()
        
        print("\(Date()): get Scores")
        async let scores = getScores()
        
        print("\(Date())Creating....")
        let student = await Student(name: name, classes: classes, scores: scores)
        print("\(Date()): \(student.name) - \(student.classes) - \(student.scores)")
    }
    
    
    
    func printStudentInfo3() async {
        print("\(Date()): get Name")
        async let name = getStudentName()
        
        print("\(Date()): get classes & scores")
        async let results = getClassesAndScores() // Tree
        
        print("\(Date()): Creating...")
        let student = await Student(name: name, classes: results.0, scores: results.1)
        print("\(Date()): \(student.name) - \(student.classes) - \(student.scores)")
    }

    func printStudentInfo4() async {
        
        do {
            print("\(Date()): get name")
            async let name = getStudentName2()
            
            print("\(Date()): get classes")
            async let classes = getClasses2()
            
            print("\(Date()): get scores")
            async let scores = getScores2()
            
            print("\(Date()): Creating....")
            let student = try await Student(name: name, classes: classes, scores: scores)
            print("\(Date()): \(student.name) - \(student.classes) - \(student.scores)")
        } catch {
            print("Error: \(error)")
        }
    }
}
