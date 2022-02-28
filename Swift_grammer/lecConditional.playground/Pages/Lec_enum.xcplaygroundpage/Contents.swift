import Foundation

enum CompassPoint {
    case north
    case south
    case east
    case west
}

/*
enum의 다른 표현형
enum CompassPoint {
    case north, south, east, west
}
*/

// 새로운 type 처럼 사용할 수 있다.
var direction = CompassPoint.east
// 열거형 타입이 추론하게 되면, 열거형 이름을 생략하고, 내부항목 이름만으로도 사용이 가능하다.
direction = .west

// switch 구문과 함께 사용할 경우
switch direction {
case .north:
    print("north")

case .south:
    print("south")
    
case .east:
    print("east")
    
case .west:
    print("west")
}
//result : west


// enum 에 원시값(RawValue)을 갖게 하는 방법
// enum 의 원시값으로는 1.Number Type(Int, Double, Float), 2.Character Type, 3.String Type
// 특정 타입으로 지정된 값을 갖도록 지정할 수 있다.
enum CompassPoint2 : String { // String 타입으로 원시값을 갖는다.
    case north = "북" // case 값을 원시값으로 초기화 시킨다.
    case south = "남"
    case east = "동"
    case west = "서"
}

// Character 모든 case에 원시값을 초기화 시켜주어야 한다.
// Int를 제외한 Number Type의 case가 정수값이 아닌 값일 경우 모든 값을 초기화해야한다.
// 원시값으로 Int로 사용할 경우, 가장 먼저 선언된 case 부터 0부터 1씩 증가된 값이 들어간다.

var direction2 = CompassPoint2.east

// 원시값(RawValue) 호출
switch direction2 {
case .north:
    print(direction2.rawValue)

case .south:
    print(direction2.rawValue)
    
case .east:
    print(direction2.rawValue)
    
case .west:
    print(direction2.rawValue)
}

// 원시값으로 열거형을 반환하게 하는 방법
// 열거형 instance 를 생성할 때, 매개변수로 원시값을 넘겨주면 된다.
let direction3 = CompassPoint2(rawValue: "남")
// result: south

// 연관값
enum PhoneError {
    case unknown
    case batteryLow(String) // 연관값은 소괄호안에 타입을 선언하여 지정한다. -> 연관값 String
    
}

let error = PhoneError.batteryLow("배터리가 곧 방전됩니다.")

//연관값 추출: Switch, if case 사용
switch error {
case .batteryLow(let message):
    print(message)
case .unknown:
    print("알 수 없는 에러입니다.")
}
// result: 배터리가 곧 방전됩니다.
