import UIKit

let numbers: [Int] = [9, 6, 11, 56, 1, 8, 43, 99]

let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]

let sortedNums = numbers.sorted(by: {(num1: Int, num2: Int) -> Bool in
    return num1 > num2
})

sortedNums

// 타입추론
let sortedNums2 = numbers.sorted(by: {num1, num2 in
    return num1 > num2
})

sortedNums2

// 후위 클로져 (Trialing Closures)
// condition: 함수의 마지막 param으로
func someFuntionThatTakesClosure(closure: () -> Void){
    // () -> Void 생략가능
}

let sortedNums3 = numbers.sorted {$0 > $1}
sortedNums3

let strings = numbers.map { number -> String in
    var number = number
    var output = ""
    
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    
    return output
}

strings

// Capturing Value
//클로저는 특정 문맥의 상수나 변수의 값을 캡쳐할 수 있습니다.
//원본 값이 사라져도 클로져의 body안에서 그 값을 활용할 수 있습니다.



// Function / Function Types as Return types (함수를 반환하는 함수)
func stepForward(_ input: Int) -> Int {
    return input + 1
}

func stepBackward(_ input: Int) -> Int {
    return input - 1
}

func chooseStepFuntion(backward: Bool) -> (Int) -> Int {
    return backward ? stepBackward : stepForward
}

// 참고: 중첩함수(Nested Function)



// 자동 클로져(AutoClosure)
/*
 자동클로저는 인자 값이 없으며 특정 표현을 감싸서 다른 함수에 전달 인자로 사용할 수 있는 클로저
 자동클로저는 클로저를 실행하기 전까지 실제 실행이 되지 않는다.
 
 */
 
