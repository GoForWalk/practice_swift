import Foundation
import RxSwift

// Observable 생성
print("-----Just-----")
Observable<Int>
    .just(1) // 하나의 element만 방출하는 단순한 형태의 observable sequence
    .subscribe( // Observable 은 Subscrible 을 하지 않으면 Event를 방출하지 않는다.
        onNext: {
            print($0)
        }
    )

print("-----Of1------")
Observable<Int>
    .of(1, 2, 3, 4, 5) // 다양한 event 들을 넣을 수 있다.
    .subscribe(onNext: {
        print($0)
    })

print("-----Of2------")
Observable.of([1, 2, 3, 4, 5]) // 타입 추론
    .subscribe(onNext: {
        print($0)
    })

print("----From-----")
Observable.from([1, 2, 3, 4, 5])
// from 은 Array만 param으로 받는다.
// Array의 Element들의 순서대로 꺼내서 방출
    .subscribe(onNext: {
        print($0)
    })

print("-----Subscrible 1-----")
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }
// subscribe 를 parameter 없이 선언했을 경우
// result: element가 어떤 event가 방출되었는지 알 수 있다.
//          이벤트가 종료되면 completed 를 방출한다.

print("-----Subscrible 2-----")
Observable.of(1,2,3)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }
// result: event의 element를 표현 -> onNext와 같은 결과

print("-----Subscrible 3-----")
Observable.of(1,2,3)
    .subscribe(onNext: {
        print($0)
    })

print("----- empty 1 -----")
Observable.empty()
    .subscribe {
        print($0)
    }
// empty 는 아무런 event를 방출하지 않는다.

print("----- empty 2 -----")
Observable<Void>.empty()
    .subscribe {
        print($0)
    }
// completed 만 방출
// empty 의 용도
// 1. 즉시 종료할 수 있는 observable을 방출하고 싶을 때,
// 2. 의도적으로 0개의 값을 가지는 observable을 방출하고 싶을 때

print("----- never -----")
Observable<Void>.never()
    .debug("never") // log를 남기는 method
    .subscribe {
        print($0)
    } onCompleted: {
        print("Completed")
    }
// 아무런 이벤트를 방출하지 않는다.

print("----- range -----")
// Array를 start부터 count 크기만큼 값을 방출하도록 하는 것
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("2 * \($0) = \(2 * $0)")
    })

print("----- dispose -----")
// Observable이 Subscribe 된 후, 강제로 종료시키는 메서드
Observable.of(1,2,3)
    .subscribe(onNext: {
        print($0)
    })
    .dispose() // 더이상 이벤트 방출이 되지 않는다.
    // event 가 무한이 발생하는 observable은

print("----- disposaBag -----")
let disposeBag = DisposeBag()
                
Observable.of(1,2,3)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)
// 모든 subscribe에 대한 정보를 disposebag에 저장 -> disposeBag이 할당 해제 될때, 모든 subscribe를 dispose
// 메모리 누수 방지

print("----- create 1 -----")
Observable.create { observer -> Disposable in // create 는 escaping closure
    observer.onNext(1)
//    observer.on(.next(1))
    observer.onCompleted() // obervable 종료
    observer.onNext(2)
    return Disposables.create()
}
.subscribe{
    print($0)
}
.disposed(by: disposeBag)

// Error 발생 시
print("----- create 2 -----")
enum MyError: Error {
    case anError
}

Observable<Int>.create { observer -> Disposable in // create 는 escaping closure
    observer.onNext(1)
    observer.onError(MyError.anError) // Error
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe(
    onNext: {
        print($0)
    },
    onError: {
        print($0.localizedDescription)
    },
    onCompleted: {
        print("Completed")
    },
    onDisposed: {
        print("discomposed")
    }
)
.disposed(by: disposeBag)
// result
// ----- create 2 -----
//1
//The operation couldn’t be completed. (__lldb_expr_18.MyError error 0.)
//discomposed

print("----- deffered 1 -----")
// Observable을 만드는 대신, 각 subscrible에게 새롭게 observable 항목을 제공하는 observable factory를 만드는 방식
Observable.deferred {
    Observable.of(1,2,3)
}
.subscribe{
    print($0)
}
.disposed(by: disposeBag)

print("---- deffered 2 -----")
var 뒤집기: Bool = false

let factory: Observable<String> = Observable.deferred {
    뒤집기 = !뒤집기
    
    if 뒤집기 {
        return Observable.of("👍")
    } else {
        return Observable.of("👎")
    }
}

for _ in 0...3 {
    factory.subscribe(
        onNext:{
            print($0)
        },
        onCompleted: {
            print("completed")
        },
        onDisposed: {
            print("disposed")
        }
    ).disposed(by: disposeBag)
}
