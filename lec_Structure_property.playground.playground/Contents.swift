import UIKit


struct Person {
    // data
    // stored Property
    var firstName: String {
        // didSet을 사용하여 stored property에 대한 정보를 추적 가능
        // didSet은 stored property 에서만 사용 가능하다.
        willSet { // 값이 셋팅 되기 전에 실행
            print("willSet: \(firstName) --> \(newValue)")
        }
        
        didSet { // 값이 셋팅 된 이후에 실행
            print("didSet: \(oldValue) --> \(firstName)")
        }
    }
    
    var lastName: String
    
    // lazy를 쓰는 이유 : optimizing 하기 위해서 사용한다.
    // 필요 할 때만 부를 수 있기 때문에, cost의 사용을 고려하여, 최대한 미뤄서 사용자 접근을 원할 때, 사용하도록 할 수 있다.
    lazy var isPopular: Bool = {
        if fullName == "Jay Park" {
            return true
        } else {
            return false
        }
    }()
    
    // computed property -> var 만 가능
    // 값을 저장하지 않고, 기존에 있는 데이터로 값을 만들어 준다.
    // readOnly
//    var fullName: String {
//        get { // getter -> getter 만 있으면 readOnly
//            return "\(firstName) \(lastName)"
//        }
//
//        set { // setter
//            if let firstName = newValue.components(separatedBy: " ").first{
//                self.firstName = firstName
//            }
//            if let lastName = newValue.components(separatedBy: " ").last{
//                self.lastName = lastName
//            }
//        }
//    }
    
    // computed property
    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    // method
    func fullName_func() -> String {
        return "\(firstName) \(lastName)"
    }
    
    // type Property : 생성된 instance에 상관없이 struct/ class 의 타입 자체의 속성을 정하고 싶을 때 사용한다.
    // type property를 생성할 때는 static 사용
    static let isAlien: Bool = false
} // struct Person end

var person = Person(firstName: "Jason", lastName: "Lee")
//
//person.firstName
//person.lastName
//
//person.firstName = "Kim"
//person.lastName = "Jin"
//
//person.firstName
//person.lastName
//
//person.fullName
//
//// setter 삽압 시 fullName 변경 가능.
//person.fullName = "Jay Park"
//person.firstName
//person.lastName
//
//// Person(Structure) 자체의 속성
//Person.isAlien

// method vs. computed property
person.fullName_func()
person.fullName
