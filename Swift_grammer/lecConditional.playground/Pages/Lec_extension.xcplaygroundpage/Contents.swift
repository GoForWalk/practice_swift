import Foundation

/*
extension SomeType {
    // 추가 기능
}
*/

extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
    
    var isOdd: Bool {
        return self % 2 == 1
    }
}

var settingNumber = 3
settingNumber
settingNumber.isOdd
settingNumber.isEven

extension String {
    func convertToInt() -> Int? {
        return Int(self)
    }
}

var stringValue = "0"
stringValue.convertToInt()
