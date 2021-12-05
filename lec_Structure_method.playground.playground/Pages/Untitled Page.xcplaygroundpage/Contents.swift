import UIKit

// Method
// 기능을 수행하는 코드 블럭
// Struct, Class 안에서 작동한다.

struct Lecture{
    var title: String
    var maxSturdent: Int = 10 // default = 10
    var numOfRegistered: Int = 0 // default = 0

    func remainSeats() -> Int {
        let remainSeats = lec.maxSturdent - lec.numOfRegistered
        return remainSeats
    }
    
    mutating func register(){ // mutating : struct에 관련된 method가 stored property를 변경시키는 경우 method 앞에 선언하야 한다.
        // 등록된 학생 수 증가시키기
        numOfRegistered += 1
    }
    
    // type property
    static let target: String = "Anybody to learn something"
    
    // type method
    static func 소속학원이름() -> String{
        return "FastCampus"
    }
    
}

var lec = Lecture(title: "iOS Basic")

// Struct 에 분리된 function
//func remainSeats(of lec: Lecture) -> Int {
//    let remainSeats = lec.maxSturdent - lec.numOfRegistered
//    return remainSeats
//}

lec.remainSeats()

lec.register()
lec.register()
lec.register()
lec.register()
lec.register()

lec.remainSeats()
Lecture.target
Lecture.소속학원이름()

// ----- about extension

struct Math {
    // type method
    static func abs(value: Int) -> Int {
        if value > 0 {
            return value
        } else {
            return -value
        }
    }
}


Math.abs(value: -20)

// Math Struct에 해당하는 method를 만들고 싶을 때
// extension 사용

// 제곱, 반값
extension Math {
    // 추가하려는 type method
    static func square(value: Int) ->  Int {
        return value * value
    }
    
    static func half(value: Int) -> Int {
        return value/2
    }
}

Math.half(value: 10)

// swift 에 정의된 Struct를 extension을 통해 custom 가능!!
// int -> struct

var value: Int = 10

extension Int {
    func square() ->  Int {
        return self * self
    }
    
    func half() -> Int {
        return self/2
    }
}

value.square()
value.half()


