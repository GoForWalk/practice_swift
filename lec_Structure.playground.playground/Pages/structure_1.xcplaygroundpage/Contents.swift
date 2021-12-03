import UIKit

// 나와 가장 가까운 편의점 찾기!

// 맨 처음 시작시... 코드

// 현재 스토어 위치들
// ---- improving Code with Structure
struct Location {
    let x: Int
    let y: Int
}


// 거리 구하는 함수
//func distance(current: (x: Int, y: Int), target: (x: Int, y: Int)) -> Double {
func distance(current: Location, target: Location) -> Double {
    // 피타고라스
    let distanceX = Double(target.x - current.x)
    let distanceY = Double(target.y - current.y)
    let distance = sqrt(distanceX * distanceX + distanceY * distanceY)
    return distance
}

struct Store {
    let loc: Location
    let name: String
    let deliveryRange = 2.0
    
    func isDeliverable(userLoc: Location) -> Bool {
        let distanceToStore = distance(current: userLoc, target: loc)
        return distanceToStore < deliveryRange
    }
}

//type: tuple
//let store1 = (x: 3, y:5, name: "gs")
//let store2 = (x: 4, y:6, name: "seven")
//let store3 = (x: 1, y:7, name: "cu")

// --- improved : tuple에 location(structure)과 name 만 포함
let store1 = Store(loc: Location(x: 3, y: 5), name: "gs")
let store2 = Store(loc: Location(x: 4, y: 6), name: "seven")
let store3 = Store(loc: Location(x: 1, y: 7), name: "cu")

// 가장 가까운 스토어 구해서 프린트 하는 함수
func printClosestStore(currentLocation: Location, stores: [Store]) {
    var closestStoreName = ""
    var closestStoreDistance = Double.infinity
    var isDeliverable = false
    
    for store in stores {
        let distanceToStore = distance(current: currentLocation, target: store.loc)
        closestStoreDistance = min(distanceToStore, closestStoreDistance)
        if closestStoreDistance == distanceToStore {
            closestStoreName = store.name
            isDeliverable = store.isDeliverable(userLoc: currentLocation)
        }
    }
    print("Closest store: \(closestStoreName), isDeliverable: \(isDeliverable)")
}

// Stores Array 세팅, 현재 내 위치 셋팅
let myLocation = Location(x: 4, y: 5)
let stores = [store1, store2, store3]

// 함수 이용해서 출력하기
printClosestStore(currentLocation: myLocation, stores: stores)


// --------------------
// improve Code (Using Structure)

// 정보를 단위로 묶는다. 
// - make Location struct
// - make Store struct


// --- Class vs. Structure

class PersonClass {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

struct personStruct {
    var name: String
    var age: Int
    
    init(name: String, age: Int){
        self.name = name
        self.age = age
    }
}

let pClass1 = PersonClass(name: "Jason", age: 5)
let pClass2 = pClass1
pClass2.name = "Hey"

// 같은 곳을 참조한다.
pClass1.name
pClass2.name

var pStruct1 = personStruct(name: "jason", age: 5)
var pStruct2 = pStruct1
pStruct2.name = "Hey"

// 각각의 stack 을 갖는다.
pStruct1.name
pStruct2.name
