import Foundation


/*
guard 조건 else {
 // 조건이 false 이면 else 구문이 실행되고
 return or throw or break를 통해 이 후 코드를 실행하지 않도록 한다.
 }
 */

func guardTest(value: Int?) {
    guard let value = value else {return}
    print(value)
}

guardTest(value: 2) // result: 2
guardTest(value: nil) // return

