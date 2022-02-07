import UIKit

func practice() -> [Int] {
    
    var array: [Int] = []
    print("1 \(array)")

    do {
        array = [1,2,3]
        print("2 \(array)")
    } catch let error {
        print(error)
    }
    
    print("3 \(array)")
    return array
}

practice()
