import Foundation

// error protocol
// enum으로 error의 속성을 표현하기 용이하다.
enum PhoneError: Error { // Error protocol 채택
    case unknown
    case batteryLow(batteryLevel: Int)
}

// 오류 발생시키기 : throw
//throw PhoneError.batteryLow(batteryLevel: 20)
// result:
// Playground execution terminated: An error was thrown and was not caught:
// ▿ PhoneError
//   ▿ batteryLow : 1 element
//     - batteryLevel : 20

// throws
// throwing 함수는 함수 내부에서 발생한 오류를 함수가 호출된 곳에 오류를 전파한다. throwing 함수만 에러 전파가 가능하다.
func checkPhoneBatteryStatus(batteryLevel: Int) throws -> String { // throwing 함수
    guard batteryLevel != -1 else { throw PhoneError.unknown } // guard 문을 통과하지 못하면, throw로 에러를 발생시킨다.
    guard batteryLevel > 20 else { throw
        PhoneError.batteryLow(batteryLevel: 20)
    }
    // 두 guard 문을 모두 통과해야 정상적으로 func가 진행된다.
    // 이 함수는 error를 발생 시킬 수도 있기 때문에, do - catch, try?, try!를 사용하여 오류를 처리할 수 있다.
    return "배터리 상태가 정상입니다."
}

// do - catch
/*
 do {
    try 오류 발생 가능 코드
 } catch 오류 패턴 {
    처리코드
 }
 */

do {
    try checkPhoneBatteryStatus(batteryLevel: 20)
} catch PhoneError.unknown {
    print("알 수 없는 에러입니다.")
} catch PhoneError.batteryLow(let batteryLevel) {
    print("배터리 전원 부족, 남은 배터리 \(batteryLevel)%")
} catch {
    print("그 외 오류발생: \(error)") // catch 구문을 사용하면 error
}
// result: 배터리 전원 부족, 남은 배터리 20%


// try? & try!
// 오류를 optional 값으로 처리 -> 동작 중 오류 발생시 해당 내용을 nil로 처리한다.
let status = try? checkPhoneBatteryStatus(batteryLevel: -1) // error 발생 : PhoneError.unknown
print(status)
// result : nil

let status2 = try? checkPhoneBatteryStatus(batteryLevel: 30)
print(status2)
// result : Optional("배터리 상태가 정상입니다.")
// try? 사용시 에러가 없다면, 해당 값은 optional 값으로 출력된다.

let status3 = try! checkPhoneBatteryStatus(batteryLevel: 30)
// error 가 발생하지 않을 것이라고 개발자가 확신하는 상황에서 ! 사용
// 만약, ! 사용시 에러가 발생하면, runtime error 가 발생한다.
print(status3)
// result: 배터리 상태가 정상입니다.

