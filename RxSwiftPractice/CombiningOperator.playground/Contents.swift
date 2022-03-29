import RxSwift

let disposeBag = DisposeBag()

print("----- startWith -----")
let 노랑반 = Observable<Int>.of(1,2,3)

노랑반
    .enumerated()
    .map({ index, element in
       return element + 5
        
    })
    .startWith(0,1) // sequence의 첫번째 event를 지정한다. 값의 타입을 observable의 타입과 일치시켜야한다.
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----- concat1 -----")
let 노랑반어린이들 = Observable.of("🥴", "😈", "🤪")
let 선생님 = Observable.of("🥸선생님")

let 줄서서걷기 = Observable
    .concat([선생님, 노랑반어린이들])

줄서서걷기.subscribe(onNext: {
    print($0)
})

print("----- concat2 -----")
선생님.concat(노랑반어린이들)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----- concatMap -----")
// flatMap : observable sequence가 구독을 위해서 return이 되고, 방출된 observable들은 합쳐지게 된다.
// concatMap : 각각의 sequence가 다음 sequence가 구독되기 전에, 합쳐지는 것을 의미한다.
let 어린이집: [String : Observable<String>] = [
    "노랑반" : Observable.of("🥴", "😈", "🤪"),
    "파랑반" : Observable.of("👶🏻", "👶🏾")
]

