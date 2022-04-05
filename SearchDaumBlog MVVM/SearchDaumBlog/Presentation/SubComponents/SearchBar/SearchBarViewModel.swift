//
//  SearchBarVoewModel.swift
//  SearchDaumBlog
//
//  Created by sae hun chung on 2022/03/31.
//

import RxCocoa
import RxSwift

// view에 관여하지 않아도 되는 로직
struct SearchBarViewModel {
    
    // searchBar 버든 탭 이벤트
    let searchBarButtonTapped = PublishRelay<Void>() // error를 받지 않고, onNext 만 방출하는 PublishSubject()
    
    let shouldLoadResult: Observable<String>
    let quaryText = PublishRelay<String?>()
    
    init() {
        // searchBar에 입력된 text를 받는다. -> trigger 역할
        self.shouldLoadResult = searchBarButtonTapped
            .withLatestFrom(quaryText) { $1 ?? "" } // text 가 없다면 "" (빈값)을 보낸다.
            .filter { !$0.isEmpty } // 빈 값을 보내지 않도록 필터처리
            .distinctUntilChanged()
                
    }
    
}
