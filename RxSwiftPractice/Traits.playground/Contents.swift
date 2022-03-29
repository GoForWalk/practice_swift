import RxSwift

let disposeBag = DisposeBag()

enum TraitsError: Error {
case single
case maybe
case completable
}

print("----- Single 1 -----")
Single<String>.just("✅")
    .subscribe(
        onSuccess: {
            print($0)
        },
        onFailure: {
            print("Error: \($0.localizedDescription)")
        },
        onDisposed: {
            print("disposed")
        })
    .disposed(by: disposeBag)

print("----- Single 2 -----")
// Observable 에 asSingle() 메서드를 사용하여 변환.
Observable<String>.just("✅")
    .asSingle()
    .subscribe(
        onSuccess: {
            print($0)
        },
        onFailure: {
            print("Error: \($0.localizedDescription)")
        },
        onDisposed: {
            print("disposed")
        })
    .disposed(by: disposeBag)

// error 발생
print("----- Single Failure -----")
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.single)
    return Disposables.create()
}
.asSingle()
.subscribe(onSuccess: {
    print($0)
},
           onFailure: {
    print("Error: \($0.localizedDescription)")
},
           onDisposed: {
    print("disposed")
})
.disposed(by: disposeBag)

// Single 의 network 에서의 활용
print("----- Single 3 -----")
struct SomeJSON: Decodable {
    let name: String
    
}

enum JSONError: Error {
    case decodingError
}

let json1 = """
    {"name":"pop"}
    """

let json2 = """
    {"my_name":"Young"}
    """

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer -> Disposable in
        guard let data = json.data(using: .utf8),
                let json = try? JSONDecoder().decode(SomeJSON.self, from: data)
        else {
                    observer(.failure(JSONError.decodingError))
                    return Disposables.create()
                }
        
        observer(.success(json))
        return Disposables.create()
    }
}//: decode

decode(json: json1)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

decode(json: json2)
    .subscribe {
        switch $0 {
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)

print("----- maybe -----")
Maybe<String>.just("✅")
    .subscribe(
        onSuccess: {
            print($0)
        },
        onError: {
            print($0)
        },
        onCompleted: {
            print("completed")
        },
        onDisposed: {
            print("disposed")
        }
    ).disposed(by: disposeBag)

print("----- maybe Error -----")
Observable<String>.create { observer -> Disposable in
    observer.onError(TraitsError.maybe)
    return Disposables.create()
}
.asMaybe()
.subscribe(onSuccess: {
    print($0)
},
           onError: {
    print("Error : " + $0.localizedDescription)
},
           onCompleted: {
    print("complete")
},
           onDisposed: {
    print("disposed")
})
.disposed(by: disposeBag)

print("----- Completable Error -----")
Completable.create { observer -> Disposable in
    observer(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe(
    onCompleted: {
        print("completed")
    },
    onError: {
        print("error: \($0)")
    },
    onDisposed: {
        print("disposed")
    }).disposed(by: disposeBag)

print("----- Completable Success ------")
Completable.create { observer -> Disposable in
    observer(.completed)
    return Disposables.create()
}
.subscribe(
    onCompleted: {
        print("completed")
    },
    onError: {
        print("error: \($0)")
    },
    onDisposed: {
        print("disposed")
    }).disposed(by: disposeBag)
