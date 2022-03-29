import RxSwift
let disposeBag = DisposeBag()

print("----- ignoreElements -----")
let 취침모드😴 = PublishSubject<String>()

취침모드😴
    .ignoreElements() // elements emit을 하지 않는다.
    .subscribe {
        print("☀️", $0)
    }
    .disposed(by: disposeBag)

취침모드😴.onNext("🔊")
취침모드😴.onNext("🔊")
취침모드😴.onNext("🔊")
취침모드😴.onNext("🔊")

취침모드😴.onCompleted()

print("----- elementAt ------")
let 두번울면깨는사람 = PublishSubject<String>()

두번울면깨는사람
    .element(at: 2) // 두 번째 onNext만 emit, 나머지는 무시
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

두번울면깨는사람.onNext("🔊") // index 0
두번울면깨는사람.onNext("🔊") // index 1
두번울면깨는사람.onNext("👍") // index 2
두번울면깨는사람.onNext("🔊") // index 3
두번울면깨는사람.onNext("🔊") // index 4

두번울면깨는사람.onCompleted()

print("----- Filter ------") // 가장 대표적인 필터연산자.
Observable.of(1,2,3,4,5,6,7,8)
    .filter { $0 % 2 == 0 } // 방출하고자 하는 조건을 closure에 선언 (true 일때만 방출)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----- Skip -----") // 첫번째 요소부터 n번째 요소까지 skip (무시)
Observable.of(1,2,3,4,5,6,7,8)
    .skip(5)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

print("----- skipWhile -----")
Observable.of(1,2,3,4,5,6,7,8)
    .skip(while: { // 조건을 만족할때까지 skip 그 이후에 모든 element 방출
        // 해당 로직이 false가 되었을 때부터 element 방출
        $0 != 5
    })
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

print("----- skipUntil ------")
// 다른 observable 에 기반한 요소들을 dynamic 하게 filter하고 싶을 때!
let 손님 = PublishSubject<String>()
let 문여는시간 = PublishSubject<String>()

손님 // 현재 observable
    .skip(until: 문여는시간) // 다른 observable 이 onNext를 방출하기 전까지 현재의 모든 event 무시
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
//다른 observable onNext 전 -> evnet 무시
손님.onNext("😋")
손님.onNext("😋")
손님.onNext("😋")

문여는시간.onNext("땡")
// 다른 observable onNext 후 -> event 방출
손님.onNext("😎")

print("----- take ------")
Observable.of(1,2,3,4,5)
    .take(3) // 3개만 출력된다. skip의 반대개념
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----- takeWhile -----")
Observable.of(1,2,3,4,5,6,7)
    .take(while: {// 조건이 false가 될때까지 event 방출
        $0 != 5
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----- enumerated -----")
Observable.of(1,2,3,4,5)
    .enumerated() // 방출된 요소의 index 까지 알고 싶은 경우 -> index와 element를 tuple 형식으로 return
    .takeWhile {
        $0.index < 3
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----- takeUntil -----")
let 수강신청 = PublishSubject<String>()
let 신청마감 = PublishSubject<String>()

수강신청
    .take(until: 신청마감)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

수강신청.onNext("Swift")
수강신청.onNext("Java")
수강신청.onNext("typeScript")

신청마감.onNext("땡")

수강신청.onNext("C++")

print("----- distinctUntilChange -----")
Observable.of(1,1,2,2,3,3,4,4,1,1,1,1,5,5,6,6)
    .distinctUntilChanged() // 연달아서 반복된 element skip
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
