import UIKit


// MARK: - DataRace
func cong1(_ count: Int) async -> Int {
    await withCheckedContinuation({ c in
        DispatchQueue.global().async {
            print("#1: \(count) - \(Thread.current)")
            c.resume(returning: count + 1)
        }
    })
}

func cong2(_ count: Int) async -> Int {
    await withCheckedContinuation({ c in
        DispatchQueue.global().async {
            print("2 \(count) - \(Thread.current)")
            c.resume(returning: count + 2)
        }
    })
}

//var count = 1
//
//async {
//    count = await cong1(count)
//    count = await cong2(count)
//    print("#3 \(count) - \(Thread.current)")
//}
//


// MARK: - Actor
actor MyNumber {
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
    
    func show() {
        cong1()
        value = 10 // Inside
        print(value)
    }
    
    func sendValue(with otherNumber: MyNumber) async {
        let value = self.value
        
        await otherNumber.setValue(value)
        
        setValue(0)
    }
    
    func setValue(_ temp: Int) {
        value = temp
    }
    
    func cong1() {
        value += 1
    }
    
    func cong2() {
        value += 2
    }
}

var number = MyNumber(value: 0)

// Outside
let temp = MyNumber(value: 1)
async {
    await temp.show()
}

async {
    await number.cong1()
}

async {
    await number.cong2()
}

async {
    print(await number.value)
}

// Actor different
let temp1 = MyNumber(value: 999)
let temp2 = MyNumber(value: 1)

async {
    await temp1.sendValue(with: temp2)
    
    
    print(await temp1.value)
    await temp2.show()
}

// MARK: Actor Protocol
protocol P {
    func show(value: Int) async
}

actor Counter {
    var value = 0
    
    func increment() {
        value += 1
    }
}

extension Counter: P {
    func show(value: Int) async {
        print(value)
    }
}

