import RxSwift

let disposeBag = DisposeBag()

print("----- toArray -----")
Observable<String>.of("A", "B", "C")
    .toArray() // 각 element들을 하나의 Array로 변환
//    .subscribe(onSuccess: <#T##(([String]) -> Void)?##(([String]) -> Void)?##([String]) -> Void#>, onFailure: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    .subscribe(onSuccess: { // Single로 return 하기 때문에, subscribe가 single처럼 구성되어 있다.
     print($0)
    })
    .disposed(by: disposeBag)

print("----- map -----")
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----- flatMap -----")
// observable 속성을 갖는 observable은 어떻게 사용할 수 있을까?
// Observable<Observable<String>> 이런 형식
 
protocol 선수 {
    var 점수: BehaviorSubject<Int> { get }
}

struct 양궁선수: 선수 {
    var 점수: BehaviorSubject<Int>
}

let 🇰🇷국가대표 = 양궁선수(점수: BehaviorSubject<Int>(value: 10))

let 🇺🇸국가대표 = 양궁선수(점수: BehaviorSubject<Int>(value: 8))

let 올림픽경기 = PublishSubject<선수>() // BehaviorSubject를 갖는 Subject (중첩된 observable)

올림픽경기
    .flatMap { 선수 in // 중첩된 observable 내의 element를 뽑아낼 수 있다.
        선수.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

올림픽경기.onNext(🇰🇷국가대표)
🇰🇷국가대표.점수.onNext(10)

올림픽경기.onNext(🇺🇸국가대표)
🇰🇷국가대표.점수.onNext(10)
🇺🇸국가대표.점수.onNext(9)

print("----- flatMapLatest -----")
struct 높이뛰기선수 : 선수 {
    var 점수: BehaviorSubject<Int>
}

let seoul = 높이뛰기선수(점수: BehaviorSubject<Int>(value: 7))
let jeju = 높이뛰기선수(점수: BehaviorSubject<Int>(value: 6))

let competition = PublishSubject<선수>()

competition
    .flatMapLatest { 선수 in // 가장 최신의 값만 확인하고 싶을 경우 (network 에서 많이 사용한다.)
        선수.점수
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

competition.onNext(seoul) // 7
seoul.점수.onNext(9) // 9 -> 서울 변경

competition.onNext(jeju) // 6 -> 제주 구독 시작, 서울 sequence는 추척 해제
seoul.점수.onNext(10) // 서울은 이제 변화가 있어도 결과로 나타나지 않는다.
seoul.점수.onNext(10)
seoul.점수.onNext(10)
seoul.점수.onNext(10)
jeju.점수.onNext(8) // 제주 sequence의 변화는 반영
seoul.점수.onNext(10)
// flatMapList 사용 -> 검색어 입력시, 검색어 변화에 따른 추천검색어 refresh

print("----- materialize and dematerialize -----")
// Observable을 Observable의 event으로 변환이 필요한 경우
// -> 보통 observable 속성을 갖는 observable을 제어할 수 없고 외부적으로 observable이 종료되는 것을 방지하기 위해 error event를 처리하고 싶을 경우

enum 반칙: Error {
    case 부정출발
}

struct 달리기선수 : 선수 {
    var 점수: BehaviorSubject<Int>
}

let kim = 달리기선수(점수: BehaviorSubject<Int>(value: 0))
let park = 달리기선수(점수: BehaviorSubject<Int>(value: 1))

let 달리기100M = BehaviorSubject<선수>(value: kim)

달리기100M
    .flatMapLatest { 선수 in
        선수.점수
            .materialize()
    }
    .filter {
        guard let error = $0.error else {
            return true
        }
        print(error)
        return false
    }
    .dematerialize()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

kim.점수.onNext(1)
kim.점수.onError(반칙.부정출발) // error 인해 sequence stop
kim.점수.onNext(2)

달리기100M.onNext(park)

print("----- 전화번호 11자리 -----")
let input = PublishSubject<Int?>()

let list: [Int] = [1]

input
    .flatMap {
        $0 == nil
        ? Observable.empty()
        : Observable.just($0)
    }
    .map { $0! }
    .skip(while: { $0 != 0 })
    .take(11)
    .toArray()
    .asObservable()
    .map {
        $0.map { "\($0)" }
    }
    .map { numbers in
        var numberList = numbers
        numberList.insert("-", at: 3) // 010-
        numberList.insert("-", at: 8) // 010-1111-
        let number = numberList.reduce(" ", +)
        return number
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(2)
input.onNext(7)
input.onNext(3)
input.onNext(5)
input.onNext(nil)
input.onNext(9)
input.onNext(0)
input.onNext(1)
input.onNext(2)
input.onNext(9)
input.onNext(1)
input.onNext(4)
input.onNext(6)
input.onNext(8)
