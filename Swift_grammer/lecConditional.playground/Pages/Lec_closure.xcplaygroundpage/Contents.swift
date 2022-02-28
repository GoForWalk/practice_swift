import Foundation

let hello = { () -> () in
    print("hello")
}

// closure 호출
hello()
// result: hello

let hello2 = { (name: String) -> String in
    return "Hello \(name)"
}

// closure는 전달인자 label을 따로 기재하지 않는다.
hello2("Gunter")
//result: "Hello Gunter"

// closure를 parameter로 받는 function
func doSomething(closure: () -> ()) {
    closure()
}

doSomething(closure: {() -> () in
    print("hello")
})

// 후행 closure
doSomething() {
    print("hello2")
}

// closure를 반환하는 함수
func doSomething2() -> () -> () {
    return { () -> () in
        print("hello4")
        
    }
}

doSomething2()()
// result: hello4

// 2중 후행 closure
func doSomething4(success: () -> (), fail: () -> ()) {
    
}

doSomething4 {
    
} fail: {
    
}
