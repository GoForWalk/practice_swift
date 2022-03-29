import RxSwift
import RxCocoa
import UIKit
import PlaygroundSupport

let disposeBag = DisposeBag()

// buffer 연산자 계열: 언제, 어떻게 새로운 요소, 과거의 요소를 전달할지 컨트롤 할수 있게 해준다.

print("----- replay -----")
let sayHello = PublishSubject<String>()
let repeatingParrot = sayHello.replay(1) // bufferSize: 1

repeatingParrot.connect() // replay관련 연산자에서는 connect method를 사용해야 한다.

sayHello.onNext("1. hello")
sayHello.onNext("2. hi")

repeatingParrot.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)
// 구독하기 전 event도 bufferSize 만큼 event를 방출한다.

sayHello.onNext("3.안녕하세요")

print("----- replayAll -----")
// 구독전 모든 event를
let drStrange = PublishSubject<String>()
let timeStone = drStrange.replayAll()
timeStone.connect()

drStrange.onNext("도르마무")
drStrange.onNext("거래를 하러왔다.")

timeStone
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----- buffer -----")
//let source = PublishSubject<String>()
//
//var count = 0
//var timer = DispatchSource.makeTimerSource()
//
//timer.schedule(deadline:  .now() + 2, // 지금부터 2초 뒤
//               repeating:  .seconds(1) // 1초마다 반복
//)
//
//timer.setEventHandler {
//    count += 1
//    source.onNext("\(count)")
//}
//
////timer.resume()
//
//source
////    .buffer(timeSpan: <#T##RxTimeInterval#>, count: <#T##Int#>, scheduler: <#T##SchedulerType#>)
//    .buffer(
//        timeSpan: .seconds(2),
//        count: 2, // 방출할 최대 element 개수
//        scheduler: MainScheduler.instance
//    )
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("----- window -----")
//let maxObservableNum = 1
//let makeTime = RxTimeInterval.seconds(2)
//
//let window = PublishSubject<String>()
//
//var windowCount = 0
//let windowTimerSource = DispatchSource.makeTimerSource()
//
//windowTimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//windowTimerSource.setEventHandler {
//    windowCount += 1
//    window.onNext("\(windowCount)")
//}
////windowTimerSource.resume()
//
//window
//    .window( // observable 방출
//        timeSpan: makeTime,
//        count: maxObservableNum,
//        scheduler: MainScheduler.instance
//    )
//    .flatMap { windowObservable -> Observable<(index: Int, element: String)> in
//        return windowObservable.enumerated()
//    }
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("----- delaySubscription ------")
// 구독을 지연시키는 operator

//let delaySource = PublishSubject<String>()
//
//var delayCount = 0
//let delayTimeSource = DispatchSource.makeTimerSource()
//delayTimeSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//delayTimeSource.setEventHandler {
//    delayCount += 1
//    delaySource.onNext("\(delayCount)")
//}
//
//let delayTime = RxTimeInterval.seconds(5)
//
////delayTimeSource.resume()
//
//delaySource
//    .delaySubscription(
//        delayTime,
//        scheduler: MainScheduler.instance
//    )
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)
// event는 계속 방출되지만, 구독은 설정한 delay시간이 지난뒤부터 시행한다.

print("----- delay -----")
let delaySubject = PublishSubject<Int>()

var delayCount2 = 0
let delayTimerSource = DispatchSource.makeTimerSource()
delayTimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
delayTimerSource.setEventHandler {
    delayCount2 += 1
    delaySubject.onNext(delayCount2)
}

//delayTimerSource.resume()

delaySubject
    .delay(.seconds(5), scheduler: MainScheduler.instance)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
// delay 시간만큼 대기한뒤 sequence 시작

print("----- interval ------")
// DispatchSource로 구현했던 timer를 rx를 사용하여 구현할 수 있다.
//Observable<Int>
//    .interval( // 3초 간격으로 이벤트를 방출한다.
//        .seconds(3),
//        scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//      print($0)
//    })
//    .disposed(by: disposeBag)

print("----- timer -----")
// interval 보다 강력한 형태
// interval 과의 차이점 1. 구독의 delay 시점을 정할 수 있다. 2. sequence를 반복하는 기간를 지정할 수 있다. (default : 1초)
Observable<Int>
//    .timer(<#T##dueTime: RxTimeInterval##RxTimeInterval#>, period: <#T##RxTimeInterval?#>, scheduler: <#T##SchedulerType#>)
    .timer(.seconds(5), // 구독 시작하기 전까지 delay
           period: .seconds(2), // 2초 마다
           scheduler: MainScheduler.instance
    )
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----- timeOut -----")
// RxCocoa, UIKit 필요
// playgroundSupport -> 플레이그라운드에서도 UI 볼수 있게 해준다.

let tapOrErrorBtn = UIButton(type: .system)
tapOrErrorBtn.setTitle("눌러주세요", for: .normal)
tapOrErrorBtn.sizeToFit()

PlaygroundPage.current.liveView = tapOrErrorBtn

tapOrErrorBtn.rx.tap // RxCocoa
    .do(onNext: { // Observable 에 영향을 미치지 않으면서, 과정을 추적할 수 있다.
        print("tap")
    })
    .timeout(
        .seconds(5), //아무런 이벤트가 발생하지 않은 채로, 설정한 시간을 넘게되면, error를 발생시키고 observable 종료
        scheduler: MainScheduler.instance)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)
