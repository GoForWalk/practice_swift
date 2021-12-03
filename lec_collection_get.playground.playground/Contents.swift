import UIKit

var someArray: Array<Int> = [1,2,3,4]

// unique 한 값들을 포함하는 Set
// 중복된 값들은 하나로 표현한다.
// Array : [....] VS. Set : { ... } 으로 출력된다.
var someSet: Set<Int> = [1,2,3,1,5]

// 위 Set의 Element중에 1이 포함되어 1은 하나만 출력된다.

//Set의 option
someSet.isEmpty
someSet.count

someSet.contains(4)
someSet.contains(1)

someSet.insert(10)
someSet

someSet.remove(1)
someSet
