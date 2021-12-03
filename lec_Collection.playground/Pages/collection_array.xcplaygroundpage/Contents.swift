import UIKit

// Collection
// Array

// 1. Array 생성
var evenNumbers: [Int] = [2, 4, 6, 8]

// 2. Array 생성2
//let evenNumbers2: Array<Int> = [2, 4, 6, 8]

// Array 에 element 추가하는 방법
evenNumbers.append(10)
evenNumbers += [12, 14, 16]
evenNumbers.append(contentsOf: [18, 20])

// isEmpty
let isEmpty = evenNumbers.isEmpty

// element의 객수 확인
evenNumbers.count

//print(evenNumbers.first)

// 값이 없을 수 있기때문에 optional을 갖는다.
let firstItem = evenNumbers.first
let lastItem = evenNumbers.last

// optional binding
if let firstElement = evenNumbers.first {
 print("---> First item is: \(firstElement)")
}

// 비교가능한 element 들을 가질 때,
// 최소값 : min, 최대값 : max
evenNumbers.max()
evenNumbers.min()

// array 에서 item 가져오는 방법
evenNumbers[0]

var tenthItem = evenNumbers[9]

// fatal Error
//var twentithItem = evenNumbers[19]


// ------>

let firstThree = evenNumbers[0...2]
evenNumbers

// contains -> boolean
evenNumbers.contains(3)
evenNumbers.contains(4)

// insert(element, index)
evenNumbers.insert(1, at: 0)
evenNumbers

// element insert
evenNumbers[0] = -2
evenNumbers

// array 삽입
evenNumbers[0...2] = [-2, 0, 2]
evenNumbers

// swap
evenNumbers.swapAt(0, 1)

for num in evenNumbers {
    print(num)
}

// element 의 index와 elements
// 이거 중요
for (index, num) in evenNumbers.enumerated(){
    print("idx : \(index), value : \(num)")
}

// drop : 기존 array에 영향을 주지 않고, elements 를 분리해서 다른 array 생성.
evenNumbers.dropFirst(3)
evenNumbers

let firstThreeRemoved = evenNumbers.dropFirst(3)
firstThreeRemoved

let lastThreeRemoved = evenNumbers.dropLast(3)
lastThreeRemoved

let firstThreeElements = evenNumbers.prefix(3)
firstThreeElements

let lastThreeElements = evenNumbers.suffix(3)
lastThreeElements



// remove
//evenNumbers.remove(at: 0)
//evenNumbers.removeAll()
//evenNumbers = []


