import RxSwift

let disposeBag = DisposeBag()
print("----- PublishSubject -----")

let publishSubject = PublishSubject<String>()
publishSubject.onNext("1. 안녕하세요!")

let 구독자1 = publishSubject
    .subscribe(onNext: {
        print("구독자1 : " + $0)
    })

publishSubject.onNext("2. hello")
publishSubject.on(.next("3. welcome"))

구독자1.dispose()

let 구독자2 = publishSubject.subscribe(
    onNext:{
        print("구독자2 : " + $0)
    })

publishSubject.onNext("4. 여보세요")
publishSubject.onCompleted()

publishSubject.onNext("5. call me back")

구독자2.dispose()


print("----- behaviorSubject -----")
enum SubjectError: Error {
    case error1
}

let behaviorSubject = BehaviorSubject<String>(value: "0. 초기값") // 초기값을 반드시 설정해야 한다.

behaviorSubject.onNext("1. First")
behaviorSubject.subscribe{
    print("첫번째 구독: ", $0.element ?? $0)
    
}
.disposed(by: disposeBag)

//behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe{
    print("두번째 구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

// behaviorSubject의 특징 : value 값을 뽑아낼 수 있다.
let value = try? behaviorSubject.value()
print("value : " , value!)

print("----- ReplaySubject -----")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2) // 2개의 버퍼를 갖는 replaySubject 선언

replaySubject.onNext("1. First")
replaySubject.onNext("2. Second")
replaySubject.onNext("3. Third")

replaySubject.subscribe{
    print("첫번째 구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.subscribe{
    print("두번째 구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.onNext("4. Fouth")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()


replaySubject.subscribe{
    print("세번째 구독: ", $0.element ?? $0)
}
.disposed(by: disposeBag)
