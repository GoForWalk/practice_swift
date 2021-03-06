import RxSwift
let disposeBag = DisposeBag()

print("----- ignoreElements -----")
let ์ทจ์นจ๋ชจ๋๐ด = PublishSubject<String>()

์ทจ์นจ๋ชจ๋๐ด
    .ignoreElements() // elements emit์ ํ์ง ์๋๋ค.
    .subscribe {
        print("โ๏ธ", $0)
    }
    .disposed(by: disposeBag)

์ทจ์นจ๋ชจ๋๐ด.onNext("๐")
์ทจ์นจ๋ชจ๋๐ด.onNext("๐")
์ทจ์นจ๋ชจ๋๐ด.onNext("๐")
์ทจ์นจ๋ชจ๋๐ด.onNext("๐")

์ทจ์นจ๋ชจ๋๐ด.onCompleted()

print("----- elementAt ------")
let ๋๋ฒ์ธ๋ฉด๊นจ๋์ฌ๋ = PublishSubject<String>()

๋๋ฒ์ธ๋ฉด๊นจ๋์ฌ๋
    .element(at: 2) // ๋ ๋ฒ์งธ onNext๋ง emit, ๋๋จธ์ง๋ ๋ฌด์
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

๋๋ฒ์ธ๋ฉด๊นจ๋์ฌ๋.onNext("๐") // index 0
๋๋ฒ์ธ๋ฉด๊นจ๋์ฌ๋.onNext("๐") // index 1
๋๋ฒ์ธ๋ฉด๊นจ๋์ฌ๋.onNext("๐") // index 2
๋๋ฒ์ธ๋ฉด๊นจ๋์ฌ๋.onNext("๐") // index 3
๋๋ฒ์ธ๋ฉด๊นจ๋์ฌ๋.onNext("๐") // index 4

๋๋ฒ์ธ๋ฉด๊นจ๋์ฌ๋.onCompleted()

print("----- Filter ------") // ๊ฐ์ฅ ๋ํ์ ์ธ ํํฐ์ฐ์ฐ์.
Observable.of(1,2,3,4,5,6,7,8)
    .filter { $0 % 2 == 0 } // ๋ฐฉ์ถํ๊ณ ์ ํ๋ ์กฐ๊ฑด์ closure์ ์ ์ธ (true ์ผ๋๋ง ๋ฐฉ์ถ)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----- Skip -----") // ์ฒซ๋ฒ์งธ ์์๋ถํฐ n๋ฒ์งธ ์์๊น์ง skip (๋ฌด์)
Observable.of(1,2,3,4,5,6,7,8)
    .skip(5)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

print("----- skipWhile -----")
Observable.of(1,2,3,4,5,6,7,8)
    .skip(while: { // ์กฐ๊ฑด์ ๋ง์กฑํ ๋๊น์ง skip ๊ทธ ์ดํ์ ๋ชจ๋  element ๋ฐฉ์ถ
        // ํด๋น ๋ก์ง์ด false๊ฐ ๋์์ ๋๋ถํฐ element ๋ฐฉ์ถ
        $0 != 5
    })
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

print("----- skipUntil ------")
// ๋ค๋ฅธ observable ์ ๊ธฐ๋ฐํ ์์๋ค์ dynamic ํ๊ฒ filterํ๊ณ  ์ถ์ ๋!
let ์๋ = PublishSubject<String>()
let ๋ฌธ์ฌ๋์๊ฐ = PublishSubject<String>()

์๋ // ํ์ฌ observable
    .skip(until: ๋ฌธ์ฌ๋์๊ฐ) // ๋ค๋ฅธ observable ์ด onNext๋ฅผ ๋ฐฉ์ถํ๊ธฐ ์ ๊น์ง ํ์ฌ์ ๋ชจ๋  event ๋ฌด์
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
//๋ค๋ฅธ observable onNext ์  -> evnet ๋ฌด์
์๋.onNext("๐")
์๋.onNext("๐")
์๋.onNext("๐")

๋ฌธ์ฌ๋์๊ฐ.onNext("๋ก")
// ๋ค๋ฅธ observable onNext ํ -> event ๋ฐฉ์ถ
์๋.onNext("๐")

print("----- take ------")
Observable.of(1,2,3,4,5)
    .take(3) // 3๊ฐ๋ง ์ถ๋ ฅ๋๋ค. skip์ ๋ฐ๋๊ฐ๋
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----- takeWhile -----")
Observable.of(1,2,3,4,5,6,7)
    .take(while: {// ์กฐ๊ฑด์ด false๊ฐ ๋ ๋๊น์ง event ๋ฐฉ์ถ
        $0 != 5
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----- enumerated -----")
Observable.of(1,2,3,4,5)
    .enumerated() // ๋ฐฉ์ถ๋ ์์์ index ๊น์ง ์๊ณ  ์ถ์ ๊ฒฝ์ฐ -> index์ element๋ฅผ tuple ํ์์ผ๋ก return
    .takeWhile {
        $0.index < 3
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----- takeUntil -----")
let ์๊ฐ์ ์ฒญ = PublishSubject<String>()
let ์ ์ฒญ๋ง๊ฐ = PublishSubject<String>()

์๊ฐ์ ์ฒญ
    .take(until: ์ ์ฒญ๋ง๊ฐ)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

์๊ฐ์ ์ฒญ.onNext("Swift")
์๊ฐ์ ์ฒญ.onNext("Java")
์๊ฐ์ ์ฒญ.onNext("typeScript")

์ ์ฒญ๋ง๊ฐ.onNext("๋ก")

์๊ฐ์ ์ฒญ.onNext("C++")

print("----- distinctUntilChange -----")
Observable.of(1,1,2,2,3,3,4,4,1,1,1,1,5,5,6,6)
    .distinctUntilChanged() // ์ฐ๋ฌ์์ ๋ฐ๋ณต๋ element skip
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
