import Foundation

protocol SomeProtocol {
    
}

protocol SomeProtocol2 {
    
}

struct SomeStructure: SomeProtocol, SomeProtocol2 {
    
}

// 상속 받을 Class 가 있고 적용해야할 Protocol이 있다면 다음과 같이 표현한다.
/*
 class SomeClass: SomeSuperClass, FirstProtocol, AnotherProtocol {
 
 }
 */

// Protocol 의 Property 요구사항 정의 방법
// property 의 유형을 지정하지 않는다.
// 읽기, 쓰기 가능한 property : {get, set}
// readOnly property : {get}
protocol FirstProtocol {
    var name: Int { get set }
    var age: Int { get }
    
    // type property 선언할 경우 -> static
    static var someTypeProperty: Int {get set}
} //: FirstProtocol

protocol FullyNames {
    var fullName: String {get set}
    func printFullName()
}

struct Person: FullyNames {
    var fullName: String
    func printFullName() {
        print(fullName)
    }
}

// method를 정의할 때 method 안의 내용은 지정하지 않지만, method의 parameter는 정해줘야 한다.
// 이때 parameter의 default 값은 지정할 수 없다.
protocol SomeProtocol3 {
    func someTypeMethod()
}

// initializer 요구사항
// protocol은 생성자도 요구사항으로 지정할 수 있다.
// 생성자 키워드 & parameter 를 지정하면 된다.
protocol SomeProtocol4 {
    init(someParameter: Int)
}

protocol SomeProtocol5 {
    init()
}

// class가 protocol의 init을 채택하기 위해서는 required 식별자는 사용해야 한다.
// structure 는 class와 다르게 protocol의 init을 채택하는데 required 식별자를 필요로 하지 않는다.
// final class 의 경우에도 required 식별자를 사용할 필요가 없다.
class SomeClass: SomeProtocol5 {
    required init() {
        
    }
}
