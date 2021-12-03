import UIKit

// Closure : 이름 없는 Method


//var multiplyClosure: (Int, Int) -> Int = { $0 * $1 }
var multiplyClosure: (Int, Int) -> Int = { a, b in
    return a * b
}

let result = multiplyClosure(4, 2)

// closure 가 강력한 이유
// function의 param으로 closure로 사용하는 경우.
func operateTwoNum(a: Int, b:Int, operation: (Int, Int) -> Int) -> Int {
    let result = operation(a, b)
    return result
}

operateTwoNum(a: 5, b: 2, operation: multiplyClosure)

var addClosure: (Int, Int) -> Int = { a, b in
    return a + b
}

operateTwoNum(a: 2, b: 5, operation: addClosure)

// function 의 parameter 안에 직접 closure는 삽압하는 경우(즉석으로 쓰기 좋다.)
operateTwoNum(a: 5, b: 2) { a, b in
    return a - b
}
// codeforeveryoneJoonwon+02@gmail.com

// Closure
// Capturing Values

// 내부 Scope & 외부 Scope
// 내부 Scope은 외부에서 사용할 수 없다.
// 하지만 closure에 있는 value는 내부에서 외부의 Scope의 변수를 가져와 사용할 수 있다.
// example

//if true {
//    let name = "Jason"
//    printClosure = {
//        print(name)
//    }
//}

// input & output 없는 closure
//let voidClosure: () -> ()
let voidClosure: () -> Void = {
    print("iOS developer")
}

voidClosure()

//capturing Values
var count = 0

// 밖에 있는 value를 바로 참조한다.
let incrementer = {
    count += 1
}

incrementer()
incrementer()
incrementer()
incrementer()

count

// closure 보강
// 기능을 수행하는 코드블럭의 특별한 타입
// -> 함수처럼 기능을 수행하는 코드블럭
// -> 함수와 다르게 이름이 없다.

// Closure -> 함수는 Closure의 한가지 타입
//  -> Global 함수
//  -> Nested 함수
//  -> Closure Expressions

// Swift 공식 사이트 (docs.swift.org)

// Closure -> in

// Example 1: Cho Simple Closure
//let simpleClosure = {
//}
//
//simpleClosure()

// Example 2: 코드블럭을 구현한 Closure
let simpleClosure = {
    print("Hello, closure")
}

simpleClosure()

// Example 3: In-put parameter를 받는 Closure
let inputClosure: (String) -> Void = { name in
    print("Hello, closure, 나의 이름은 \(name) 입니다.")
}

inputClosure("kevin")

// Example 4: value를 return 하는 Closure
let returnClosure: (String) -> String = { name in
    
    let message = "iOS 개발 만만세, \(name) 님 경제적 자유를 얻으실 거에요!!"
    return message
}

let result_1 = returnClosure("kevin")
print(result_1)

// Example 5: Closure를 파라미터로 받는 함수 구현
//func someSimpleFunc(choSimpleClosure: () -> Void){
//    print("함수에서 호출이 되었어요")
//}
//
//someSimpleFunc(choSimpleClosure: {
//    print("hello, corvid-19")
//})

func someSimpleFunc(choSimpleClosure: () -> Void){
    print("함수에서 호출이 되었어요")
    choSimpleClosure()
}


someSimpleFunc(choSimpleClosure: {
    print("hello, corvid-19")
})

// Example 6: Trailing Closure
func trailSimpleFunc(message: String, choSimpleClosure: () -> Void){
    print("함수에서 호출이 되었어요, 메시지는 \(message)")
    choSimpleClosure()
}

// 함수의 param의 마지막 인자가 closure인 경우, closure를 생략할 수 있다.
trailSimpleFunc(message: "로나로나 메로나", choSimpleClosure: {
    print("헬로 코로나 from closure")
})

trailSimpleFunc(message: "로나로나 메로나") {
    print("헬로 코로나 from closure")
}
