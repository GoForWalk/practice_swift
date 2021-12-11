import UIKit

struct Person {
    var firstName: String
    var lastName: String
    
    // 생성자 사용 가능 & 안써도 된다.
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    mutating func uppercaseName (){ // mutating
        firstName = firstName.uppercased()
        lastName = lastName.uppercased()
    }
}

class PersonClass {
    var firstName: String
    var lastName: String
    
    // class 객체를 생성 할 때 사용하는 생성함수
    // 생성자 -> class 는 필수
    init(firstName: String, lastName: String){
        self.firstName = firstName
        self.lastName = lastName
    }
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    func uppercaseName (){ // class 에서는 mutating 사용 X
        firstName = firstName.uppercased()
        lastName = lastName.uppercased()
    }
}

var personStruct1 = Person(firstName: "kevin", lastName: "chung")
var personStruct2 = personStruct1

var personClass1 = PersonClass(firstName: "kevin", lastName: "chung")
var personClass2 = personClass1

personStruct2.firstName = "Jay"
personStruct1.firstName
personStruct2.firstName

personClass2.firstName = "Jay"
personClass1.firstName
personClass2.firstName

// Class를 새로 선언하면, 새로운 instance를 만들어서 다른곳을 pointing 한다.
personClass2 = PersonClass(firstName: "Bob", lastName: "Lee")
personClass2.firstName
personClass1.firstName


personClass1 = personClass2
personClass2.firstName
personClass1.firstName
