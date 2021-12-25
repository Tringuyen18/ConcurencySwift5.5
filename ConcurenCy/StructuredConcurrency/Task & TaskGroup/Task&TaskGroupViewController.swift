//
//  Task&TaskGroupViewController.swift
//  MainActor
//
//  Created by Trí Nguyễn on 22/11/2021.
//

import UIKit

class Task_TaskGroupViewController: UIViewController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

//        Task {
//            print(await simpleTask.value)
//        }
        
//        Task {
//            await doSomething()
//        }
        
//        printFibonacciSequence()
        
//        Task {
//            await printFibonacciSequence2()
//        }
        
    
//        Task {
//            await cancelSleepTask()
//        }
//
        // MARK: - Task Group
//        Task {
//            await printMessage()
//        }
        
        Task {
            await printAllWeatherCurrent()
        }
    }
    
    let simpleTask = Task { () -> String in
        return "a simple task"
    }
    
    func doSomething() async {
        print("Begin")
        print(await simpleTask.value)
        print("End")
    }
    
    // MARK: - Fibonacci
    func fibonacci(of number: Int) -> Int {
        var first = 0
        var second = 1
        
        for _ in 0..<number {
            let previous = first
            first = second
            second = previous + first
        }
        return first
    }
    
    
    func printFibonacciSequence() {
        var number = [Int]()
        
        for i in 0..<50 {
            let result = fibonacci(of: i)
            number.append(result)
        }
        
        print("🔵 the first 50 numbers in the Fibonacci sequence are: \(number)")
    }
    
    
    // MARK: - Task
    func printFibonacciSequence2() async {
        let task1 = Task { () -> [Int] in
            var number = [Int]()
            
            for i in 0..<50 {
                let result = fibonacci(of: i)
                number.append(result)
            }
            
            return number
        }
        
        let result = await task1.value
        print("⚪️ the first 50 numbers in the Fibonacci sequence are: \(result)")
    }
    
    
    func cancelSleepTask() async {
        let task = Task { () -> String in
            print("Starting")
            try await Task.sleep(nanoseconds: 1_000_000_000) // sleep 1s
            try Task.checkCancellation() // Tu huy
            return "Done"
        }
        
        // The task has started, but we'll cancel it while it sleeps
        task.cancel()
        
        do {
            let result = try await task.value
            print("Result: \(result)")
        } catch {
            print("Task was cancelled.")
        }
    }

    
    // MARK: - TaskGroup
    func printMessage() async {
        let string = await withTaskGroup(of: String.self) { group -> String in
            group.addTask { "Hello" }
            group.addTask { "From" }
            group.addTask { "A" }
            group.addTask { "Task" }
            group.addTask { "Group" }
            
            var collected = [String]()
            
            for await value in group {
                collected.append(value)
            }
            
            return collected.joined(separator: " ")
        }
        
        print(string)
    }
    
    // MARK: - With Error
    enum LocationError: Error {
        case unknown
    }
    
    func getWeatherReading(for location: String) async throws -> [Double] {
        switch location {
        case "London":
            return (1...1000).map { _ in Double.random(in: 6...26) }
        case "Rome":
            return (1...1000).map { _ in Double.random(in: 10...32) }
        case "Manchester":
            return (1...1000).map { _ in Double.random(in: 12...20) }
        default:
            throw LocationError.unknown
        }
    }
    
    func printAllWeatherCurrent() async {
        do {
            print("Calculating average weather...")
            
            let result = try await withThrowingTaskGroup(of: [Double].self) { group -> String in
                
                group.addTask {
                    try await self.getWeatherReading(for: "London")
                }
                
                group.addTask {
                    try await self.getWeatherReading(for: "Rome")
                }
                
                group.addTask {
                    try await self.getWeatherReading(for: "Manchester")
                }
                
                // Convert our array of arrays into a single array of doubles
                let allValues = try await group.reduce([], +)
                
                // Calculate the mean average of all our doubles
                let average = allValues.reduce(0, +) / Double(allValues.count)
                return "Overall average temperature is \(average)"
            }
            print("Done: \(result)")
            
        } catch {
            print("Error calculating data.")
        }
    }
}