Observable.of("노랑반", "파랑반")
    .concatMap { 반 in
        어린이집[반] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----- merge1 -----")
let 강북 = Observable.from(["강북구", "성북구", "동대문구", "종로구"])
let 강남 = Observable.from(["강남구", "강동구", "영등포구", "양천구"])
// 두 Observable 을 합치는 방법

Observable.of(강북, 강남)
    .merge()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
// sequence의 event 순서가 보장되지 않는다.
// 각각의 sequence에서 도착하는대로 바로 이벤트 방출
// 합쳐질 두 sequence 중 하나라도 Error를 포함하면,

print("----- merge2 -----")
Observable.of(강북, 강남)
    .merge(maxConcurrent: 1) // merge를 할때, 몇개의 sequence를 최대로 활용할것인지에 대한 설정 -> 순서가 보장된 것처럼 보인다.
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
// -> 네트워크 요청이 많아질때 리소스를 제한하거나, 연결수를 제한할 수 있다.

print("----- combineLatest1 -----")
// Sequence의 최종값을 받아서 합치는 경우
// 사용처: 여러 textField를 한번에 관찰하고, 값을 결합하거나, 여러 소스들의 상태를 보는 앱에 사용.
let 성 = PublishSubject<String>()
let 이름 = PublishSubject<String>()

let 성명 = Observable
    .combineLatest(성, 이름) { 성, 이름 in
        성 + 이름
    }

성명
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

// 성, 이름의 갯수가 일치하지 않는다.
성.onNext("김") // 이름에 대한 observable의 onNext까지 대기.
이름.onNext("똘똘") // 성명: onNext 시작
이름.onNext("영수") // 이름의 최신값 변경 -> 똘똘은 사라진다.
이름.onNext("은영")
성.onNext("박") // 성의 최신값 변경
성.onNext("이")
성.onNext("조")

print("----- CombineLastest2 -----")
let 날짜표시방식 = Observable<DateFormatter.Style>.of(.short, .long)
let 현재날짜 = Observable<Date>.of(Date())

let 현재날짜표시 = Observable
    .combineLatest(
        날짜표시방식,
        현재날짜,
        resultSelector: { 형식, 날짜 -> String in
            let dataFormatter = DateFormatter()
            dataFormatter.dateStyle = 형식
            return dataFormatter.string(from: 날짜)
            
        })
현재날짜표시.subscribe(onNext: {
    print($0)
})
.disposed(by: disposeBag)
// combineLatest에는 총 8가지 Observable을 받을 수 있다.

print("----- combineLatest3 -----")
let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()

let fullName = Observable
    .combineLatest([firstName, lastName]) { name in
        name.joined(separator: " ")
        
    }
fullName.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

lastName.onNext("Kim")
firstName.onNext("Paul")
firstName.onNext("Steve")
firstName.onNext("Stella")

print("----- zip -----")
// 순서를 보장하면서, 두 observable을 합친다.
// zip 은 각각의 sequence에서 event를 방출할떄 까지 기다리다가 모든 source가 방출하면 결과값을 방출한다.
// -> 여러 source 중 하나의 sequence가 종료되면, Complete 된다.
// 총 8개의 source를 조합할 수 있다.
// resultSelector를 통해서 표현하는 방식이 있다.
enum WinLose {
    case win
    case lose
}

let matchUp = Observable<WinLose>.of(.win, .win, .lose, .lose, .win)
let athlete = Observable<String>.of("🇰🇷", "🇺🇸", "🇺🇦") // 우크라이나가 끝나면 result observable complete

let result = Observable
    .zip(matchUp, athlete) { matchUp, athlete in
        return athlete + "선수: " + "\(matchUp)"
    }

result.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

// 지금까지는 observable들을 합치는 방법에 대한 operator
// 이제부터는 trigger 역할을 하는 operator 에 대한 내용.

print("----- withLatestFrom -----")
let trigger = PublishSubject<Void>()
let runner = PublishSubject<String>()

trigger
    .withLatestFrom(runner)
//    .distinctUntilChanged() // .sample 처럼 event를 한번만 방출하고 싶을 때 사용.
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

runner.onNext("run!!")
runner.onNext("run!!, run!!")
runner.onNext("run!!, run!!, run!!")
trigger.onNext(Void()) // result: run!!, run!!, run!!
// trigger sequence가 방출되지 않으면, runner sequence 는 방출될 수 없다.
// runner 의 가장 최신 event가 방출된다. 그 이전은 무시!!
trigger.onNext(Void())

print("----- sample -----")
// event 방출을 한번만 한다.
let start = PublishSubject<Void>()
let f1Player = PublishSubject<String>()

f1Player
    .sample(start)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

f1Player.onNext("🚗")
f1Player.onNext("🚗🚗🚗")
f1Player.onNext("🚗🚗🚗🚗🚗")
start.onNext(Void()) // result: 🚗🚗🚗🚗🚗
start.onNext(Void()) // emit X
start.onNext(Void()) // emit X
// f1Player의 가장 최신 event만 한번 방출되었다.

// Switch 역할을 하는 operator
print("----- amb(ambiguous) -----")
let bus1 = PublishSubject<String>()
let bus2 = PublishSubject<String>()

let busStation = bus1.amb(bus2)

busStation.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

bus2.onNext("bus2 - passenger1") // bus2가 이벤트를 방출한다. -> bus1에 대한 event는 방출하지 않는다.
bus1.onNext("bus1 - passenger1")
bus1.onNext("bus1 - passenger2")
bus2.onNext("bus2 - passenger2")
bus2.onNext("bus2 - passenger3")
bus1.onNext("bus2 - passenger3")

// amb는 bus1과 bus2 모두 구독한다.
// 모두 구독하다가, 먼저 이벤트를 방출하는 sequence의 이벤트만 방출한다.

print("----- switchLatest -----")
// source observable로 들어온 마지막 sequence의 item만 구독한다.
let student1 = PublishSubject<String>()
let student2 = PublishSubject<String>()
let student3 = PublishSubject<String>()

let handsUp = PublishSubject<Observable<String>>()

let classroom = handsUp.switchLatest() // handsUp이 source observable이다.

classroom.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

handsUp.onNext(student1) // source observable에 student1이 들어옴 -> student1 이외의 다른 sequence는 무시
student1.onNext("student1: hello~!") // emit
student2.onNext("student2: meme!!")

handsUp.onNext(student2)
student2.onNext("student2: not Yet!!") // emit
student1.onNext("student1: me First!!")

handsUp.onNext(student3)
student2.onNext("student2: not Yet!! gogo!!")
student3.onNext("student3: hao~") // emit
student1.onNext("student1: when!!")

handsUp.onNext(student1)
student3.onNext("student3: talking!")
student1.onNext("student1: hands up!!~!") // emit
student2.onNext("student2: !!")
student2.onNext("student2: meme!!")
student1.onNext("student1: hands up!!~! 22222") // emit

// sequence 내의 element 간의 결합
print("----- reduce -----")
// 최종 결과값만을 방출한다.
Observable.from((1...10))
    .reduce(0, accumulator: { summary, newValue in
        return summary + newValue
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----- scan -----")
// 중간값들을 모두 방출한다.
Observable.from((1...3))
    .scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
