import UIKit

var carName: String? = "Tesla"

carName = nil
carName = "Tank"

// optional
// 아주 간단한 예제
// 최애하는 영화배우의 이름을 담는 변수를 작성

var actorName: String? = nil

// 다음 코드의 타입
let num = Int("10")

//정답: Int 형 -> casting 되어서 가능!!


// 고급기능 4가지

// Forced unwrapping
// Optional binding (if let)
// Optional binding (guard)
// Nil coalescing > 값이 없으면 디폴트 값을 부여하는 것

// optional이 남아있다
// print(carName)
// 결과 : Optional("Tank")

// optional 안의 value만 가져와서 print
// forced umwrapping
print(carName!)

carName = nil

// optional binding (if let)
if let unwrappedCarName = carName {
    print(unwrappedCarName)
} else {
    print("car Name 없다.")
}

// String -> Int parsing
//func printParseInt(from: String){
//    if let parsedInt = Int(from){
//        print(parsedInt)
//    } else {
//        print("didn't parsed to Int")
//    }
//}

//printParseInt(from: "100")
//printParseInt(from: "myname")

// using guard
// guard : wrapping 할 optional 이 존재하나, 여부 확인
func printParseInt(from: String){
    guard let parsedInt = Int(from) else {
        print("can't parsed to Int")
        return
    }
    print(parsedInt)
}

printParseInt(from: "100")
printParseInt(from: "hi")

// ?? : carName 이 nil 이면 default 값을 정해준다.
// 이전 optional에 값이 존재 했다면, ?? 로 부여한 default 값은 무시된다.
carName = "model 3"
let myCarName: String = carName ?? "model S"


// 도전 과제
// 1. 최애 음식이름을 담는 변수를 작성(String?)
// 2. optional binding을 사용하여 값을 확인하기.
// 3. nickname을 받아서 출력하는 함수 만들기, 조건 입력 파라민터는 String?

var favoriteFoodName: String? = nil

favoriteFoodName = "치킨"

print(favoriteFoodName!)

func printFavoriteFoodName(food favoriteFoodName: String?){
    guard let foodName = favoriteFoodName else {
        print("좋아하는 음식이 없습니다.")
        return
    }
    print(foodName)
}

printFavoriteFoodName(food: nil)






